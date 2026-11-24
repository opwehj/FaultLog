import UIKit
import Vision

/// 端侧文字识别：铭牌 / 型号 / 设备编号
enum OCRService {

    static func recognize(_ image: UIImage, completion: @escaping (String) -> Void) {
        guard let cgImage = image.cgImage else {
            completion("")
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    print("OCR 失败：\(error)")
                    DispatchQueue.main.async { completion("") }
                    return
                }
                let observations = request.results as? [VNRecognizedTextObservation] ?? []
                let lines = observations.compactMap { $0.topCandidates(1).first?.string }
                DispatchQueue.main.async { completion(lines.joined(separator: " ")) }
            }
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["zh-Hans", "en-US"]
            request.usesLanguageCorrection = true

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                print("OCR 执行失败：\(error)")
                DispatchQueue.main.async { completion("") }
            }
        }
    }
}
