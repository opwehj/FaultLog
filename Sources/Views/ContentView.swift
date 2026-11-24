import SwiftUI
import UIKit

struct ContentView: View {

    @EnvironmentObject private var store: FaultStore
    @State private var activeSheet: ActiveSheet?

    enum ActiveSheet: Identifiable {
        case camera
        case editor(UIImage?, FaultRecord?)
        case share(URL)

        var id: String {
            switch self {
            case .camera: return "camera"
            case .editor: return "editor"
            case .share: return "share"
            }
        }
    }

    var body: some View {
        NavigationView {
            content
                .navigationTitle("设备故障台账")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        exportMenu
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            activeSheet = .camera
                        } label: {
                            Image(systemName: "camera.fill")
                        }
                    }
                }
                .sheet(item: $activeSheet) { sheet in
                    switch sheet {
                    case .camera:
                        CameraPicker(onImage: handleCamera)
                    case .editor(let photo, let existing):
                        RecordEditorView(photo: photo, existing: existing)
                    case .share(let url):
                        ShareSheet(items: [url])
                    }
                }
        }
        .navigationViewStyle(.stack)
    }

    // MARK: - 主体

    @ViewBuilder
    private var content: some View {
        if store.records.isEmpty {
            emptyState
        } else {
            recordList
        }
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 56))
                .foregroundColor(.secondary.opacity(0.6))
            Text("还没有记录")
                .font(.headline)
                .foregroundColor(.primary)
            Text("点右上角相机，拍下设备问题\n拍完会自动弹出填写框")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Button {
                activeSheet = .camera
            } label: {
                Text("拍第一张")
                    .font(.headline)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 12)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(22)
            }
            .padding(.top, 6)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGroupedBackground))
    }

    private var recordList: some View {
        List {
            Section {
                ForEach(store.records) { record in
                    FaultRowView(record: record)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            activeSheet = .editor(nil, record)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                store.delete(record)
                            } label: {
                                Label("删除", systemImage: "trash")
                            }
                        }
                        .contextMenu {
                            ForEach(FaultStatus.allCases) { status in
                                Button {
                                    var updated = record
                                    updated.status = status
                                    store.update(updated)
                                } label: {
                                    Label(status.rawValue, systemImage: record.status == status ? "checkmark" : "circle")
                                }
                            }
                        }
                }
            } header: {
                HStack {
                    Text("共 \(store.records.count) 条")
                    Spacer()
                    Text("点一条可编辑 · 长按改状态")
                }
                .font(.caption)
            }
        }
        .listStyle(.insetGrouped)
    }

    // MARK: - 导出

    private var exportMenu: some View {
        Menu {
            Button {
                presentShare(store.exportCSV())
            } label: {
                Label("导出 CSV（Excel 打开）", systemImage: "tablecells")
            }
            Button {
                presentShare(store.exportHTML())
            } label: {
                Label("导出图文报告（带照片）", systemImage: "doc.richtext")
            }
        } label: {
            Image(systemName: "square.and.arrow.up")
        }
        .disabled(store.records.isEmpty)
    }

    private func presentShare(_ url: URL?) {
        guard let url = url else { return }
        activeSheet = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            activeSheet = .share(url)
        }
    }

    // MARK: - 拍照回调：拍完自动弹填写框

    private func handleCamera(_ image: UIImage?) {
        guard let image = image else {
            activeSheet = nil
            return
        }
        activeSheet = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            activeSheet = .editor(image, nil)
        }
    }
}

// MARK: - 列表行

struct FaultRowView: View {
    let record: FaultRecord
    @EnvironmentObject private var store: FaultStore

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            thumbnail
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 6) {
                    Text(record.deviceName.isEmpty ? "未填写设备" : record.deviceName)
                        .font(.headline)
                        .lineLimit(1)
                    if record.urgency != FaultCatalog.urgencies[0] {
                        Text(record.urgency)
                            .font(.caption2)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.red)
                            .cornerRadius(4)
                    }
                    Spacer(minLength: 0)
                    Text(record.status.rawValue)
                        .font(.caption2)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2)
                        .background(statusColor.opacity(0.14))
                        .foregroundColor(statusColor)
                        .cornerRadius(5)
                }

                if !record.location.isEmpty {
                    Text(record.location)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                Text(record.detail)
                    .font(.subheadline)
                    .foregroundColor(.primary.opacity(0.85))
                    .lineLimit(2)

                HStack(spacing: 6) {
                    Text(record.faultType)
                    Text("·")
                    Text(record.createdAt.faultTimeText)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }

    private var statusColor: Color {
        switch record.status {
        case .pending: return .orange
        case .doing: return .blue
        case .fixed: return .green
        }
    }

    private var thumbnail: some View {
        Group {
            if let image = store.photo(named: record.photoFileName) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Color(UIColor.secondarySystemBackground)
                    Image(systemName: "photo")
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(width: 62, height: 62)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

// MARK: - 时间显示

extension Date {
    var faultTimeText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "MM-dd HH:mm"
        return formatter.string(from: self)
    }
}
