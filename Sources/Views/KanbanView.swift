import SwiftUI

/// 看板视图：待处理 / 处理中 / 已修复 三列
struct KanbanView: View {

    @EnvironmentObject private var store: FaultStore
    @EnvironmentObject private var settings: AppSettings
    @State private var editing: FaultRecord?
    @State private var movingStatus: FaultStatus? = nil

    var body: some View {
        NavigationView {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(FaultStatus.allCases) { status in
                        column(for: status)
                            .frame(width: 290)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
            }
            .background(Theme.pageBackground)
            .navigationTitle("看板")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
        .fullScreenCover(item: $editing) { record in
            RecordEditorView(existing: record)
                .environmentObject(store)
                .environmentObject(settings)
        }
    }

    private func records(for status: FaultStatus) -> [FaultRecord] {
        store.records.filter { $0.status == status }
    }

    private func column(for status: FaultStatus) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Circle()
                    .fill(Theme.statusColor(status))
                    .frame(width: 9, height: 9)
                Text(status.rawValue)
                    .font(.system(size: 15, weight: .semibold))
                Text("\(records(for: status).count)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 2)
                    .background(Theme.cardBackground)
                    .cornerRadius(9)
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)

            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(records(for: status)) { record in
                        kanbanCard(record)
                            .onTapGesture { editing = record }
                    }
                    if records(for: status).isEmpty {
                        Text("暂无")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 24)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 14)
            }
            .frame(maxHeight: .infinity)
        }
        .background(Theme.cardBackground.opacity(0.55))
        .cornerRadius(16)
    }

    private func kanbanCard(_ record: FaultRecord) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(record.deviceName.isEmpty ? "未填写设备" : record.deviceName)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(1)
                Spacer()
                if record.urgency != FaultCatalog.urgencies[0] {
                    Chip(text: record.urgency, color: .white,
                         background: Theme.urgencyColor(record.urgency))
                }
            }
            Text(record.detail)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .lineLimit(2)
            HStack(spacing: 6) {
                Text(record.faultType)
                Text("·")
                Text(record.createdAt.faultTimeText)
                Spacer()
                if let owner = Optional(record.owner), !owner.isEmpty {
                    Text(owner)
                        .foregroundColor(Theme.orange)
                }
            }
            .font(.system(size: 10))
            .foregroundColor(.secondary)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 1)
        .contextMenu {
            ForEach(FaultStatus.allCases) { status in
                Button {
                    store.changeStatus(record, to: status)
                } label: {
                    Label(status.rawValue, systemImage: status == record.status ? "checkmark" : "arrow.right")
                }
            }
        }
    }
}
