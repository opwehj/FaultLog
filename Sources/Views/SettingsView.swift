import SwiftUI
import UniformTypeIdentifiers
import UIKit
import LocalAuthentication

/// 设置：数据、同步、AI、设备主档、项目、人员、短语、自定义字段、水印、提醒、安全
struct SettingsView: View {

    @EnvironmentObject private var settings: AppSettings
    @EnvironmentObject private var store: FaultStore

    @State private var sheet: Sheet?
    @State private var importPresented = false
    @State private var message: String?
    @State private var shareURL: URL?

    enum Sheet: Identifiable {
        case device(DeviceItem?)
        case field(CustomFieldDef?)
        case project
        case person
        case phrase
        case share(URL)

        var id: String {
            switch self {
            case .device(let item): return "device-\(item?.id.uuidString ?? "new")"
            case .field(let item): return "field-\(item?.id.uuidString ?? "new")"
            case .project: return "project"
            case .person: return "person"
            case .phrase: return "phrase"
            case .share: return "share"
            }
        }
    }

    var body: some View {
        NavigationView {
            Form {
                exportSection
                syncSection
                aiSection
                deviceSection
                projectSection
                peopleSection
                phraseSection
                fieldSection
                watermarkSection
                reminderSection
                securitySection
                aboutSection
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $sheet) { item in
                switch item {
                case .device(let device):
                    DeviceEditView(device: device)
                        .environmentObject(settings)
                case .field(let field):
                    FieldEditView(field: field)
                        .environmentObject(settings)
                case .project:
                    NameInputView(title: "新增项目 / 客户", placeholder: "例如：时代新能源") { name in
                        settings.projects.append(ProjectItem(name: name))
                        settings.save()
                    }
                case .person:
                    NameInputView(title: "新增人员", placeholder: "姓名") { name in
                        settings.people.append(name)
                        settings.save()
                    }
                case .phrase:
                    NameInputView(title: "新增常用短语", placeholder: "例如：气缸不动作") { name in
                        settings.phrases.append(name)
                        settings.save()
                    }
                case .share(let url):
                    ShareSheet(items: [url])
                }
            }
            .fileImporter(isPresented: $importPresented,
                          allowedContentTypes: [.json],
                          allowsMultipleSelection: false) { result in
                switch result {
                case .success(let urls):
                    guard let url = urls.first else { return }
                    let scoped = url.startAccessingSecurityScopedResource()
                    defer { if scoped { url.stopAccessingSecurityScopedResource() } }
                    do {
                        let count = try store.importBackup(from: url)
                        message = "已导入 \(count) 条记录"
                    } catch {
                        message = "导入失败：\(error.localizedDescription)"
                    }
                case .failure(let error):
                    message = "选择文件失败：\(error.localizedDescription)"
                }
            }
            .alert(isPresented: Binding(get: { message != nil }, set: { if !$0 { message = nil } })) {
                Alert(title: Text("提示"), message: Text(message ?? ""), dismissButton: .default(Text("好")))
            }
        }
        .navigationViewStyle(.stack)
    }

    // MARK: - 数据

    private var exportSection: some View {
        Section {
            Button {
                present(ExportService.exportXLSX(records: store.records, settings: settings))
            } label: {
                Label("导出 Excel（xlsx）", systemImage: "tablecells")
            }
            Button {
                present(ExportService.exportCSV(records: store.records, settings: settings))
            } label: {
                Label("导出 CSV", systemImage: "doc.plaintext")
            }
            Button {
                present(ExportService.exportHTML(records: store.records, store: store, settings: settings))
            } label: {
                Label("导出图文报告（HTML）", systemImage: "doc.richtext")
            }
            Button {
                present(PDFReport.build(records: store.records, store: store,
                                        title: "设备故障报告", settings: settings))
            } label: {
                Label("导出 PDF 报告", systemImage: "doc.badge.gearshape")
            }
            Button {
                present(store.exportBackup())
            } label: {
                Label("导出整库备份（含照片）", systemImage: "externaldrive.badge.plus")
            }
            Button {
                importPresented = true
            } label: {
                Label("从备份文件恢复", systemImage: "square.and.arrow.down")
            }
            Text("当前共 \(store.records.count) 条记录")
                .font(.caption)
                .foregroundColor(.secondary)
        } header: {
            Text("数据与导出")
        }
    }

    // MARK: - 同步

    private var syncSection: some View {
        Section {
            Toggle("新故障自动推送", isOn: Binding(
                get: { settings.webhookEnabled },
                set: { settings.webhookEnabled = $0; settings.save() }
            ))
            if settings.webhookEnabled {
                Picker("推送方式", selection: Binding(
                    get: { settings.webhookKind },
                    set: { settings.webhookKind = $0; settings.save() }
                )) {
                    ForEach(AppSettings.webhookKinds, id: \.self) { kind in
                        Text(kind).tag(kind)
                    }
                }
                TextField("Webhook 地址", text: Binding(
                    get: { settings.webhookURL },
                    set: { settings.webhookURL = $0; settings.save() }
                ))
                .keyboardType(.URL)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                if let syncMessage = store.syncMessage {
                    Text(syncMessage)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        } header: {
            Text("同步到飞书 / 企业微信 / 钉钉")
        } footer: {
            Text("填群机器人或通用 Webhook 地址；飞书多维表格可用「多维表格自动化 → Webhook」触发写入表格。")
        }
    }

    // MARK: - AI

    private var aiSection: some View {
        Section {
            Toggle("启用 AI 辅助", isOn: Binding(
                get: { settings.aiEnabled },
                set: { settings.aiEnabled = $0; settings.save() }
            ))
            if settings.aiEnabled {
                TextField("接口地址", text: Binding(
                    get: { settings.aiBaseURL },
                    set: { settings.aiBaseURL = $0; settings.save() }
                ))
                .autocapitalization(.none)
                .disableAutocorrection(true)
                TextField("模型名", text: Binding(
                    get: { settings.aiModel },
                    set: { settings.aiModel = $0; settings.save() }
                ))
                .autocapitalization(.none)
                SecureField("API Key", text: Binding(
                    get: { settings.aiKey },
                    set: { settings.aiKey = $0; settings.save() }
                ))
            }
        } header: {
            Text("AI 辅助（可选）")
        } footer: {
            Text("填 OpenAI 兼容的 chat/completions 接口即可（如豆包方舟 / 通义 / 本地网关）。用于拍照预填描述与语音结构化，Key 只存在本机。")
        }
    }

    // MARK: - 设备主档

    private var deviceSection: some View {
        Section {
            ForEach(settings.devices) { device in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(device.name).font(.system(size: 14, weight: .medium))
                        Text([device.code, device.location].filter { !$0.isEmpty }.joined(separator: " · "))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Button {
                        let image = QRCodeMaker.label(device: device)
                        let url = FaultStore.documentsDirectory
                            .appendingPathComponent("设备标签_\(device.id.uuidString.prefix(6)).png")
                        if let data = image.pngData() {
                            try? data.write(to: url, options: .atomic)
                            sheet = .share(url)
                        }
                    } label: {
                        Image(systemName: "qrcode")
                            .foregroundColor(Theme.accent)
                    }
                    .buttonStyle(.borderless)
                }
                .contentShape(Rectangle())
                .onTapGesture { sheet = .device(device) }
            }
            .onDelete { indexSet in
                settings.devices.remove(atOffsets: indexSet)
                settings.save()
            }
            Button {
                sheet = .device(nil)
            } label: {
                Label("新增设备", systemImage: "plus.circle")
            }
        } header: {
            Text("设备主档（拍照时下拉选、扫码识别）")
        } footer: {
            Text("点设备右侧二维码图标可生成可打印的设备标签，贴在机器上扫码即填。")
        }
    }

    // MARK: - 项目 / 人员 / 短语

    private var projectSection: some View {
        Section {
            ForEach(settings.projects) { project in
                Text(project.name)
            }
            .onDelete { indexSet in
                settings.projects.remove(atOffsets: indexSet)
                settings.save()
            }
            Button {
                sheet = .project
            } label: {
                Label("新增项目 / 客户", systemImage: "plus.circle")
            }
        } header: {
            Text("项目 / 客户")
        }
    }

    private var peopleSection: some View {
        Section {
            ForEach(settings.people, id: \.self) { person in
                Text(person)
            }
            .onDelete { indexSet in
                settings.people.remove(atOffsets: indexSet)
                settings.save()
            }
            Button {
                sheet = .person
            } label: {
                Label("新增人员", systemImage: "plus.circle")
            }
        } header: {
            Text("报修人 / 责任人")
        }
    }

    private var phraseSection: some View {
        Section {
            ForEach(settings.phrases, id: \.self) { phrase in
                Text(phrase).font(.footnote)
            }
            .onDelete { indexSet in
                settings.phrases.remove(atOffsets: indexSet)
                settings.save()
            }
            Button {
                sheet = .phrase
            } label: {
                Label("新增常用短语", systemImage: "plus.circle")
            }
        } header: {
            Text("常用短语（填写时一键插入）")
        }
    }

    // MARK: - 自定义字段

    private var fieldSection: some View {
        Section {
            ForEach(settings.customFields) { field in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(field.name)
                        Text(field.kind.rawValue +
                             (field.options.isEmpty ? "" : " · \(field.options.joined(separator: "/"))"))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture { sheet = .field(field) }
            }
            .onDelete { indexSet in
                settings.customFields.remove(atOffsets: indexSet)
                settings.save()
            }
            Button {
                sheet = .field(nil)
            } label: {
                Label("新增自定义字段", systemImage: "plus.circle")
            }
        } header: {
            Text("自定义字段（会一起导出到表格）")
        }
    }

    // MARK: - 水印 / 提醒 / 安全

    private var watermarkSection: some View {
        Section {
            Toggle("照片自动加水印", isOn: Binding(
                get: { settings.watermarkEnabled },
                set: { settings.watermarkEnabled = $0; settings.save() }
            ))
            if settings.watermarkEnabled {
                Toggle("水印显示位置", isOn: Binding(
                    get: { settings.watermarkShowLocation },
                    set: { settings.watermarkShowLocation = $0; settings.save() }
                ))
            }
        } header: {
            Text("照片水印")
        } footer: {
            Text("水印内容：拍摄时间 · 设备 · 项目 · 位置，压在原图底部。")
        }
    }

    private var reminderSection: some View {
        Section {
            Toggle("未处理超时提醒", isOn: Binding(
                get: { settings.reminderEnabled },
                set: {
                    settings.reminderEnabled = $0
                    settings.save()
                    if $0 {
                        NotificationService.shared.requestAuthorization()
                    } else {
                        NotificationService.shared.cancelAll()
                    }
                }
            ))
            if settings.reminderEnabled {
                Stepper(value: Binding(
                    get: { settings.reminderHours },
                    set: { settings.reminderHours = $0; settings.save() }
                ), in: 2...168, step: 2) {
                    Text("默认提醒时间：\(settings.reminderHours) 小时后")
                }
            }
        } header: {
            Text("提醒")
        }
    }

    private var securitySection: some View {
        Section {
            Toggle("打开需要 Face ID / 密码", isOn: Binding(
                get: { settings.lockEnabled },
                set: { settings.lockEnabled = $0; settings.save() }
            ))
            if settings.lockEnabled {
                Toggle("切到后台后重新上锁", isOn: Binding(
                    get: { settings.lockOnBackground },
                    set: { settings.lockOnBackground = $0; settings.save() }
                ))
            }
        } header: {
            Text("隐私")
        } footer: {
            Text("客户信息比较敏感时建议打开；验证失败会停留在解锁页。")
        }
    }

    private var aboutSection: some View {
        Section {
            HStack {
                Text("版本")
                Spacer()
                Text("1.1").foregroundColor(.secondary)
            }
            Text("数据全部保存在本机 Documents 目录，不联网上传（除非你开了同步或 AI）。")
                .font(.caption2)
                .foregroundColor(.secondary)
        } header: {
            Text("关于")
        }
    }

    private func present(_ url: URL?) {
        guard let url = url else {
            message = "导出失败，请重试"
            return
        }
        shareURL = url
        sheet = .share(url)
    }
}

// MARK: - 设备编辑

struct DeviceEditView: View {

    @EnvironmentObject private var settings: AppSettings
    @Environment(\.dismiss) private var dismiss

    let device: DeviceItem?

    @State private var name = ""
    @State private var code = ""
    @State private var location = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("设备名称（如 3号包装机）", text: $name)
                    TextField("设备编号 / 型号", text: $code)
                    TextField("位置 / 产线 / 工位", text: $location)
                } header: {
                    Text("设备信息")
                }
            }
            .navigationTitle(device == nil ? "新增设备" : "编辑设备")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        var item = device ?? DeviceItem()
                        item.name = name
                        item.code = code
                        item.location = location
                        if let index = settings.devices.firstIndex(where: { $0.id == item.id }) {
                            settings.devices[index] = item
                        } else {
                            settings.devices.append(item)
                        }
                        settings.save()
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .onAppear {
                if let device = device {
                    name = device.name
                    code = device.code
                    location = device.location
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

// MARK: - 自定义字段编辑

struct FieldEditView: View {

    @EnvironmentObject private var settings: AppSettings
    @Environment(\.dismiss) private var dismiss

    let field: CustomFieldDef?

    @State private var name = ""
    @State private var kind: CustomFieldKind = .text
    @State private var optionsText = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("字段名称（如 客户签字）", text: $name)
                    Picker("类型", selection: $kind) {
                        ForEach(CustomFieldKind.allCases) { item in
                            Text(item.rawValue).tag(item)
                        }
                    }
                    if kind == .select {
                        TextField("选项，用逗号分隔（如 待验收,已验收）", text: $optionsText)
                    }
                } header: {
                    Text("字段设置")
                }
            }
            .navigationTitle(field == nil ? "新增字段" : "编辑字段")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        var item = field ?? CustomFieldDef()
                        item.name = name
                        item.kind = kind
                        item.options = optionsText
                            .split(separator: ",")
                            .map { $0.trimmingCharacters(in: .whitespaces) }
                            .filter { !$0.isEmpty }
                        if let index = settings.customFields.firstIndex(where: { $0.id == item.id }) {
                            settings.customFields[index] = item
                        } else {
                            settings.customFields.append(item)
                        }
                        settings.save()
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .onAppear {
                if let field = field {
                    name = field.name
                    kind = field.kind
                    optionsText = field.options.joined(separator: ",")
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

// MARK: - 单行文本输入

struct NameInputView: View {

    @Environment(\.dismiss) private var dismiss
    let title: String
    let placeholder: String
    let onSave: (String) -> Void

    @State private var text = ""

    var body: some View {
        NavigationView {
            Form {
                TextField(placeholder, text: $text)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        let value = text.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !value.isEmpty { onSave(value) }
                        dismiss()
                    }
                    .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
