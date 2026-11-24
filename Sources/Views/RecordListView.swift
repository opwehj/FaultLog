import SwiftUI
import UIKit

/// 台账列表：搜索、筛选、导出
struct RecordListView: View {

    @EnvironmentObject private var store: FaultStore
    @EnvironmentObject private var settings: AppSettings

    @State private var searchText: String = ""
    @State private var statusFilter: FaultStatus? = nil
    @State private var projectFilter: String = ""
    @State private var currentSheet: Sheet?
    @State private var pendingImage: UIImage?
    @State private var exportOnlyFiltered = true
    @State private var toast: String?

    enum Sheet: Identifiable {
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

    private var filtered: [FaultRecord] {
        store.records.filter { record in
            if let status = statusFilter, record.status != status { return false }
            if !projectFilter.isEmpty && record.project != projectFilter { return false }
            guard !searchText.isEmpty else { return true }
            let haystack = [record.deviceName, record.deviceCode, record.location,
                            record.detail, record.project, record.faultType,
                            record.reporter, record.owner].joined(separator: " ")
            return haystack.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                filterBar
                content
            }
            .background(Theme.pageBackground)
            .navigationTitle("设备故障台账")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    exportMenu
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        currentSheet = .camera
                    } label: {
                        Image(systemName: "camera.fill")
                    }
                }
            }
            .sheet(item: $currentSheet) { sheet in
                switch sheet {
                case .camera:
                    CameraPicker(mode: .photo, onImage: handleCamera)
                case .editor(let image, let record):
                    RecordEditorView(images: image.map { [$0] } ?? [], existing: record)
                        .environmentObject(store)
                        .environmentObject(settings)
                case .share(let url):
                    ShareSheet(items: [url])
                }
            }
            .alert(isPresented: Binding(get: { toast != nil }, set: { if !$0 { toast = nil } })) {
                Alert(title: Text("导出提示"), message: Text(toast ?? ""), dismissButton: .default(Text("好")))
            }
            .searchable(text: $searchText, prompt: "搜索设备 / 描述 / 位置 / 人员")
        }
        .navigationViewStyle(.stack)
    }

    // MARK: - 筛选条

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterChip(title: "全部", active: statusFilter == nil) {
                    statusFilter = nil
                }
                ForEach(FaultStatus.allCases) { status in
                    filterChip(title: status.rawValue, active: statusFilter == status,
                               color: Theme.statusColor(status)) {
                        statusFilter = statusFilter == status ? nil : status
                    }
                }
                if !settings.projects.isEmpty {
                    Menu {
                        Button("全部项目") { projectFilter = "" }
                        ForEach(settings.projects) { project in
                            Button(project.name) { projectFilter = project.name }
                        }
                    } label: {
                        HStack(spacing: 3) {
                            Text(projectFilter.isEmpty ? "项目" : projectFilter)
                            Image(systemName: "chevron.down").font(.system(size: 9))
                        }
                        .font(.system(size: 12, weight: .medium))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(projectFilter.isEmpty ? Color.white : Theme.navy)
                        .foregroundColor(projectFilter.isEmpty ? Theme.navy : .white)
                        .cornerRadius(9)
                    }
                }
                Text("共 \(filtered.count) 条")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .padding(.leading, 2)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
        }
        .background(Color.white.opacity(0.6))
    }

    private func filterChip(title: String, active: Bool,
                            color: Color = Theme.navy,
                            action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .padding(.horizontal, 11)
                .padding(.vertical, 6)
                .background(active ? color : Color.white)
                .foregroundColor(active ? .white : color)
                .cornerRadius(9)
        }
        .buttonStyle(.plain)
    }

    // MARK: - 列表

    @ViewBuilder
    private var content: some View {
        if store.records.isEmpty {
            emptyState
        } else if filtered.isEmpty {
            VStack(spacing: 10) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.system(size: 40))
                    .foregroundColor(.secondary.opacity(0.5))
                Text("没有符合筛选条件的记录")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List {
                ForEach(filtered) { record in
                    RecordRow(record: record, store: store)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .padding(.vertical, 2)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            openEditor(record)
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
                                    store.changeStatus(record, to: status)
                                } label: {
                                    Label(status.rawValue,
                                          systemImage: record.status == status ? "checkmark" : "circle")
                                }
                            }
                            Button {
                                shareCard(record)
                            } label: {
                                Label("生成分享卡片", systemImage: "square.and.arrow.up")
                            }
                        }
                }
            }
            .listStyle(.plain)
            .background(Theme.pageBackground)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Theme.navy.opacity(0.06))
                    .frame(width: 120, height: 120)
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 44))
                    .foregroundColor(Theme.navy.opacity(0.55))
            }
            Text("还没有记录")
                .font(.system(size: 18, weight: .semibold))
            Text("点右上角相机，拍下设备问题\n拍完自动弹出填写框，照片会自动加水印")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
            Button {
                currentSheet = .camera
            } label: {
                Label("拍第一张", systemImage: "camera.fill")
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.horizontal, 26)
                    .padding(.vertical, 12)
                    .background(Theme.navy)
                    .foregroundColor(.white)
                    .cornerRadius(24)
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.pageBackground)
    }

    // MARK: - 导出菜单

    private var exportMenu: some View {
        Menu {
            Section {
                Toggle("仅导出当前筛选结果", isOn: $exportOnlyFiltered)
            }
            Button {
                present(ExportService.exportXLSX(records: exportRecords, settings: settings))
            } label: {
                Label("导出 Excel（.xlsx）", systemImage: "tablecells")
            }
            Button {
                present(ExportService.exportCSV(records: exportRecords, settings: settings))
            } label: {
                Label("导出 CSV", systemImage: "doc.plaintext")
            }
            Button {
                present(ExportService.exportHTML(records: exportRecords, store: store, settings: settings))
            } label: {
                Label("导出图文报告（HTML）", systemImage: "doc.richtext")
            }
            Button {
                present(PDFReport.build(records: exportRecords, store: store,
                                        title: "设备故障报告", settings: settings))
            } label: {
                Label("导出 PDF 报告", systemImage: "doc.badge.gearshape")
            }
        } label: {
            Image(systemName: "square.and.arrow.up")
        }
        .disabled(store.records.isEmpty)
    }

    private var exportRecords: [FaultRecord] {
        exportOnlyFiltered ? filtered : store.records
    }

    private func present(_ url: URL?) {
        guard let url = url else {
            toast = "导出失败，请重试"
            return
        }
        currentSheet = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            currentSheet = .share(url)
        }
    }

    private func shareCard(_ record: FaultRecord) {
        let image = CardRenderer.render(record: record, store: store, settings: settings)
        let url = FaultStore.documentsDirectory.appendingPathComponent("故障卡片_\(record.id.uuidString.prefix(6)).png")
        if let data = image.pngData() {
            try? data.write(to: url, options: .atomic)
            present(url)
        }
    }

    private func handleCamera(_ image: UIImage?) {
        guard let image = image else {
            currentSheet = nil
            return
        }
        currentSheet = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            currentSheet = .editor(image, nil)
        }
    }

    private func openEditor(_ record: FaultRecord) {
        currentSheet = .editor(nil, record)
    }
}

/// 列表行
struct RecordRow: View {
    let record: FaultRecord
    let store: FaultStore

    var body: some View {
        CardBox(padding: 12) {
            HStack(alignment: .top, spacing: 12) {
                thumbnail
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Text(record.deviceName.isEmpty ? "未填写设备" : record.deviceName)
                            .font(.system(size: 16, weight: .semibold))
                            .lineLimit(1)
                        if record.urgency != FaultCatalog.urgencies[0] {
                            Chip(text: record.urgency,
                                 color: .white,
                                 background: Theme.urgencyColor(record.urgency))
                        }
                        Spacer(minLength: 0)
                        Chip(text: record.status.rawValue,
                             color: Theme.statusColor(record.status),
                             background: Theme.statusBackground(record.status))
                    }

                    if !record.location.isEmpty || !record.project.isEmpty {
                        HStack(spacing: 6) {
                            if !record.project.isEmpty {
                                Text(record.project)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(Theme.orange)
                            }
                            if !record.location.isEmpty {
                                Text(record.location)
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }

                    Text(record.detail)
                        .font(.system(size: 13))
                        .foregroundColor(Color(white: 0.25, alpha: 1))
                        .lineLimit(2)
                        .lineSpacing(2)

                    HStack(spacing: 6) {
                        Text(record.faultType)
                        Text("·")
                        Text(record.createdAt.faultTimeText)
                        if let minutes = record.downtimeMinutes {
                            Text("·")
                            Text("停机 \(String(format: "%.0f", minutes)) 分")
                                .foregroundColor(Theme.orange)
                        }
                        Spacer(minLength: 0)
                        if !record.photos.isEmpty {
                            Label("\(record.photos.count)", systemImage: "photo")
                                .labelStyle(.titleAndIcon)
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                        }
                    }
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                }
            }
        }
    }

    private var thumbnail: some View {
        Group {
            if let name = record.photos.first, let image = store.photo(named: name) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Color(white: 0.95)
                    Image(systemName: "photo")
                        .foregroundColor(Color(white: 0.7, alpha: 1))
                }
            }
        }
        .frame(width: 68, height: 68)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
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
