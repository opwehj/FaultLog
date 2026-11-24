import Foundation
import Combine
import UIKit

/// 数据仓库：负责记录的本地持久化、照片存取与导出
final class FaultStore: ObservableObject {

    @Published private(set) var records: [FaultRecord] = []

    private let fileManager = FileManager.default

    private var documentsURL: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private var dataURL: URL {
        documentsURL.appendingPathComponent("fault_records.json")
    }

    init() {
        load()
    }

    // MARK: - 读写

    func load() {
        guard let data = try? Data(contentsOf: dataURL),
              let decoded = try? JSONDecoder().decode([FaultRecord].self, from: data) else {
            records = []
            return
        }
        records = decoded.sorted { $0.createdAt > $1.createdAt }
    }

    private func persist() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(records)
            try data.write(to: dataURL, options: .atomic)
        } catch {
            print("记录保存失败：\(error)")
        }
    }

    // MARK: - 增删改

    func add(_ record: FaultRecord) {
        records.insert(record, at: 0)
        persist()
    }

    func update(_ record: FaultRecord) {
        guard let index = records.firstIndex(where: { $0.id == record.id }) else { return }
        records[index] = record
        persist()
    }

    func delete(_ record: FaultRecord) {
        if let name = record.photoFileName {
            deletePhoto(named: name)
        }
        records.removeAll { $0.id == record.id }
        persist()
    }

    func delete(at offsets: IndexSet) {
        let targets = offsets.compactMap { index -> FaultRecord? in
            guard records.indices.contains(index) else { return nil }
            return records[index]
        }
        for record in targets {
            delete(record)
        }
    }

    // MARK: - 照片

    /// 保存图片，返回文件名
    func savePhoto(_ image: UIImage) -> String? {
        let resized = image.resized(maxSide: 1600)
        guard let data = resized.jpegData(compressionQuality: 0.7) else { return nil }
        let name = "fault_\(UUID().uuidString.prefix(8)).jpg"
        let url = documentsURL.appendingPathComponent(name)
        do {
            try data.write(to: url, options: .atomic)
            return name
        } catch {
            print("照片保存失败：\(error)")
            return nil
        }
    }

    func photoData(named name: String?) -> Data? {
        guard let name = name else { return nil }
        return try? Data(contentsOf: documentsURL.appendingPathComponent(name))
    }

    func photo(named name: String?) -> UIImage? {
        guard let data = photoData(named: name) else { return nil }
        return UIImage(data: data)
    }

    func deletePhoto(named name: String) {
        try? fileManager.removeItem(at: documentsURL.appendingPathComponent(name))
    }

    // MARK: - 导出 CSV（Excel 可直接打开）

    func exportCSV() -> URL? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        var csv = "\u{FEFF}" // UTF-8 BOM，避免 Excel 中文乱码
        csv += "时间,设备名称,位置,故障类型,紧急程度,问题描述,处理状态,照片文件\n"

        for record in records {
            let cells = [
                formatter.string(from: record.createdAt),
                record.deviceName,
                record.location,
                record.faultType,
                record.urgency,
                record.detail,
                record.status.rawValue,
                record.photoFileName ?? ""
            ]
            csv += cells.map(csvEscape).joined(separator: ",") + "\n"
        }

        let url = documentsURL.appendingPathComponent("设备故障台账.csv")
        do {
            try csv.write(to: url, atomically: true, encoding: .utf8)
            return url
        } catch {
            print("CSV 导出失败：\(error)")
            return nil
        }
    }

    private func csvEscape(_ value: String) -> String {
        if value.contains(",") || value.contains("\"") || value.contains("\n") {
            return "\"" + value.replacingOccurrences(of: "\"", with: "\"\"") + "\""
        }
        return value
    }

    // MARK: - 导出图文报告（单个 HTML，含照片，方便发给客户/维修）

    func exportHTML() -> URL? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        var html = """
        <!DOCTYPE html>
        <html lang="zh-CN"><head><meta charset="utf-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>设备故障台账</title>
        <style>
        body{font-family:-apple-system,"PingFang SC",sans-serif;margin:0;padding:16px;background:#f5f7fa;color:#1f2937}
        h1{font-size:20px;margin:8px 0 4px}
        .meta{color:#6b7280;font-size:13px;margin-bottom:16px}
        .item{background:#fff;border-radius:12px;padding:14px;margin-bottom:12px;box-shadow:0 1px 3px rgba(0,0,0,.08)}
        .head{display:flex;justify-content:space-between;align-items:baseline;gap:8px}
        .device{font-size:16px;font-weight:600}
        .tag{font-size:12px;padding:2px 8px;border-radius:10px;background:#eff6ff;color:#1d4ed8;white-space:nowrap}
        .row{font-size:13px;color:#4b5563;margin-top:6px}
        .desc{font-size:14px;margin-top:8px;line-height:1.5;white-space:pre-wrap}
        img{width:100%;border-radius:8px;margin-top:10px;display:block}
        </style></head><body>
        <h1>设备故障台账</h1>
        <div class="meta">导出时间：\(formatter.string(from: Date()))　共 \(records.count) 条</div>
        """

        for record in records {
            html += """
            <div class="item">
            <div class="head"><span class="device">\(htmlEscape(record.deviceName.isEmpty ? "未填写设备" : record.deviceName))</span><span class="tag">\(htmlEscape(record.status.rawValue))</span></div>
            <div class="row">\(formatter.string(from: record.createdAt))　|　\(htmlEscape(record.location.isEmpty ? "—" : record.location))　|　\(htmlEscape(record.faultType))　|　\(htmlEscape(record.urgency))</div>
            <div class="desc">\(htmlEscape(record.detail))</div>
            """

            if let data = photoData(named: record.photoFileName) {
                let base64 = data.base64EncodedString()
                html += "<img src=\"data:image/jpeg;base64,\(base64)\" alt=\"故障照片\">"
            }

            html += "</div>"
        }

        html += "</body></html>"

        let url = documentsURL.appendingPathComponent("设备故障台账.html")
        do {
            try html.write(to: url, atomically: true, encoding: .utf8)
            return url
        } catch {
            print("HTML 导出失败：\(error)")
            return nil
        }
    }

    private func htmlEscape(_ value: String) -> String {
        value
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
    }
}
