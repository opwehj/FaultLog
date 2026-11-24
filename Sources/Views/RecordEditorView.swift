import SwiftUI
import UIKit

/// 新增/编辑一条故障记录
struct RecordEditorView: View {

    @EnvironmentObject private var store: FaultStore
    @Environment(\.dismiss) private var dismiss

    let photo: UIImage?
    let existing: FaultRecord?

    @State private var deviceName: String
    @State private var location: String
    @State private var faultType: String
    @State private var urgency: String
    @State private var detail: String
    @State private var status: FaultStatus

    init(photo: UIImage?, existing: FaultRecord?) {
        self.photo = photo
        self.existing = existing
        _deviceName = State(initialValue: existing?.deviceName ?? "")
        _location = State(initialValue: existing?.location ?? "")
        _faultType = State(initialValue: existing?.faultType ?? FaultCatalog.faultTypes[0])
        _urgency = State(initialValue: existing?.urgency ?? FaultCatalog.urgencies[0])
        _detail = State(initialValue: existing?.detail ?? "")
        _status = State(initialValue: existing?.status ?? .pending)
    }

    private var canSave: Bool {
        !deviceName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !detail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationView {
            Form {
                photoSection

                Section {
                    TextField("设备名称 / 编号（必填）", text: $deviceName)
                    TextField("位置 / 产线 / 工位", text: $location)
                    Picker("故障类型", selection: $faultType) {
                        ForEach(FaultCatalog.faultTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    Picker("紧急程度", selection: $urgency) {
                        ForEach(FaultCatalog.urgencies, id: \.self) { level in
                            Text(level).tag(level)
                        }
                    }
                } header: {
                    Text("故障信息")
                }

                Section {
                    TextEditor(text: $detail)
                        .frame(minHeight: 120)
                } header: {
                    Text("问题描述（必填）")
                } footer: {
                    Text("写清故障现象、影响范围、初步判断，方便维修对照。")
                }

                if existing != nil {
                    Section {
                        Picker("处理状态", selection: $status) {
                            ForEach(FaultStatus.allCases) { item in
                                Text(item.rawValue).tag(item)
                            }
                        }
                    } header: {
                        Text("跟进")
                    }
                }
            }
            .navigationTitle(existing == nil ? "新增故障" : "编辑记录")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") { save() }
                        .disabled(!canSave)
                }
            }
        }
        .navigationViewStyle(.stack)
    }

    @ViewBuilder
    private var photoSection: some View {
        Section {
            if let image = photo ?? store.photo(named: existing?.photoFileName) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 260)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            } else {
                Text("暂无照片")
                    .foregroundColor(.secondary)
            }
        } header: {
            Text("故障照片")
        }
    }

    private func save() {
        var record = existing ?? FaultRecord()
        record.deviceName = deviceName.trimmingCharacters(in: .whitespacesAndNewlines)
        record.location = location.trimmingCharacters(in: .whitespacesAndNewlines)
        record.faultType = faultType
        record.urgency = urgency
        record.detail = detail.trimmingCharacters(in: .whitespacesAndNewlines)
        record.status = status

        if let image = photo, let name = store.savePhoto(image) {
            if let old = record.photoFileName {
                store.deletePhoto(named: old)
            }
            record.photoFileName = name
        }

        if existing == nil {
            store.add(record)
        } else {
            store.update(record)
        }
        dismiss()
    }
}
