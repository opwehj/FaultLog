import SwiftUI

/// 全局配色与通用组件
enum Theme {
    static let navy = Color(red: 0.10, green: 0.16, blue: 0.24)
    static let navyLight = Color(red: 0.16, green: 0.24, blue: 0.35)
    static let orange = Color(red: 0.95, green: 0.57, blue: 0.15)
    static let pageBackground = Color(red: 0.96, green: 0.97, blue: 0.98)
    static let cardBackground = Color.white

    static func statusColor(_ status: FaultStatus) -> Color {
        switch status {
        case .pending: return Color(red: 0.85, green: 0.45, blue: 0.05)
        case .doing: return Color(red: 0.13, green: 0.42, blue: 0.83)
        case .fixed: return Color(red: 0.09, green: 0.55, blue: 0.28)
        }
    }

    static func statusBackground(_ status: FaultStatus) -> Color {
        switch status {
        case .pending: return Color(red: 1.0, green: 0.96, blue: 0.90)
        case .doing: return Color(red: 0.91, green: 0.95, blue: 1.0)
        case .fixed: return Color(red: 0.92, green: 0.97, blue: 0.94)
        }
    }

    static func urgencyColor(_ urgency: String) -> Color {
        switch urgency {
        case "停机": return Color(red: 0.75, green: 0.11, blue: 0.12)
        case "紧急": return Color(red: 0.90, green: 0.32, blue: 0.05)
        default: return Color(red: 0.45, green: 0.45, blue: 0.45).opacity(1)
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
            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

/// 小标签
struct Chip: View {
    let text: String
    var color: Color = Color(red: 0.45, green: 0.45, blue: 0.45).opacity(1)
    var background: Color = Color(red: 0.95, green: 0.96, blue: 0.97)

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
                        .fill(Color(red: 0.93, green: 0.93, blue: 0.93).opacity(1))
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
                .foregroundColor(.white)
            Text(subtitle)
                .font(.system(size: 12))
                .foregroundColor(Color.white.opacity(0.75))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
