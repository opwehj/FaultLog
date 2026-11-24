import UIKit
import CoreImage

/// 设备二维码标签生成
enum QRCodeMaker {

    static func image(from text: String, scale: CGFloat = 12) -> UIImage? {
        let context = CIContext()
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(Data(text.utf8), forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel")
        guard let output = filter.outputImage else { return nil }
        let transformed = output.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        guard let cgImage = context.createCGImage(transformed, from: transformed.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }

    /// 生成一张可直接打印/分享的标签（二维码 + 设备名 + 编号）
    static func label(device: DeviceItem, width: CGFloat = 900) -> UIImage {
        let height: CGFloat = 1180
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        return UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: format).image { context in
            UIColor.white.setFill()
            context.fill(CGRect(x: 0, y: 0, width: width, height: height))

            UIColor(red: 0.10, green: 0.16, blue: 0.24, alpha: 1).setFill()
            context.fill(CGRect(x: 0, y: 0, width: width, height: 120))

            let title = NSAttributedString(string: "设备编号标签", attributes: [
                .font: UIFont.systemFont(ofSize: 44, weight: .bold),
                .foregroundColor: UIColor.white
            ])
            title.draw(at: CGPoint(x: 48, y: 36))

            if let qr = image(from: device.code.isEmpty ? device.name : device.code, scale: 16) {
                let side: CGFloat = width - 200
                qr.draw(in: CGRect(x: 100, y: 190, width: side, height: side))
            }

            let name = NSAttributedString(string: device.name, attributes: [
                .font: UIFont.systemFont(ofSize: 52, weight: .bold),
                .foregroundColor: UIColor(white: 0.1, alpha: 1)
            ])
            let nameSize = name.size()
            name.draw(at: CGPoint(x: (width - nameSize.width) / 2, y: 830))

            let code = NSAttributedString(string: device.code.isEmpty ? "（无编号）" : device.code, attributes: [
                .font: UIFont.monospacedSystemFont(ofSize: 40, weight: .medium),
                .foregroundColor: UIColor(white: 0.35, alpha: 1)
            ])
            let codeSize = code.size()
            code.draw(at: CGPoint(x: (width - codeSize.width) / 2, y: 910))

            if !device.location.isEmpty {
                let location = NSAttributedString(string: device.location, attributes: [
                    .font: UIFont.systemFont(ofSize: 34, weight: .regular),
                    .foregroundColor: UIColor(white: 0.45, alpha: 1)
                ])
                let locationSize = location.size()
                location.draw(at: CGPoint(x: (width - locationSize.width) / 2, y: 990))
            }

            let tip = NSAttributedString(string: "扫码报修 · 拍故障照片自动带出设备", attributes: [
                .font: UIFont.systemFont(ofSize: 28, weight: .regular),
                .foregroundColor: UIColor(white: 0.55, alpha: 1)
            ])
            let tipSize = tip.size()
            tip.draw(at: CGPoint(x: (width - tipSize.width) / 2, y: height - 90))
        }
    }
}
