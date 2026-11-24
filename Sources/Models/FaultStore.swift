import Foundation
import Combine
import UIKit

/// 数据仓库：记录持久化、照片/视频存取、备份恢复、提醒与同步调度
final class FaultStore: ObservableObject {

    @Published private(set) var records: [FaultRecord] = []
    /// 最近一次同步结果的提示
    @Published var syncMessage: String? = nil

    static let documentsDirectory: URL = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }()

    private var dataURL: URL { FaultStore.documentsDirectory.appendingPathComponent("fault_records.json") }

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

    func add(_ record: FaultRecord) {
        var new = record
        if new.timeline.isEmpty {
            new.timeline = [TimelineEvent(date: Date(), text: "创建记录（\(new.status.rawValue)）")]
        }
        records.insert(new, at: 0)
        persist()
        notifyIfNeeded(new)
        syncIfNeeded(new)
    }

    func update(_ record: FaultRecord) {
        guard let index = records.firstIndex(where: { $0.id == record.id }) else { return }
        var updated = record
        let oldStatus = records[index].status
        if oldStatus != updated.status {
            updated.timeline.append(TimelineEvent(date: Date(), text: "状态改为 \(updated.status.rawValue)"))
        }
        records[index] = updated
        records.sort { $0.createdAt > $1.createdAt }
        persist()
        notifyIfNeeded(updated)
    }

    func changeStatus(_ record: FaultRecord, to status: FaultStatus) {
        var updated = record
        updated.status = status
        if status == .fixed && updated.endTime == nil {
            updated.endTime = Date()
        }
        if status != .fixed && updated.endTime != nil {
            updated.endTime = nil
        }
        update(updated)
    }

    func delete(_ record: FaultRecord) {
        for name in record.photos { deleteFile(named: name) }
        if let video = record.video { deleteFile(named: video) }
        NotificationService.shared.cancel(for: record.id)
        records.removeAll { $0.id == record.id }
        persist()
    }

    func record(id: UUID) -> FaultRecord? {
        records.first { $0.id == id }
    }

    // MARK: - 照片 / 视频

    /// 保存照片（按设置叠加水印），返回文件名
    func savePhoto(_ image: UIImage, record: FaultRecord?, showLocation: Bool) -> String? {
        var output = image.resized(maxSide: 1600)
        if AppSettings.shared.watermarkEnabled {
            output = Watermark.draw(on: output, record: record, showLocation: showLocation)
        }
        guard let data = output.jpegData(compressionQuality: 0.72) else { return nil }
        let name = "fault_\(UUID().uuidString.prefix(8)).jpg"
        do {
            try data.write(to: FaultStore.documentsDirectory.appendingPathComponent(name), options: .atomic)
            return name
        } catch {
            print("照片保存失败：\(error)")
            return nil
        }
    }

    func saveVideo(from url: URL) -> String? {
        let name = "fault_\(UUID().uuidString.prefix(8)).mov"
        let target = FaultStore.documentsDirectory.appendingPathComponent(name)
        do {
            if FileManager.default.fileExists(atPath: target.path) {
                try FileManager.default.removeItem(at: target)
            }
            try FileManager.default.copyItem(at: url, to: target)
            return name
        } catch {
            print("视频保存失败：\(error)")
            return nil
        }
    }

    func photoData(named name: String) -> Data? {
        try? Data(contentsOf: FaultStore.documentsDirectory.appendingPathComponent(name))
    }

    func photo(named name: String) -> UIImage? {
        guard let data = photoData(named: name) else { return nil }
        return UIImage(data: data)
    }

    func mediaURL(named name: String) -> URL {
        FaultStore.documentsDirectory.appendingPathComponent(name)
    }

    func deleteFile(named name: String) {
        try? FileManager.default.removeItem(at: FaultStore.documentsDirectory.appendingPathComponent(name))
    }

    // MARK: - 提醒

    private func notifyIfNeeded(_ record: FaultRecord) {
        guard AppSettings.shared.reminderEnabled, record.status != .fixed else {
            NotificationService.shared.cancel(for: record.id)
            return
        }
        let hours = AppSettings.shared.reminderHours
        let fire = record.reminderAt ?? Date().addingTimeInterval(TimeInterval(hours * 3600))
        NotificationService.shared.schedule(
            for: record.id,
            title: "还有故障没处理完",
            body: "\(record.deviceName.isEmpty ? "某设备" : record.deviceName) · \(record.detail.prefix(40))",
            at: fire
        )
    }

    // MARK: - 同步

    private func syncIfNeeded(_ record: FaultRecord) {
        let settings = AppSettings.shared
        guard settings.webhookEnabled, !settings.webhookURL.isEmpty else { return }
        WebhookService.push(record: record, settings: settings) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.syncMessage = "已同步到 \(settings.webhookKind)"
                case .failure(let error):
                    self?.syncMessage = "同步失败：\(error.localizedDescription)"
                }
            }
        }
    }

    // MARK: - 备份 / 恢复（含照片，单个 json 文件）

    struct BackupPayload: Codable {
        var version: Int = 1
        var exportedAt: Date = Date()
        var records: [FaultRecord]
        var files: [String: String]  // 文件名 -> base64
    }

    func exportBackup() -> URL? {
        var files: [String: String] = [:]
        for record in records {
            for name in record.photos {
                if let data = photoData(named: name) {
                    files[name] = data.base64EncodedString()
                }
            }
            if let video = record.video,
               let data = try? Data(contentsOf: mediaURL(named: video)) {
                files[video] = data.base64EncodedString()
            }
        }
        let payload = BackupPayload(records: records, files: files)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmm"
        let url = FaultStore.documentsDirectory
            .appendingPathComponent("设备故障台账备份_\(formatter.string(from: Date())).json")
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(payload)
            try data.write(to: url, options: .atomic)
            return url
        } catch {
            print("备份失败：\(error)")
            return nil
        }
    }

    enum ImportError: LocalizedError {
        case badFile
        var errorDescription: String? { "备份文件无法解析" }
    }

    func importBackup(from url: URL) throws -> Int {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let payload = try decoder.decode(BackupPayload.self, from: data)
        for (name, base64) in payload.files {
            guard let imageData = Data(base64Encoded: base64) else { continue }
            let target = FaultStore.documentsDirectory.appendingPathComponent(name)
            if !FileManager.default.fileExists(atPath: target.path) {
                try? imageData.write(to: target, options: .atomic)
            }
        }
        var added = 0
        for record in payload.records where !records.contains(where: { $0.id == record.id }) {
            records.append(record)
            added += 1
        }
        records.sort { $0.createdAt > $1.createdAt }
        persist()
        return added
    }
}
