import SwiftUI
import UIKit

/// 全局配色与通用组件（跟随系统深色 / 浅色自动切换）
enum Theme {

    /// 动态颜色：传入浅色与深色两套值，系统切换时自动生效
    static func dynamic(light: UIColor, dark: UIColor) -> Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? dark : light
        })
    }

    // 品牌色（两种模式下都保留）
    static let navy = Color(red: 0.10, green: 0.16, blue: 0.24)
    static let navyLight = Color(red: 0.16, green: 0.24, blue: 0.35)
    static let orange = Color(red: 0.95, green: 0.57, blue: 0.15)

    // 页面与卡片
    static let pageBackground = dynamic(light: UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1),
                                        dark: UIColor(red: 0.055, green: 0.063, blue: 0.078, alpha: 1))
    static let cardBackground = dynamic(light: .white,
                                        dark: UIColor(red: 0.11, green: 0.12, blue: 0.15, alpha: 1))
    static let fieldBackground = dynamic(light: UIColor(white: 0.96, alpha: 1),
                                         dark: UIColor(white: 0.18, alpha: 1))
    static let chipBackground = dynamic(light: UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1),
                                        dark: UIColor(white: 0.21, alpha: 1))
    static let trackBackground = dynamic(light: UIColor(white: 0.92, alpha: 1),
                                         dark: UIColor(white: 0.24, alpha: 1))
    static let separator = dynamic(light: UIColor(white: 0.90, alpha: 1),
                                   dark: UIColor(white: 0.26, alpha: 1))
    static let shadow = dynamic(light: UIColor.black.withAlphaComponent(0.05),
                                dark: UIColor.black.withAlphaComponent(0.45))
    static let placeholderIcon = dynamic(light: UIColor(white: 0.62, alpha: 1),
                                         dark: UIColor(white: 0.52, alpha: 1))

    /// 强调色（用于文字 / 图标）：浅色下是藏青，深色下提亮为淡蓝
    static let accent = dynamic(light: UIColor(red: 0.10, green: 0.16, blue: 0.24, alpha: 1),
                                dark: UIColor(red: 0.56, green: 0.73, blue: 0.96, alpha: 1))
    /// 强调底色上的文字
    static let onAccent = dynamic(light: .white,
                                  dark: UIColor(red: 0.06, green: 0.08, blue: 0.11, alpha: 1))
    /// 主按钮底色：浅色藏青，深色转暖橙，避免黑底黑按钮
    static let ctaBackground = dynamic(light: UIColor(red: 0.10, green: 0.16, blue: 0.24, alpha: 1),
                                       dark: UIColor(red: 0.95, green: 0.57, blue: 0.15, alpha: 1))
    static let teal = dynamic(light: UIColor(red: 0.22, green: 0.49, blue: 0.45, alpha: 1),
                              dark: UIColor(red: 0.44, green: 0.80, blue: 0.74, alpha: 1))

    static func statusColor(_ status: FaultStatus) -> Color {
        switch status {
        case .pending: return dynamic(light: UIColor(red: 0.85, green: 0.45, blue: 0.05, alpha: 1),
                                      dark: UIColor(red: 1.0, green: 0.68, blue: 0.26, alpha: 1))
        case .doing: return dynamic(light: UIColor(red: 0.13, green: 0.42, blue: 0.83, alpha: 1),
                                    dark: UIColor(red: 0.42, green: 0.66, blue: 1.0, alpha: 1))
        case .fixed: return dynamic(light: UIColor(red: 0.09, green: 0.55, blue: 0.28, alpha: 1),
                                    dark: UIColor(red: 0.33, green: 0.80, blue: 0.52, alpha: 1))
        }
    }

    static func statusBackground(_ status: FaultStatus) -> Color {
        switch status {
        case .pending: return dynamic(light: UIColor(red: 1.0, green: 0.96, blue: 0.90, alpha: 1),
                                      dark: UIColor(red: 0.28, green: 0.22, blue: 0.12, alpha: 1))
        case .doing: return dynamic(light: UIColor(red: 0.91, green: 0.95, blue: 1.0, alpha: 1),
                                    dark: UIColor(red: 0.12, green: 0.19, blue: 0.32, alpha: 1))
        case .fixed: return dynamic(light: UIColor(red: 0.92, green: 0.97, blue: 0.94, alpha: 1),
                                    dark: UIColor(red: 0.11, green: 0.25, blue: 0.17, alpha: 1))
        }
    }

    static func urgencyColor(_ urgency: String) -> Color {
        switch urgency {
        case "停机": return dynamic(light: UIColor(red: 0.75, green: 0.11, blue: 0.12, alpha: 1),
                                    dark: UIColor(red: 1.0, green: 0.42, blue: 0.42, alpha: 1))
        case "紧急": return dynamic(light: UIColor(red: 0.90, green: 0.32, blue: 0.05, alpha: 1),
                                    dark: UIColor(red: 1.0, green: 0.55, blue: 0.22, alpha: 1))
        default: return Color(UIColor.secondaryLabel)
        }
    }
}

/// 圆角卡片容器
struct CardBox<Content: View>: View {
    var padding: CGFloat = 14
    let content: Content

    init(padding: CGFloat = 14, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background(Theme.cardBackground)
            .cornerRadius(16)
            .shadow(color: Theme.shadow, radius: 6, x: 0, y: 2)
    }
}

/// 小标签
struct Chip: View {
    let text: String
    var color: Color = Color(UIColor.secondaryLabel)
    var background: Color = Theme.chipBackground

    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(background)
            .cornerRadius(6)
    }
}

/// 统计条
struct StatBar: View {
    let title: String
    let value: Int
    let maxValue: Int
    var color: Color = Theme.navy

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(title)
                    .font(.system(size: 13))
                    .foregroundColor(.primary)
                Spacer()
                Text("\(value)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(color)
            }
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Theme.trackBackground)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: maxValue > 0
                               ? max(geometry.size.width * CGFloat(value) / CGFloat(maxValue), value > 0 ? 6 : 0)
                               : 0)
                }
            }
            .frame(height: 7)
        }
    }
}

/// 顶部大标题
struct PageHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.primary)
            Text(subtitle)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
