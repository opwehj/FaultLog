import UIKit

/// 导出 PDF 报告（A4，按记录分块，含照片）
enum PDFReport {

    static func build(records: [FaultRecord], store: FaultStore, title: String,
                      settings: AppSettings) -> URL? {
        let pageSize = CGSize(width: 595, height: 842)
        let margin: CGFloat = 34
        let contentWidth = pageSize.width - margin * 2

        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "zh_CN")
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))

        let data = renderer.pdfData { context in
            var pageNumber = 0
            var cursorY: CGFloat = 0

            func beginPage() {
                context.beginPage()
                pageNumber += 1
                cursorY = margin

                UIColor(red: 0.10, green: 0.16, blue: 0.24, alpha: 1).setFill()
                context.fill(CGRect(x: 0, y: 0, width: pageSize.width, height: 70))
                let heading = NSAttributedString(string: title, attributes: [
                    .font: UIFont.systemFont(ofSize: 19, weight: .bold),
                    .foregroundColor: UIColor.white
                ])
                heading.draw(at: CGPoint(x: margin, y: 22))

                let sub = NSAttributedString(
                    string: "共 \(records.count) 条 · 导出 \(timeFormatter.string(from: Date()))",
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 9, weight: .regular),
                        .foregroundColor: UIColor(white: 0.8, alpha: 1)
                    ]
                )
                let subSize = sub.size()
                sub.draw(at: CGPoint(x: pageSize.width - margin - subSize.width, y: 26))
                cursorY = 86
            }

            func ensureSpace(_ height: CGFloat) {
                if cursorY + height > pageSize.height - 40 {
                    let footer = NSAttributedString(string: "第 \(pageNumber) 页", attributes: [
                        .font: UIFont.systemFont(ofSize: 8),
                        .foregroundColor: UIColor(white: 0.5, alpha: 1)
                    ])
                    footer.draw(at: CGPoint(x: pageSize.width / 2 - 20, y: pageSize.height - 28))
                    beginPage()
                }
            }

            func drawText(_ text: String, font: UIFont, color: UIColor,
                          x: CGFloat, width: CGFloat, lineSpacing: CGFloat = 2) -> CGFloat {
                let paragraph = NSMutableParagraphStyle()
                paragraph.lineSpacing = lineSpacing
                let attributed = NSAttributedString(string: text, attributes: [
                    .font: font,
                    .foregroundColor: color,
                    .paragraphStyle: paragraph
                ])
                let rect = attributed.boundingRect(
                    with: CGSize(width: width, height: .greatestFiniteMagnitude),
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    context: nil
                )
                attributed.draw(in: CGRect(x: x, y: cursorY, width: width, height: ceil(rect.height)))
                let used = ceil(rect.height)
                cursorY += used
                return used
            }

            beginPage()

            for (index, record) in records.enumerated() {
                ensureSpace(120)

                // 序号 + 设备
                let header = "\(index + 1). \(record.deviceName.isEmpty ? "未填写设备" : record.deviceName)"
                cursorY += drawText(header, font: .systemFont(ofSize: 13, weight: .bold),
                                    color: UIColor(white: 0.1, alpha: 1), x: margin, width: contentWidth - 90)

                let status = NSAttributedString(string: "\(record.status.rawValue) · \(record.urgency)", attributes: [
                    .font: UIFont.systemFont(ofSize: 9, weight: .semibold),
                    .foregroundColor: UIColor(red: 0.85, green: 0.45, blue: 0.05, alpha: 1)
                ])
                status.draw(at: CGPoint(x: pageSize.width - margin - status.size().width, y: cursorY - 16))

                var meta = timeFormatter.string(from: record.createdAt)
                if !record.project.isEmpty { meta += " · \(record.project)" }
                if !record.location.isEmpty { meta += " · \(record.location)" }
                if !record.deviceCode.isEmpty { meta += " · \(record.deviceCode)" }
                cursorY += 2
                cursorY += drawText(meta, font: .systemFont(ofSize: 9, weight: .regular),
                                    color: UIColor(white: 0.45, alpha: 1), x: margin, width: contentWidth)

                cursorY += 4
                ensureSpace(60)
                cursorY += drawText(record.detail, font: .systemFont(ofSize: 10),
                                    color: UIColor(white: 0.15, alpha: 1), x: margin, width: contentWidth)

                var extra: [String] = []
                if !record.reporter.isEmpty { extra.append("报修人：\(record.reporter)") }
                if !record.owner.isEmpty { extra.append("责任人：\(record.owner)") }
                if !record.faultType.isEmpty { extra.append("类型：\(record.faultType)") }
                if let start = record.startTime {
                    extra.append("停机开始：\(timeFormatter.string(from: start))")
                }
                if let end = record.endTime {
                    extra.append("恢复：\(timeFormatter.string(from: end))")
                }
                if let minutes = record.downtimeMinutes {
                    extra.append(String(format: "停机时长：%.0f 分钟", minutes))
                }
                if !record.rootCause.isEmpty { extra.append("根因：\(record.rootCause)") }
                if !record.action.isEmpty { extra.append("措施：\(record.action)") }
                if !record.parts.isEmpty { extra.append("备件：\(record.parts)") }
                if let cost = record.cost { extra.append(String(format: "费用：%.2f 元", cost)) }
                for field in settings.customFields {
                    if let value = record.customValues[field.id.uuidString], !value.isEmpty {
                        extra.append("\(field.name)：\(value)")
                    }
                }

                if !extra.isEmpty {
                    cursorY += 3
                    cursorY += drawText(extra.joined(separator: "　"), font: .systemFont(ofSize: 9),
                                        color: UIColor(white: 0.35, alpha: 1), x: margin, width: contentWidth)
                }

                // 照片（每行最多 3 张）
                let thumbs = record.photos.compactMap { store.photo(named: $0) }
                if !thumbs.isEmpty {
                    let columns = 3
                    let gap: CGFloat = 8
                    let side = (contentWidth - gap * CGFloat(columns - 1)) / CGFloat(columns)
                    var row = 0
                    for (photoIndex, image) in thumbs.prefix(6).enumerated() {
                        let column = photoIndex % columns
                        if column == 0 {
                            ensureSpace(side + 8)
                            row = photoIndex / columns
                        }
                        let originY = cursorY + CGFloat(row) * (side * 0.75 + gap)
                        let rect = CGRect(x: margin + CGFloat(column) * (side + gap),
                                          y: originY, width: side, height: side * 0.75)
                        image.draw(in: rect)
                    }
                    let rowsCount = CGFloat((min(thumbs.count, 6) + columns - 1) / columns)
                    cursorY += rowsCount * (side * 0.75 + gap)
                }

                cursorY += 6
                UIColor(white: 0.85, alpha: 1).setFill()
                context.fill(CGRect(x: margin, y: cursorY, width: contentWidth, height: 0.6))
                cursorY += 12
            }

            let footer = NSAttributedString(string: "第 \(pageNumber) 页 · 设备故障台账", attributes: [
                .font: UIFont.systemFont(ofSize: 8),
                .foregroundColor: UIColor(white: 0.5, alpha: 1)
            ])
            footer.draw(at: CGPoint(x: margin, y: pageSize.height - 28))
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmm"
        let url = FaultStore.documentsDirectory
            .appendingPathComponent("设备故障报告_\(formatter.string(from: Date())).pdf")
        do {
            try data.write(to: url, options: .atomic)
            return url
        } catch {
            print("PDF 导出失败：\(error)")
            return nil
        }
    }
}
