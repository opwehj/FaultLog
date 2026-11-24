import UIKit

/// 照片水印：底部半透明条，压时间 / 设备 / 项目 / 位置
enum Watermark {

    static func draw(on image: UIImage, record: FaultRecord?, showLocation: Bool) -> UIImage {
        let size = image.size
        guard size.width > 0, size.height > 0 else { return image }

        let rowHeight = max(size.height * 0.028, 16)
        let barHeight = rowHeight * 3 + rowHeight * 0.6
        let padding = rowHeight * 0.6

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        var lines: [String] = []
        let deviceText = [record?.deviceName, record?.deviceCode]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: " / ")
        lines.append("\(formatter.string(from: Date()))" + (deviceText.isEmpty ? "" : "  ·  \(deviceText)"))
        let project = record?.project ?? ""
        lines.append(project.isEmpty ? "设备故障台账" : project)
        if showLocation {
            let location = record?.location ?? ""
            if location.isEmpty {
                if let lat = record?.latitude, let lon = record?.longitude {
                    lines.append(String(format: "定位 %.5f, %.5f", lat, lon))
                } else {
                    lines.append("现场拍摄")
                }
            } else {
                lines.append(location)
            }
        }

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        return UIGraphicsImageRenderer(size: size, format: format).image { context in
            image.draw(in: CGRect(origin: .zero, size: size))

            let barRect = CGRect(x: 0, y: size.height - barHeight - padding * 0.6,
                                 width: size.width, height: barHeight)
            UIColor(red: 0.06, green: 0.11, blue: 0.17, alpha: 0.68).setFill()
            context.fill(barRect)

            let font = UIFont.systemFont(ofSize: rowHeight * 0.86, weight: .medium)
            let attrs: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.white
            ]
            var y = barRect.minY + rowHeight * 0.35
            for (index, line) in lines.enumerated() {
                let alpha: CGFloat = index == 0 ? 1 : 0.85
                let attributed = NSAttributedString(string: line, attributes: [
                    .font: font,
                    .foregroundColor: UIColor.white.withAlphaComponent(alpha)
                ])
                attributed.draw(at: CGPoint(x: padding, y: y))
                y += rowHeight
            }
        }
    }
}

/// 单条故障卡片图（发群/微信）
enum CardRenderer {

    static func render(record: FaultRecord, store: FaultStore, width: CGFloat = 1080,
                       settings: AppSettings = .shared) -> UIImage {
        let margin: CGFloat = 56
        let contentWidth = width - margin * 2
        let titleFont = UIFont.systemFont(ofSize: 46, weight: .bold)
        let labelFont = UIFont.systemFont(ofSize: 30, weight: .semibold)
        let valueFont = UIFont.systemFont(ofSize: 30, weight: .regular)
        let lineGap: CGFloat = 16

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        var rows: [(String, String)] = []
        rows.append(("设备", [record.deviceName, record.deviceCode].filter { !$0.isEmpty }.joined(separator: " / ")))
        if !record.project.isEmpty { rows.append(("项目", record.project)) }
        if !record.location.isEmpty { rows.append(("位置", record.location)) }
        rows.append(("故障类型", record.faultType))
        rows.append(("紧急程度", record.urgency))
        rows.append(("处理状态", record.status.rawValue))
        rows.append(("报修时间", formatter.string(from: record.createdAt)))
        if !record.reporter.isEmpty { rows.append(("报修人", record.reporter)) }
        if !record.owner.isEmpty { rows.append(("责任人", record.owner)) }
        if let minutes = record.downtimeMinutes {
            rows.append(("停机时长", String(format: "%.0f 分钟", minutes)))
        }
        if !record.rootCause.isEmpty { rows.append(("根因", record.rootCause)) }
        if !record.action.isEmpty { rows.append(("处理措施", record.action)) }
        for field in settings.customFields {
            if let value = record.customValues[field.id.uuidString], !value.isEmpty {
                rows.append((field.name, value))
            }
        }

        // 计算高度
        let photoHeight: CGFloat = record.photos.isEmpty ? 0 : contentWidth * 0.62
        func textHeight(_ text: String, font: UIFont, maxWidth: CGFloat) -> CGFloat {
            let rect = (text as NSString).boundingRect(
                with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [.font: font],
                context: nil
            )
            return ceil(rect.height)
        }

        var bodyHeight: CGFloat = 0
        for (label, value) in rows {
            bodyHeight += max(textHeight(value, font: valueFont, maxWidth: contentWidth - 170),
                              textHeight(label, font: labelFont, maxWidth: 150)) + lineGap
        }
        let detailHeight = textHeight(record.detail, font: valueFont, maxWidth: contentWidth)
        let totalHeight = margin + 90 + bodyHeight + detailHeight + 90 + photoHeight + margin + 70

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        return UIGraphicsImageRenderer(size: CGSize(width: width, height: totalHeight), format: format).image { context in
            UIColor(white: 0.97, alpha: 1).setFill()
            context.fill(CGRect(x: 0, y: 0, width: width, height: totalHeight))

            let headerRect = CGRect(x: 0, y: 0, width: width, height: 150)
            UIColor(red: 0.10, green: 0.16, blue: 0.24, alpha: 1).setFill()
            context.fill(headerRect)
            let title = NSAttributedString(string: "设备故障记录", attributes: [
                .font: UIFont.systemFont(ofSize: 42, weight: .bold),
                .foregroundColor: UIColor.white
            ])
            title.draw(at: CGPoint(x: margin, y: 52))
            let badge = NSAttributedString(string: record.urgency, attributes: [
                .font: UIFont.systemFont(ofSize: 28, weight: .semibold),
                .foregroundColor: UIColor(red: 0.96, green: 0.62, blue: 0.04, alpha: 1)
            ])
            let badgeSize = badge.size()
            badge.draw(at: CGPoint(x: width - margin - badgeSize.width, y: 60))

            var y: CGFloat = 150 + margin * 0.8
            for (label, value) in rows {
                let labelText = NSAttributedString(string: label, attributes: [
                    .font: labelFont,
                    .foregroundColor: UIColor(white: 0.42, alpha: 1)
                ])
                let valueText = NSAttributedString(string: value.isEmpty ? "—" : value, attributes: [
                    .font: valueFont,
                    .foregroundColor: UIColor(white: 0.13, alpha: 1)
                ])
                let valueHeight = textHeight(value.isEmpty ? "—" : value, font: valueFont, maxWidth: contentWidth - 170)
                labelText.draw(at: CGPoint(x: margin, y: y))
                valueText.draw(in: CGRect(x: margin + 170, y: y, width: contentWidth - 170, height: valueHeight))
                y += max(valueHeight, textHeight(label, font: labelFont, maxWidth: 150)) + lineGap
            }

            y += 30
            let detailTitle = NSAttributedString(string: "问题描述", attributes: [
                .font: labelFont,
                .foregroundColor: UIColor(white: 0.42, alpha: 1)
            ])
            detailTitle.draw(at: CGPoint(x: margin, y: y))
            y += 50
            let detail = NSAttributedString(string: record.detail, attributes: [
                .font: valueFont,
                .foregroundColor: UIColor(white: 0.13, alpha: 1)
            ])
            detail.draw(in: CGRect(x: margin, y: y, width: contentWidth, height: detailHeight))
            y += detailHeight + 40

            if let first = record.photos.first, let image = store.photo(named: first) {
                let rect = CGRect(x: margin, y: y, width: contentWidth, height: photoHeight)
                image.draw(in: rect)
                if record.photos.count > 1 {
                    let more = NSAttributedString(string: "共 \(record.photos.count) 张照片", attributes: [
                        .font: UIFont.systemFont(ofSize: 26, weight: .medium),
                        .foregroundColor: UIColor.white
                    ])
                    UIColor(white: 0, alpha: 0.45).setFill()
                    context.fill(CGRect(x: rect.maxX - 260, y: rect.maxY - 64, width: 240, height: 48))
                    more.draw(at: CGPoint(x: rect.maxX - 244, y: rect.maxY - 56))
                }
                y += photoHeight
            }

            let footer = NSAttributedString(string: "由「设备故障台账」生成 · \(formatter.string(from: Date()))", attributes: [
                .font: UIFont.systemFont(ofSize: 26, weight: .regular),
                .foregroundColor: UIColor(white: 0.55, alpha: 1)
            ])
            footer.draw(at: CGPoint(x: margin, y: totalHeight - 70))
        }
    }
}
