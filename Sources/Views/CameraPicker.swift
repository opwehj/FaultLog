import SwiftUI
import PhotosUI
import UIKit

/// 系统相机（拍照片 / 拍视频；无相机时回退相册）
struct CameraPicker: UIViewControllerRepresentable {

    enum Mode {
        case photo
        case video
    }

    var mode: Mode = .photo
    let onImage: (UIImage?) -> Void
    var onVideo: ((URL?) -> Void)? = nil

    func makeCoordinator() -> Coordinator {
        Coordinator(onImage: onImage, onVideo: onVideo)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        let hasCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
        picker.sourceType = hasCamera ? .camera : .photoLibrary
        switch mode {
        case .photo:
            picker.mediaTypes = ["public.image"]
        case .video:
            picker.mediaTypes = ["public.movie"]
            picker.videoQuality = .typeMedium
            picker.mediaTypes = hasCamera ? ["public.movie"] : ["public.movie"]
        }
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        let onImage: (UIImage?) -> Void
        let onVideo: ((URL?) -> Void)?

        init(onImage: @escaping (UIImage?) -> Void, onVideo: ((URL?) -> Void)?) {
            self.onImage = onImage
            self.onVideo = onVideo
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let url = info[.mediaURL] as? URL {
                onVideo?(url)
                return
            }
            onImage(info[.originalImage] as? UIImage)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            onImage(nil)
            onVideo?(nil)
        }
    }
}

/// 从相册多选照片
struct PhotoLibraryPicker: UIViewControllerRepresentable {

    let limit: Int
    let onImages: ([UIImage]) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onImages: onImages)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = max(limit, 1)
        config.preferredAssetRepresentationMode = .compatible
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    final class Coordinator: NSObject, PHPickerViewControllerDelegate {

        let onImages: ([UIImage]) -> Void

        init(onImages: @escaping ([UIImage]) -> Void) {
            self.onImages = onImages
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            var images: [UIImage] = []
            let group = DispatchGroup()
            for result in results {
                group.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
                    if let image = object as? UIImage {
                        images.append(image)
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                self.onImages(images)
            }
        }
    }
}

/// 系统分享面板
struct ShareSheet: UIViewControllerRepresentable {

    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
