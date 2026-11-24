import Foundation
import Combine

/// 全局设置（项目、设备主档、常用短语、自定义字段、人员、水印、同步、AI、安全）
final class AppSettings: ObservableObject {

    /// 全局单例（视图与仓库共用一份）
    static let shared = AppSettings()

    @Published var projects: [ProjectItem] = []
    @Published var devices: [DeviceItem] = []
    @Published var phrases: [String] = FaultCatalog.quickPhrases
    @Published var customFields: [CustomFieldDef] = []
    @Published var people: [String] = []

    // 水印
    @Published var watermarkEnabled: Bool = true
    @Published var watermarkShowLocation: Bool = true

    // 安全
    @Published var lockEnabled: Bool = false
    @Published var lockOnBackground: Bool = true

    // 提醒
    @Published var reminderHours: Int = 24
    @Published var reminderEnabled: Bool = true

    // 同步（飞书 / 企业微信 / 钉钉 / 通用 webhook）
    @Published var webhookEnabled: Bool = false
    @Published var webhookKind: String = "飞书多维表格/机器人"
    @Published var webhookURL: String = ""

    // AI（OpenAI 兼容接口，可选）
    @Published var aiEnabled: Bool = false
    @Published var aiBaseURL: String = "https://ark.cn-beijing.volces.com/api/v3"
    @Published var aiModel: String = "doubao-vision"
    @Published var aiKey: String = ""

    static let webhookKinds = ["飞书多维表格/机器人", "企业微信群机器人", "钉钉群机器人", "通用 JSON"]

    private var fileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("fault_settings.json")
    }

    struct Snapshot: Codable {
        var projects: [ProjectItem]
        var devices: [DeviceItem]
        var phrases: [String]
        var customFields: [CustomFieldDef]
        var people: [String]
        var watermarkEnabled: Bool
        var watermarkShowLocation: Bool
        var lockEnabled: Bool
        var lockOnBackground: Bool
        var reminderHours: Int
        var reminderEnabled: Bool
        var webhookEnabled: Bool
        var webhookKind: String
        var webhookURL: String
        var aiEnabled: Bool
        var aiBaseURL: String
        var aiModel: String
        var aiKey: String
    }

    init() {
        load()
        if devices.isEmpty {
            devices = []
        }
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let s = try? JSONDecoder().decode(Snapshot.self, from: data) else { return }
        projects = s.projects
        devices = s.devices
        phrases = s.phrases
        customFields = s.customFields
        people = s.people
        watermarkEnabled = s.watermarkEnabled
        watermarkShowLocation = s.watermarkShowLocation
        lockEnabled = s.lockEnabled
        lockOnBackground = s.lockOnBackground
        reminderHours = s.reminderHours
        reminderEnabled = s.reminderEnabled
        webhookEnabled = s.webhookEnabled
        webhookKind = s.webhookKind
        webhookURL = s.webhookURL
        aiEnabled = s.aiEnabled
        aiBaseURL = s.aiBaseURL
        aiModel = s.aiModel
        aiKey = s.aiKey
    }

    func save() {
        let s = Snapshot(
            projects: projects,
            devices: devices,
            phrases: phrases,
            customFields: customFields,
            people: people,
            watermarkEnabled: watermarkEnabled,
            watermarkShowLocation: watermarkShowLocation,
            lockEnabled: lockEnabled,
            lockOnBackground: lockOnBackground,
            reminderHours: reminderHours,
            reminderEnabled: reminderEnabled,
            webhookEnabled: webhookEnabled,
            webhookKind: webhookKind,
            webhookURL: webhookURL,
            aiEnabled: aiEnabled,
            aiBaseURL: aiBaseURL,
            aiModel: aiModel,
            aiKey: aiKey
        )
        do {
            let data = try JSONEncoder().encode(s)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("设置保存失败：\(error)")
        }
    }
}
