import Foundation

/// 对外同步：飞书多维表格/机器人、企业微信、钉钉、通用 JSON
enum WebhookService {

    static func push(record: FaultRecord, settings: AppSettings,
                     completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: settings.webhookURL), !settings.webhookURL.isEmpty else {
            completion(.failure(WebhookError.badURL))
            return
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        var payload: [String: Any] = [:]
        var summary = "【设备故障】\(record.deviceName) · \(record.faultType) · \(record.urgency)"
        summary += "\n位置：\(record.location.isEmpty ? "未填写" : record.location)"
        summary += "\n描述：\(record.detail)"
        summary += "\n状态：\(record.status.rawValue)　报修：\(formatter.string(from: record.createdAt))"

        switch settings.webhookKind {
        case "企业微信群机器人":
            payload = ["msgtype": "text", "text": ["content": summary]]
        case "钉钉群机器人":
            payload = ["msgtype": "text", "text": ["content": summary]]
        case "飞书多维表格/机器人":
            payload = [
                "msg_type": "text",
                "content": ["text": summary]
            ]
        default:
            payload = [
                "device": record.deviceName,
                "deviceCode": record.deviceCode,
                "project": record.project,
                "location": record.location,
                "faultType": record.faultType,
                "urgency": record.urgency,
                "detail": record.detail,
                "status": record.status.rawValue,
                "createdAt": ISO8601DateFormatter().string(from: record.createdAt),
                "reporter": record.reporter,
                "owner": record.owner
            ]
        }

        guard let body = try? JSONSerialization.data(withJSONObject: payload) else {
            completion(.failure(WebhookError.badPayload))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        request.timeoutInterval = 20

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                let text = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
                completion(.failure(WebhookError.http(http.statusCode, text)))
                return
            }
            completion(.success(()))
        }.resume()
    }

    enum WebhookError: LocalizedError {
        case badURL
        case badPayload
        case http(Int, String)

        var errorDescription: String? {
            switch self {
            case .badURL: return "同步地址无效"
            case .badPayload: return "同步内容组装失败"
            case .http(let code, let text): return "服务返回 \(code)：\(text.prefix(120))"
            }
        }
    }
}
