import Foundation

/// 可选项目录（故障类型 / 紧急程度），要改选项直接改这里
enum FaultCatalog {
    static let faultTypes = ["机械故障", "电气故障", "漏油", "异响", "气路异常", "其他"]
    static let urgencies = ["一般", "紧急", "停机"]
}

/// 处理状态
enum FaultStatus: String, Codable, CaseIterable, Identifiable {
    case pending = "待处理"
    case doing = "处理中"
    case fixed = "已修复"

    var id: String { rawValue }
}

/// 一条设备故障记录
struct FaultRecord: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    /// 创建时间
    var createdAt: Date = Date()
    /// 设备名称/编号
    var deviceName: String = ""
    /// 位置、产线、工位
    var location: String = ""
    /// 故障类型
    var faultType: String = FaultCatalog.faultTypes[0]
    /// 紧急程度
    var urgency: String = FaultCatalog.urgencies[0]
    /// 问题描述
    var detail: String = ""
    /// 处理状态
    var status: FaultStatus = .pending
    /// 照片文件名（存在 App 沙盒 Documents 目录）
    var photoFileName: String? = nil
}
