import Foundation

// MARK: - 选项目录

enum FaultCatalog {
    static let faultTypes = ["机械故障", "电气故障", "漏油", "异响", "气路异常", "其他"]
    static let urgencies = ["一般", "紧急", "停机"]
    static let quickPhrases = [
        "设备无法启动",
        "运行中异响",
        "气缸不动作",
        "油管接头漏油",
        "接近开关无信号",
        "皮带打滑跑偏",
        "温度过高报警",
        "传感器数值漂移"
    ]
}

/// 处理状态
enum FaultStatus: String, Codable, CaseIterable, Identifiable {
    case pending = "待处理"
    case doing = "处理中"
    case fixed = "已修复"

    var id: String { rawValue }
}

/// 时间轴事件
struct TimelineEvent: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    var date: Date = Date()
    var text: String = ""
}

/// 自定义字段类型
enum CustomFieldKind: String, Codable, CaseIterable, Identifiable {
    case text = "文本"
    case number = "数字"
    case date = "日期"
    case select = "选项"

    var id: String { rawValue }
}

/// 自定义字段定义
struct CustomFieldDef: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    var name: String = ""
    var kind: CustomFieldKind = .text
    var options: [String] = []
}

/// 一条设备故障记录
struct FaultRecord: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var createdAt: Date = Date()

    /// 项目 / 客户
    var project: String = ""
    /// 设备名称
    var deviceName: String = ""
    /// 设备编号（扫码或手填）
    var deviceCode: String = ""
    /// 位置 / 产线 / 工位
    var location: String = ""
    /// GPS 坐标
    var latitude: Double? = nil
    var longitude: Double? = nil

    var faultType: String = FaultCatalog.faultTypes[0]
    var urgency: String = FaultCatalog.urgencies[0]
    var detail: String = ""

    var status: FaultStatus = .pending

    /// 照片文件名（可多张）
    var photos: [String] = []
    /// 视频文件名
    var video: String? = nil

    /// 报修人 / 责任人
    var reporter: String = ""
    var owner: String = ""

    /// 停机起止时间
    var startTime: Date? = nil
    var endTime: Date? = nil

    /// 处理措施 / 根因 / 更换备件 / 费用
    var rootCause: String = ""
    var action: String = ""
    var parts: String = ""
    var cost: Double? = nil

    /// 跟进提醒时间
    var reminderAt: Date? = nil

    /// 自定义字段值，key 为字段 id 的字符串
    var customValues: [String: String] = [:]

    /// 状态变更时间轴
    var timeline: [TimelineEvent] = []

    /// 停机时长（分钟）
    var downtimeMinutes: Double? {
        guard let start = startTime else { return nil }
        let end = endTime ?? Date()
        let minutes = end.timeIntervalSince(start) / 60
        return minutes > 0 ? minutes : nil
    }
}

/// 设备主档
struct DeviceItem: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    var name: String = ""
    var code: String = ""
    var location: String = ""
}

/// 项目 / 客户
struct ProjectItem: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    var name: String = ""
}
