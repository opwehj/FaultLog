import SwiftUI
import UIKit

/// 新增 / 编辑一条故障记录（多图、语音、扫码、水印、AI、自定义字段、时间轴）
struct RecordEditorView: View {

    @EnvironmentObject private var store: FaultStore
    @EnvironmentObject private var settingsObject: AppSettings
    @Environment(\.dismiss) private var dismiss

    private var settings: AppSettings { settingsObject }

    let initialImages: [UIImage]
    let existing: FaultRecord?

    @State private var draft: FaultRecord
    @State private var newImages: [UIImage] = []
    @State private var activeSheet: ActiveSheet?
    @State private var aiBusy = false
    @State private var aiMessage: String?
    @State private var showPhrases = false
    @StateObject private var speech = SpeechInput()
    @StateObject private var location = LocationService()

    enum ActiveSheet: Identifiable {
        case album
        case scanner
        case share(URL)

        var id: String {
            switch self {
            case .album: return "album"
            case .scanner: return "scanner"
            case .share(let url): return "share-\(url.absoluteString)"
            }
        }
    }

    init(images: [UIImage] = [], existing: FaultRecord? = nil) {
        self.initialImages = images
        self.existing = existing
        var start = existing ?? FaultRecord()
        if let project = existing?.project, !project.isEmpty {
            start.project = project
        }
        _draft = State(initialValue: start)
        _newImages = State(initialValue: images)
    }

    private var canSave: Bool {
        !draft.deviceName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !draft.detail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationView {
            Form {
                photoSection
                basicSection
                detailSection
                timeSection
                handleSection
                if !settings.customFields.isEmpty { customSection }
                statusSection
                if existing != nil { timelineSection }
            }
            .navigationTitle(existing == nil ? "新增故障" : "编辑记录")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        speech.stop()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") { save() }
                        .disabled(!canSave)
                }
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .album:
                    PhotoLibraryPicker(limit: max(1, 6 - totalPhotoCount)) { images in
                        newImages.append(contentsOf: images)
                    }
                case .scanner:
                    ScannerView(onCode: handleCode)
                        .ignoresSafeArea()
                case .share(let url):
                    ShareSheet(items: [url])
                }
            }
            .alert(isPresented: Binding(
                get: { aiMessage != nil },
                set: { if !$0 { aiMessage = nil } }
            )) {
                Alert(title: Text("提示"), message: Text(aiMessage ?? ""), dismissButton: .default(Text("好")))
            }
        }
        .navigationViewStyle(.stack)
    }

    // MARK: - 照片

    private var totalPhotoCount: Int {
        draft.photos.count + newImages.count
    }

    @ViewBuilder
    private var photoSection: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(draft.photos.enumerated()), id: \.element) { index, name in
                        photoThumb(image: store.photo(named: name), onDelete: {
                            draft.photos.remove(at: index)
                            store.deleteFile(named: name)
                        })
                    }
                    ForEach(Array(newImages.enumerated()), id: \.offset) { index, image in
                        photoThumb(image: image, onDelete: {
                            newImages.remove(at: index)
                        })
                    }
                    addPhotoButton
                }
                .padding(.vertical, 4)
            }
            .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))

            HStack(spacing: 10) {
                actionButton(title: "拍照", icon: "camera.fill") {
                    CameraPresenter.present(mode: .photo) { handleCamera($0) }
                }
                actionButton(title: "相册", icon: "photo.on.rectangle") { activeSheet = .album }
                actionButton(title: "视频", icon: "video.fill") {
                    CameraPresenter.present(mode: .video, onImage: { _ in }, onVideo: handleVideo)
                }
            }
            .padding(.vertical, 2)

            if let video = draft.video {
                HStack {
                    Image(systemName: "film")
                        .foregroundColor(Theme.accent)
                    Text("已附一段视频")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Spacer()
                    Button(role: .destructive) {
                        store.deleteFile(named: video)
                        draft.video = nil
                    } label: {
                        Text("删除").font(.footnote)
                    }
                }
            }

            if let first = currentFirstImage {
                Button {
                    recognizePlate(first)
                } label: {
                    Label("识别铭牌 / 型号（离线 OCR）", systemImage: "text.viewfinder")
                        .font(.footnote)
                }
            }
        } header: {
            Text("故障照片（最多 6 张，自动加水印）")
        }
    }

    private var currentFirstImage: UIImage? {
        if let image = newImages.first { return image }
        if let name = draft.photos.first { return store.photo(named: name) }
        return nil
    }

    private func photoThumb(image: UIImage?, onDelete: @escaping () -> Void) -> some View {
        ZStack(alignment: .topTrailing) {
            Group {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Theme.separator
                }
            }
            .frame(width: 82, height: 82)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 17))
                    .foregroundColor(.white)
                    .shadow(radius: 2)
            }
            .padding(3)
        }
    }

    private var addPhotoButton: some View {
        Button {
            CameraPresenter.present(mode: .photo) { handleCamera($0) }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .semibold))
                Text("\(totalPhotoCount)/6")
                    .font(.caption2)
            }
            .frame(width: 82, height: 82)
            .foregroundColor(Theme.accent)
            .background(Theme.fieldBackground)
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
        .disabled(totalPhotoCount >= 6)
    }

    private func actionButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.system(size: 12, weight: .medium))
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(Theme.fieldBackground)
                .cornerRadius(9)
        }
        .buttonStyle(.plain)
    }

    // MARK: - 基本信息

    @ViewBuilder
    private var basicSection: some View {
        Section {
            HStack {
                TextField("设备名称 / 编号（必填）", text: $draft.deviceName)
                if !settings.devices.isEmpty {
                    Menu {
                        ForEach(settings.devices) { device in
                            Button {
                                draft.deviceName = device.name
                                draft.deviceCode = device.code
                                if device.location.isEmpty == false { draft.location = device.location }
                            } label: {
                                Text("\(device.name)\(device.code.isEmpty ? "" : " · \(device.code)")")
                            }
                        }
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
            }

            HStack {
                TextField("设备编号（扫码可自动填）", text: $draft.deviceCode)
                Button {
                    activeSheet = .scanner
                } label: {
                    Image(systemName: "qrcode.viewfinder")
                }
            }

            TextField("位置 / 产线 / 工位", text: $draft.location)

            HStack {
                Text("项目 / 客户")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                if settings.projects.isEmpty {
                    TextField("未设置", text: $draft.project)
                        .multilineTextAlignment(.trailing)
                } else {
                    Picker("", selection: $draft.project) {
                        Text("未指定").tag("")
                        ForEach(settings.projects) { project in
                            Text(project.name).tag(project.name)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                }
            }

            Picker("故障类型", selection: $draft.faultType) {
                ForEach(FaultCatalog.faultTypes, id: \.self) { type in
                    Text(type).tag(type)
                }
            }

            Picker("紧急程度", selection: $draft.urgency) {
                ForEach(FaultCatalog.urgencies, id: \.self) { level in
                    Text(level).tag(level)
                }
            }

            HStack {
                Button {
                    location.requestOnce()
                } label: {
                    Label(location.coordinate == nil ? "记录位置" : "已记录位置",
                          systemImage: "location.fill")
                        .font(.footnote)
                }
                Spacer()
                Text(location.statusText)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .onChange(of: location.coordinate?.latitude) { _ in
                if let coordinate = location.coordinate {
                    draft.latitude = coordinate.latitude
                    draft.longitude = coordinate.longitude
                }
            }
        } header: {
            Text("设备与项目")
        }
    }

    // MARK: - 描述

    @ViewBuilder
    private var detailSection: some View {
        Section {
            TextEditor(text: $draft.detail)
                .frame(minHeight: 110)

            if speech.isRecording || !speech.transcript.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: speech.isRecording ? "waveform" : "text.quote")
                        .foregroundColor(speech.isRecording ? .red : .secondary)
                    Text(speech.transcript.isEmpty ? "正在听…" : speech.transcript)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                .onChange(of: speech.transcript) { value in
                    if !value.isEmpty { draft.detail = value }
                }
            }

            if let error = speech.errorMessage {
                Text(error)
                    .font(.caption2)
                    .foregroundColor(.red)
            }

            HStack(spacing: 12) {
                Button {
                    if speech.isRecording {
                        speech.stop()
                    } else {
                        speech.start()
                    }
                } label: {
                    Label(speech.isRecording ? "停止" : "语音输入",
                          systemImage: speech.isRecording ? "stop.circle.fill" : "mic.fill")
                        .font(.footnote)
                        .foregroundColor(speech.isRecording ? .red : Theme.accent)
                }

                Button {
                    showPhrases.toggle()
                } label: {
                    Label("常用短语", systemImage: "text.bubble")
                        .font(.footnote)
                }

                Spacer()

                if aiBusy {
                    ProgressView().scaleEffect(0.8)
                } else {
                    Button {
                        aiStructure()
                    } label: {
                        Label("AI 整理", systemImage: "sparkles")
                            .font(.footnote)
                    }
                    .disabled(draft.detail.isEmpty)
                }
            }

            if let image = currentFirstImage {
                Button {
                    aiPrefill(image)
                } label: {
                    Label("AI 看图预填（描述/类型/紧急度）", systemImage: "wand.and.stars")
                        .font(.footnote)
                }
                .disabled(aiBusy)
            }

            if showPhrases {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(settings.phrases, id: \.self) { phrase in
                            Button {
                                if draft.detail.isEmpty {
                                    draft.detail = phrase
                                } else {
                                    draft.detail += "，" + phrase
                                }
                            } label: {
                                Chip(text: phrase, color: Theme.accent, background: Theme.chipBackground)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        } header: {
            Text("问题描述（必填）")
        } footer: {
            Text("写清故障现象、影响范围、初步判断；可语音口述后点 AI 整理。")
        }
    }

    // MARK: - 停机与人员

    @ViewBuilder
    private var timeSection: some View {
        Section {
            HStack {
                Text("报修人")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                TextField("填写姓名", text: $draft.reporter)
                    .multilineTextAlignment(.trailing)
                if !settings.people.isEmpty {
                    Menu {
                        ForEach(settings.people, id: \.self) { person in
                            Button(person) { draft.reporter = person }
                        }
                    } label: {
                        Image(systemName: "person.crop.circle.badge.plus")
                    }
                }
            }

            HStack {
                Text("责任人")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                TextField("填写姓名", text: $draft.owner)
                    .multilineTextAlignment(.trailing)
                if !settings.people.isEmpty {
                    Menu {
                        ForEach(settings.people, id: \.self) { person in
                            Button(person) { draft.owner = person }
                        }
                    } label: {
                        Image(systemName: "person.crop.circle.badge.checkmark")
                    }
                }
            }

            Toggle(isOn: Binding(
                get: { draft.startTime != nil },
                set: { on in draft.startTime = on ? Date() : nil }
            )) {
                Text("记录停机开始")
            }

            if draft.startTime != nil {
                DatePicker("停机开始", selection: Binding(
                    get: { draft.startTime ?? Date() },
                    set: { draft.startTime = $0 }
                ), displayedComponents: [.date, .hourAndMinute])

                DatePicker("恢复时间", selection: Binding(
                    get: { draft.endTime ?? Date() },
                    set: { draft.endTime = $0 }
                ), displayedComponents: [.date, .hourAndMinute])

                HStack {
                    Text("停机时长")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    Spacer()
                    Text(draft.downtimeMinutes.map { String(format: "%.0f 分钟", $0) } ?? "—")
                        .font(.subheadline)
                        .foregroundColor(Theme.orange)
                }
            } else {
                Text("未记录停机时长")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        } header: {
            Text("人员与停机")
        }
    }

    // MARK: - 处理

    @ViewBuilder
    private var handleSection: some View {
        Section {
            TextField("根因（如：气缸密封老化）", text: $draft.rootCause)
            TextField("处理措施（如：更换密封圈并复测）", text: $draft.action)
            TextField("更换备件（型号/数量）", text: $draft.parts)
            HStack {
                Text("费用（元）")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                TextField("0", text: Binding(
                    get: { draft.cost.map { String(format: "%.0f", $0) } ?? "" },
                    set: { draft.cost = Double($0) }
                ))
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
            }
        } header: {
            Text("处理记录")
        }
    }

    // MARK: - 自定义字段

    @ViewBuilder
    private var customSection: some View {
        Section {
            ForEach(settings.customFields) { field in
                customFieldRow(field)
            }
        } header: {
            Text("自定义字段")
        }
    }

    @ViewBuilder
    private func customFieldRow(_ field: CustomFieldDef) -> some View {
        switch field.kind {
        case .select where !field.options.isEmpty:
            Picker(field.name, selection: Binding(
                get: { draft.customValues[field.id.uuidString] ?? "" },
                set: { draft.customValues[field.id.uuidString] = $0 }
            )) {
                Text("未选").tag("")
                ForEach(field.options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
        default:
            HStack {
                Text(field.name)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                TextField(field.kind == .number ? "数字" : "填写", text: Binding(
                    get: { draft.customValues[field.id.uuidString] ?? "" },
                    set: { draft.customValues[field.id.uuidString] = $0 }
                ))
                .multilineTextAlignment(.trailing)
                .keyboardType(field.kind == .number ? .decimalPad : .default)
            }
        }
    }

    // MARK: - 状态与时间轴

    @ViewBuilder
    private var statusSection: some View {
        Section {
            Picker("处理状态", selection: $draft.status) {
                ForEach(FaultStatus.allCases) { status in
                    Text(status.rawValue).tag(status)
                }
            }

            if settings.reminderEnabled {
                Toggle(isOn: Binding(
                    get: { draft.reminderAt != nil },
                    set: { on in
                        draft.reminderAt = on
                            ? Date().addingTimeInterval(TimeInterval(settings.reminderHours * 3600))
                            : nil
                    }
                )) {
                    Text("到期提醒")
                }
                if let reminder = draft.reminderAt {
                    DatePicker("提醒时间", selection: Binding(
                        get: { reminder },
                        set: { draft.reminderAt = $0 }
                    ), displayedComponents: [.date, .hourAndMinute])
                }
            }
        } header: {
            Text("状态与提醒")
        }
    }

    @ViewBuilder
    private var timelineSection: some View {
        Section {
            if draft.timeline.isEmpty {
                Text("暂无记录")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            } else {
                ForEach(draft.timeline.sorted { $0.date > $1.date }) { event in
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Theme.accent.opacity(0.45))
                            .frame(width: 7, height: 7)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(event.text)
                                .font(.footnote)
                            Text(Self.timeFormatter.string(from: event.date))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        } header: {
            Text("处理时间轴")
        }
    }

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "MM-dd HH:mm"
        return formatter
    }()

    // MARK: - 交互回调

    private func handleCamera(_ image: UIImage?) {
        guard let image = image else { return }
        if totalPhotoCount >= 6 {
            aiMessage = "最多 6 张照片"
            return
        }
        newImages.append(image)
    }

    private func handleVideo(_ url: URL?) {
        guard let url = url else { return }
        if let name = store.saveVideo(from: url) {
            if let old = draft.video { store.deleteFile(named: old) }
            draft.video = name
        }
    }

    private func handleCode(_ code: String?) {
        activeSheet = nil
        guard let code = code else { return }
        draft.deviceCode = code
        if let device = settings.devices.first(where: { $0.code == code || $0.name == code }) {
            draft.deviceName = device.name
            if device.code.isEmpty == false { draft.deviceCode = device.code }
            if device.location.isEmpty == false { draft.location = device.location }
        } else if draft.deviceName.isEmpty {
            draft.deviceName = code
        }
    }

    // MARK: - OCR / AI

    private func recognizePlate(_ image: UIImage) {
        aiBusy = true
        OCRService.recognize(image) { text in
            aiBusy = false
            guard !text.isEmpty else {
                aiMessage = "没识别出文字，靠近铭牌再拍一张"
                return
            }
            draft.deviceCode = text
            if draft.detail.isEmpty {
                draft.detail = "铭牌识别：\(text)"
            }
        }
    }

    private func aiPrefill(_ image: UIImage) {
        aiBusy = true
        AIService.prefill(image: image, settings: settings) { result in
            aiBusy = false
            switch result {
            case .success(let suggestion):
                if !suggestion.deviceName.isEmpty && draft.deviceName.isEmpty {
                    draft.deviceName = suggestion.deviceName
                }
                if !suggestion.deviceCode.isEmpty && draft.deviceCode.isEmpty {
                    draft.deviceCode = suggestion.deviceCode
                }
                if !suggestion.faultType.isEmpty && FaultCatalog.faultTypes.contains(suggestion.faultType) {
                    draft.faultType = suggestion.faultType
                }
                if !suggestion.urgency.isEmpty && FaultCatalog.urgencies.contains(suggestion.urgency) {
                    draft.urgency = suggestion.urgency
                }
                if !suggestion.detail.isEmpty {
                    draft.detail = suggestion.detail
                }
                if suggestion.isEmpty { aiMessage = "AI 没给出有效结论，手动填一下" }
            case .failure(let error):
                aiMessage = error.localizedDescription
            }
        }
    }

    private func aiStructure() {
        aiBusy = true
        AIService.structure(text: draft.detail, settings: settings) { result in
            aiBusy = false
            switch result {
            case .success(let suggestion):
                if !suggestion.deviceName.isEmpty && draft.deviceName.isEmpty {
                    draft.deviceName = suggestion.deviceName
                }
                if !suggestion.faultType.isEmpty && FaultCatalog.faultTypes.contains(suggestion.faultType) {
                    draft.faultType = suggestion.faultType
                }
                if !suggestion.urgency.isEmpty && FaultCatalog.urgencies.contains(suggestion.urgency) {
                    draft.urgency = suggestion.urgency
                }
                if !suggestion.detail.isEmpty {
                    draft.detail = suggestion.detail
                }
            case .failure(let error):
                aiMessage = error.localizedDescription
            }
        }
    }

    // MARK: - 保存

    private func save() {
        speech.stop()
        var record = draft

        for image in newImages {
            if let name = store.savePhoto(image, record: record,
                                          showLocation: settings.watermarkShowLocation) {
                record.photos.append(name)
            }
        }

        record.deviceName = record.deviceName.trimmingCharacters(in: .whitespacesAndNewlines)
        record.detail = record.detail.trimmingCharacters(in: .whitespacesAndNewlines)

        if existing == nil {
            store.add(record)
        } else {
            store.update(record)
        }
        dismiss()
    }
}
