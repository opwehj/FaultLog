import Foundation
import UIKit

/// AI 辅助：拍照预填、语音一句话结构化（OpenAI 兼容接口，需在设置里填 Key）
enum AIService {

    struct Suggestion {
        var detail: String = ""
        var faultType: String = ""
        var urgency: String = ""
        var deviceName: String = ""
        var deviceCode: String = ""
        var isEmpty: Bool {
            detail.isEmpty && faultType.isEmpty && urgency.isEmpty &&
            deviceName.isEmpty && deviceCode.isEmpty
        }
    }

    enum AIError: LocalizedError {
        case notConfigured
        case noImage
        case badResponse(String)

        var errorDescription: String? {
            switch self {
            case .notConfigured: return "还没配置 AI 接口（设置 → AI 辅助）"
            case .noImage: return "没有可用的照片"
            case .badResponse(let text): return "AI 返回异常：\(text)"
            }
        }
    }

    // MARK: - 拍照预填

    static func prefill(image: UIImage, settings: AppSettings,
                        completion: @escaping (Result<Suggestion, Error>) -> Void) {
        guard settings.aiEnabled, !settings.aiKey.isEmpty else {
            completion(.failure(AIError.notConfigured))
            return
        }
        guard let data = image.resized(maxSide: 900).jpegData(compressionQuality: 0.6) else {
            completion(.failure(AIError.noImage))
            return
        }
        let base64 = data.base64EncodedString()

        let instruction = """
        你是工厂设备维修工程师。看这张设备故障照片，给出简短结论。只输出 JSON，不要多余文字：
        {"deviceName":"设备名称或类型（如 3号包装机），不确定就留空",
         "deviceCode":"照片中能看清的设备编号/型号，看不清留空",
         "faultType":"从 机械故障/电气故障/漏油/异响/气路异常/其他 中选一个",
         "urgency":"从 一般/紧急/停机 中选一个",
         "detail":"客观描述故障现象、可见部位、可能原因，40字以内"}
        """

        let messages: [[String: Any]] = [
            [
                "role": "user",
                "content": [
                    ["type": "text", "text": instruction],
                    ["type": "image_url", "image_url": ["url": "data:image/jpeg;base64,\(base64)"]]
                ]
            ]
        ]
        post(messages: messages, settings: settings, completion: completion)
    }

    // MARK: - 语音一句话结构化

    static func structure(text: String, settings: AppSettings,
                          completion: @escaping (Result<Suggestion, Error>) -> Void) {
        guard settings.aiEnabled, !settings.aiKey.isEmpty else {
            completion(.failure(AIError.notConfigured))
            return
        }

        let instruction = """
        把下面这段现场口述拆成结构化字段。只输出 JSON，不要多余文字：
        {"deviceName":"设备名称","deviceCode":"编号，没有就留空",
         "faultType":"从 机械故障/电气故障/漏油/异响/气路异常/其他 中选一个",
         "urgency":"从 一般/紧急/停机 中选一个",
         "detail":"整理成通顺的问题描述"}
        口述内容：\(text)
        """

        let messages: [[String: Any]] = [
            ["role": "user", "content": instruction]
        ]
        post(messages: messages, settings: settings, completion: completion)
    }

    // MARK: - 请求

    private static func post(messages: [[String: Any]], settings: AppSettings,
                             completion: @escaping (Result<Suggestion, Error>) -> Void) {
        var base = settings.aiBaseURL
        if base.hasSuffix("/") { base.removeLast() }
        guard let url = URL(string: base + "/chat/completions") else {
            completion(.failure(AIError.notConfigured))
            return
        }

        let body: [String: Any] = [
            "model": settings.aiModel.isEmpty ? "doubao-vision" : settings.aiModel,
            "messages": messages,
            "temperature": 0.2
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(settings.aiKey)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 40
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            guard let data = data, let text = String(data: data, encoding: .utf8) else {
                DispatchQueue.main.async { completion(.failure(AIError.badResponse("空响应"))) }
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let choices = json["choices"] as? [[String: Any]],
                  let message = choices.first?["message"] as? [String: Any] else {
                let brief = String(text.prefix(120))
                DispatchQueue.main.async { completion(.failure(AIError.badResponse(brief))) }
                return
            }

            var content: String = ""
            if let string = message["content"] as? String {
                content = string
            } else if let array = message["content"] as? [[String: Any]] {
                content = array.compactMap { $0["text"] as? String }.joined()
            }

            let suggestion = parse(content)
            DispatchQueue.main.async { completion(.success(suggestion)) }
        }.resume()
    }

    private static func parse(_ content: String) -> Suggestion {
        var suggestion = Suggestion()
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let start = trimmed.firstIndex(of: "{"),
              let end = trimmed.lastIndex(of: "}") else {
            suggestion.detail = trimmed
            return suggestion
        }
        let jsonText = String(trimmed[start...end])
        guard let data = jsonText.data(using: .utf8),
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            suggestion.detail = trimmed
            return suggestion
        }
        suggestion.detail = (dict["detail"] as? String) ?? ""
        suggestion.faultType = (dict["faultType"] as? String) ?? ""
        suggestion.urgency = (dict["urgency"] as? String) ?? ""
        suggestion.deviceName = (dict["deviceName"] as? String) ?? ""
        suggestion.deviceCode = (dict["deviceCode"] as? String) ?? ""
        return suggestion
    }
}
