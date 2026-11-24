import SwiftUI
import PhotosUI
import UIKit

/// 系统相机（拍照片 / 拍视频），以真正的全屏方式从最上层控制器弹出，
/// 保留原相机的取景范围与 0.5 / 1 / 3 倍镜头切换。
enum CameraPresenter {

    private static var delegates: [CameraPresenterDelegate] = []

    static func present(mode: CameraPicker.Mode,
                        onImage: @escaping (UIImage?) -> Void,
                        onVideo: ((URL?) -> Void)? = nil) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            onImage(nil)
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = false
        picker.modalPresentationStyle = .fullScreen
        picker.modalTransitionStyle = .coverVertical
        switch mode {
        case .photo:
            picker.mediaTypes = ["public.image"]
            picker.cameraCaptureMode = .photo
        case .video:
            picker.mediaTypes = ["public.movie"]
            picker.videoQuality = .typeMedium
            picker.cameraCaptureMode = .video
        }

        let delegate = CameraPresenterDelegate(onImage: onImage, onVideo: onVideo)
        delegates.append(delegate)
        picker.delegate = delegate

        DispatchQueue.main.async {
            guard let top = topViewController() else {
                release(delegate)
                onImage(nil)
                return
            }
            top.present(picker, animated: true)
        }
    }

    fileprivate static func release(_ delegate: CameraPresenterDelegate) {
        delegates.removeAll { $0 === delegate }
    }

    private static func topViewController() -> UIViewController? {
        let windows = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
        guard let root = windows.first(where: { $0.isKeyWindow })?.rootViewController ?? windows.first?.rootViewController else {
            return nil
        }
        return top(from: root)
    }

    private static func top(from controller: UIViewController) -> UIViewController {
        if let presented = controller.presentedViewController {
            return top(from: presented)
        }
        if let nav = controller as? UINavigationController, let visible = nav.visibleViewController {
            return top(from: visible)
        }
        if let tab = controller as? UITabBarController, let selected = tab.selectedViewController {
            return top(from: selected)
        }
        return controller
    }
}

final class CameraPresenterDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let onImage: (UIImage?) -> Void
    private let onVideo: ((URL?) -> Void)?

    init(onImage: @escaping (UIImage?) -> Void, onVideo: ((URL?) -> Void)?) {
        self.onImage = onImage
        self.onVideo = onVideo
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        if let url = info[.mediaURL] as? URL {
            onVideo?(url)
        } else {
            onImage(info[.originalImage] as? UIImage)
        }
        DispatchQueue.main.async { CameraPresenter.release(self) }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        onImage(nil)
        onVideo?(nil)
        DispatchQueue.main.async { CameraPresenter.release(self) }
    }
}

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
        picker.modalPresentationStyle = .fullScreen
        let hasCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
        picker.sourceType = hasCamera ? .camera : .photoLibrary
        switch mode {
        case .photo:
            picker.mediaTypes = ["public.image"]
            if hasCamera { picker.cameraCaptureMode = .photo }
        case .video:
            picker.mediaTypes = ["public.movie"]
            picker.videoQuality = .typeMedium
            if hasCamera { picker.cameraCaptureMode = .video }
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
            picker.dismiss(animated: true)
            if let url = info[.mediaURL] as? URL {
                onVideo?(url)
                return
            }
            onImage(info[.originalImage] as? UIImage)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
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
