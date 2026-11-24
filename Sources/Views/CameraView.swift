import SwiftUI
import AVFoundation
import UIKit

/// 自定义全屏相机：黑色铺满全屏，底部只有拍照 / 取消 / 翻转镜头，
/// 拍完立刻回报并关闭，不再使用系统相机的白色上下条。
struct CameraView: View {

    let hint: String
    let onImage: (UIImage?) -> Void

    @StateObject private var controller = CameraController()
    @Environment(\.dismiss) private var dismiss
    @State private var flash = false

    init(hint: String = "拍完自动填入台账", onImage: @escaping (UIImage?) -> Void) {
        self.hint = hint
        self.onImage = onImage
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if controller.denied {
                deniedView
            } else {
                CameraPreview(session: controller.session)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)

                VStack {
                    topBar
                    Spacer()
                    bottomBar
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .statusBarHidden(false)
        .onAppear {
            controller.onCapture = { image in
                dismiss()
                onImage(image)
            }
            controller.start()
        }
        .onDisappear {
            controller.stop()
        }
    }

    private var topBar: some View {
        HStack {
            Text(hint)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.85))
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(Color.black.opacity(0.35))
                .cornerRadius(14)
            Spacer()
        }
        .padding(.horizontal, 18)
        .padding(.top, 6)
    }

    private var bottomBar: some View {
        VStack(spacing: 14) {
            HStack {
                Button {
                    controller.flip()
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath.camera")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 52, height: 52)
                        .background(Color.white.opacity(0.15))
                        .clipShape(Circle())
                }

                Spacer()

                Button {
                    controller.capture()
                } label: {
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.9), lineWidth: 3)
                            .frame(width: 76, height: 76)
                        Circle()
                            .fill(Color.white)
                            .frame(width: 62, height: 62)
                    }
                }
                .buttonStyle(.plain)

                Spacer()

                Button {
                    dismiss()
                    onImage(nil)
                } label: {
                    Text("取消")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 52, height: 52)
                        .background(Color.white.opacity(0.15))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 28)
        }
        .padding(.bottom, 34)
        .background(
            LinearGradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.55)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
    }

    private var deniedView: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.fill")
                .font(.system(size: 44))
                .foregroundColor(.white.opacity(0.7))
            Text("没有相机权限")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
            Text("在「设置 → 故障台账」里打开相机权限后重试，或改用相册上传。")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text("去设置")
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.horizontal, 28)
                    .padding(.vertical, 11)
                    .background(Color(red: 0.95, green: 0.57, blue: 0.15))
                    .foregroundColor(.white)
                    .cornerRadius(22)
            }
            Button {
                dismiss()
                onImage(nil)
            } label: {
                Text("返回")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.75))
            }
        }
    }
}

/// 相机控制与拍摄
final class CameraController: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {

    let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private var configured = false
    private var capturing = false

    @Published var denied = false
    var onCapture: ((UIImage?) -> Void)?

    func start() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configure()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.configure()
                    } else {
                        self.denied = true
                    }
                }
            }
        default:
            denied = true
        }
    }

    func stop() {
        guard session.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.stopRunning()
        }
    }

    private func configure() {
        guard !configured else { return }
        configured = true

        session.beginConfiguration()
        session.sessionPreset = .photo
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
           let input = try? AVCaptureDeviceInput(device: device),
           session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.isHighResolutionCaptureEnabled = true
        }
        session.commitConfiguration()

        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }

    func flip() {
        guard let current = session.inputs.first as? AVCaptureDeviceInput else { return }
        let target: AVCaptureDevice.Position = current.device.position == .back ? .front : .back
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: target),
              let input = try? AVCaptureDeviceInput(device: device) else { return }
        session.beginConfiguration()
        session.removeInput(current)
        if session.canAddInput(input) {
            session.addInput(input)
        }
        session.commitConfiguration()
    }

    func capture() {
        guard !capturing else { return }
        capturing = true
        let settings = AVCapturePhotoSettings()
        settings.isHighResolutionPhotoEnabled = true
        output.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        capturing = false
        guard error == nil,
              let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            DispatchQueue.main.async { self.onCapture?(nil) }
            return
        }
        DispatchQueue.main.async { self.onCapture?(image) }
    }
}

/// 取景预览
struct CameraPreview: UIViewRepresentable {

    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewUIView {
        let view = PreviewUIView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        view.backgroundColor = .black
        return view
    }

    func updateUIView(_ uiView: PreviewUIView, context: Context) {}

    final class PreviewUIView: UIView {
        let previewLayer = AVCaptureVideoPreviewLayer()

        override init(frame: CGRect) {
            super.init(frame: frame)
            layer.addSublayer(previewLayer)
            backgroundColor = .black
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            previewLayer.frame = bounds
            CATransaction.commit()
        }
    }
}
