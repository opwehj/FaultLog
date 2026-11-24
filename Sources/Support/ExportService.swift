import Foundation
import UIKit

/// 导出：CSV / xlsx / 图文 HTML 报告
enum ExportService {

    static func headers(settings: AppSettings) -> [String] {
        var list = ["时间", "项目/客户", "设备名称", "设备编号", "位置/工位", "故障类型",
                    "紧急程度", "问题描述", "处理状态", "报修人", "责任人",
                    "停机开始", "恢复时间", "停机分钟", "根因", "处理措施", "更换备件",
                    "费用(元)", "照片数"]
        for field in settings.customFields {
            list.append(field.name)
        }
        return list
    }

    static func rows(records: [FaultRecord], settings: AppSettings) -> [[String]] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        return records.map { record in
            var row: [String] = [
                formatter.string(from: record.createdAt),
                record.project,
                record.deviceName,
                record.deviceCode,
                record.location,
                record.faultType,
                record.urgency,
                record.detail,
                record.status.rawValue,
                record.reporter,
                record.owner,
                record.startTime.map { formatter.string(from: $0) } ?? "",
                record.endTime.map { formatter.string(from: $0) } ?? "",
                record.downtimeMinutes.map { String(format: "%.0f", $0) } ?? "",
                record.rootCause,
                record.action,
                record.parts,
                record.cost.map { String(format: "%.2f", $0) } ?? "",
                "\(record.photos.count)"
            ]
            for field in settings.customFields {
                row.append(record.customValues[field.id.uuidString] ?? "")
            }
            return row
        }
    }

    // MARK: - CSV

    static func exportCSV(records: [FaultRecord], settings: AppSettings) -> URL? {
        let head = headers(settings: settings)
        let rows = self.rows(records: records, settings: settings)
        var csv = "\u{FEFF}"
        csv += head.map(csvEscape).joined(separator: ",") + "\n"
        for row in rows {
            csv += row.map(csvEscape).joined(separator: ",") + "\n"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmm"
        let url = FaultStore.documentsDirectory
            .appendingPathComponent("设备故障台账_\(formatter.string(from: Date())).csv")
        do {
            try csv.write(to: url, atomically: true, encoding: .utf8)
            return url
        } catch {
            print("CSV 导出失败：\(error)")
            return nil
        }
    }

    private static func csvEscape(_ value: String) -> String {
        if value.contains(",") || value.contains("\"") || value.contains("\n") {
            return "\"" + value.replacingOccurrences(of: "\"", with: "\"\"") + "\""
        }
        return value
    }

    // MARK: - xlsx

    static func exportXLSX(records: [FaultRecord], settings: AppSettings) -> URL? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmm"
        let url = FaultStore.documentsDirectory
            .appendingPathComponent("设备故障台账_\(formatter.string(from: Date())).xlsx")
        let sheet = XLSXWriter.Sheet(
            name: "故障台账",
            header: headers(settings: settings),
            rows: self.rows(records: records, settings: settings)
        )
        do {
            try XLSXWriter.build(sheet: sheet, to: url)
            return url
        } catch {
            print("xlsx 导出失败：\(error)")
            return nil
        }
    }

    // MARK: - 图文 HTML 报告

    static func exportHTML(records: [FaultRecord], store: FaultStore, settings: AppSettings,
                           title: String = "设备故障台账") -> URL? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        var html = """
        <!DOCTYPE html>
        <html lang="zh-CN"><head><meta charset="utf-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>\(title)</title>
        <style>
        :root{--navy:#1B2A41;--orange:#F3923B}
        body{font-family:-apple-system,"PingFang SC",sans-serif;margin:0;padding:0;background:#f4f6f9;color:#1f2937}
        header{background:var(--navy);color:#fff;padding:20px 16px}
        header h1{margin:0;font-size:20px}
        header p{margin:6px 0 0;font-size:12px;color:#c9d3e0}
        .wrap{padding:14px 16px 30px}
        .item{background:#fff;border-radius:14px;padding:14px;margin-bottom:12px;box-shadow:0 1px 4px rgba(16,24,40,.08)}
        .head{display:flex;justify-content:space-between;align-items:baseline;gap:8px}
        .device{font-size:16px;font-weight:600}
        .badge{font-size:11px;padding:3px 9px;border-radius:20px;white-space:nowrap}
        .pending{background:#fff4e5;color:#b45309}
        .doing{background:#e8f1ff;color:#1d4ed8}
        .fixed{background:#e9f7ef;color:#15803d}
        .rows{margin-top:8px;display:flex;flex-wrap:wrap;gap:6px}
        .chip{font-size:11px;background:#f3f4f6;color:#4b5563;padding:3px 8px;border-radius:8px}
        .desc{font-size:14px;margin-top:10px;line-height:1.55;white-space:pre-wrap}
        .photos{display:flex;gap:8px;margin-top:10px;flex-wrap:wrap}
        .photos img{width:calc(33.33% - 6px);border-radius:10px;display:block}
        .warn{color:#b91c1c;font-weight:600}
        </style></head><body>
        <header><h1>\(title)</h1><p>导出时间：\(formatter.string(from: Date()))　共 \(records.count) 条</p></header>
        <div class="wrap">
        """

        for record in records {
            let statusClass: String
            switch record.status {
            case .pending: statusClass = "pending"
            case .doing: statusClass = "doing"
            case .fixed: statusClass = "fixed"
            }

            html += "<div class=\"item\">"
            html += "<div class=\"head\"><span class=\"device\">\(htmlEscape(record.deviceName.isEmpty ? "未填写设备" : record.deviceName))</span>"
            html += "<span class=\"badge \(statusClass)\">\(htmlEscape(record.status.rawValue))</span></div>"

            html += "<div class=\"rows\">"
            html += "<span class=\"chip\">\(formatter.string(from: record.createdAt))</span>"
            if !record.project.isEmpty { html += "<span class=\"chip\">\(htmlEscape(record.project))</span>" }
            if !record.location.isEmpty { html += "<span class=\"chip\">\(htmlEscape(record.location))</span>" }
            if !record.deviceCode.isEmpty { html += "<span class=\"chip\">#\(htmlEscape(record.deviceCode))</span>" }
            html += "<span class=\"chip\">\(htmlEscape(record.faultType))</span>"
            let urgencyClass = record.urgency == FaultCatalog.urgencies[0] ? "chip" : "chip warn"
            html += "<span class=\"\(urgencyClass)\">\(htmlEscape(record.urgency))</span>"
            if let minutes = record.downtimeMinutes {
                html += "<span class=\"chip\">停机 \(String(format: "%.0f", minutes)) 分钟</span>"
            }
            if !record.owner.isEmpty { html += "<span class=\"chip\">责任人 \(htmlEscape(record.owner))</span>" }
            for field in settings.customFields {
                if let value = record.customValues[field.id.uuidString], !value.isEmpty {
                    html += "<span class=\"chip\">\(htmlEscape(field.name))：\(htmlEscape(value))</span>"
                }
            }
            html += "</div>"

            html += "<div class=\"desc\">\(htmlEscape(record.detail))</div>"
            if !record.rootCause.isEmpty {
                html += "<div class=\"desc\"><b>根因：</b>\(htmlEscape(record.rootCause))</div>"
            }
            if !record.action.isEmpty {
                html += "<div class=\"desc\"><b>措施：</b>\(htmlEscape(record.action))</div>"
            }

            if !record.photos.isEmpty {
                html += "<div class=\"photos\">"
                for name in record.photos.prefix(6) {
                    if let data = store.photoData(named: name) {
                        html += "<img src=\"data:image/jpeg;base64,\(data.base64EncodedString())\" alt=\"故障照片\">"
                    }
                }
                html += "</div>"
            }

            html += "</div>"
        }

        html += "</div></body></html>"

        let formatterFile = DateFormatter()
        formatterFile.dateFormat = "yyyyMMdd_HHmm"
        let url = FaultStore.documentsDirectory
            .appendingPathComponent("设备故障报告_\(formatterFile.string(from: Date())).html")
        do {
            try html.write(to: url, atomically: true, encoding: .utf8)
            return url
        } catch {
            print("HTML 导出失败：\(error)")
            return nil
        }
    }

    static func htmlEscape(_ value: String) -> String {
        value
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
    }
}
