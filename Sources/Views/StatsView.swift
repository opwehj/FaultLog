import SwiftUI

/// 统计：总量、状态、故障类型分布、Top 设备、停机时长
struct StatsView: View {

    @EnvironmentObject private var store: FaultStore

    private var pendingCount: Int { store.records.filter { $0.status == .pending }.count }
    private var doingCount: Int { store.records.filter { $0.status == .doing }.count }
    private var fixedCount: Int { store.records.filter { $0.status == .fixed }.count }

    private var totalDowntimeMinutes: Double {
        store.records.compactMap { $0.downtimeMinutes }.reduce(0, +)
    }

    private var averageRepairMinutes: Double {
        let values = store.records.compactMap { $0.downtimeMinutes }
        guard !values.isEmpty else { return 0 }
        return values.reduce(0, +) / Double(values.count)
    }

    private struct Rank: Identifiable {
        var name: String
        var count: Int
        var id: String { name }
    }

    private var typeCounts: [Rank] {
        FaultCatalog.faultTypes.map { type in
            Rank(name: type, count: store.records.filter { $0.faultType == type }.count)
        }.sorted { $0.count > $1.count }
    }

    private var deviceCounts: [Rank] {
        var dict: [String: Int] = [:]
        for record in store.records {
            let key = record.deviceName.isEmpty ? "未填写设备" : record.deviceName
            dict[key, default: 0] += 1
        }
        return Array(dict.sorted { $0.value > $1.value }.prefix(6).map { Rank(name: $0.key, count: $0.value) })
    }

    private var monthlyCounts: [Rank] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        var dict: [String: Int] = [:]
        for record in store.records {
            dict[formatter.string(from: record.createdAt), default: 0] += 1
        }
        return Array(dict.sorted { $0.key < $1.key }.suffix(6).map { Rank(name: $0.key, count: $0.value) })
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 14) {
                    summaryCard
                    statusCard
                    typeCard
                    deviceCard
                    monthCard
                    downtimeCard
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
            }
            .background(Theme.pageBackground)
            .navigationTitle("统计")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }

    private var summaryCard: some View {
        CardBox {
            HStack(spacing: 0) {
                summaryItem(title: "总记录", value: "\(store.records.count)", color: Theme.accent)
                divider
                summaryItem(title: "待处理", value: "\(pendingCount)", color: Theme.statusColor(.pending))
                divider
                summaryItem(title: "停机合计", value: totalDowntimeMinutes > 0
                            ? String(format: "%.1f 时", totalDowntimeMinutes / 60) : "—",
                            color: Theme.orange)
            }
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(Theme.trackBackground)
            .frame(width: 1, height: 34)
    }

    private func summaryItem(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 5) {
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(color)
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var statusCard: some View {
        CardBox {
            VStack(alignment: .leading, spacing: 10) {
                Text("处理状态分布")
                    .font(.system(size: 13, weight: .semibold))
                HStack(spacing: 8) {
                    statusPill(.pending, count: pendingCount)
                    statusPill(.doing, count: doingCount)
                    statusPill(.fixed, count: fixedCount)
                }
                Text("平均停机 \(averageRepairMinutes > 0 ? String(format: "%.0f 分钟", averageRepairMinutes) : "—")")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
        }
    }

    private func statusPill(_ status: FaultStatus, count: Int) -> some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(Theme.statusColor(status))
            Text(status.rawValue)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Theme.statusBackground(status))
        .cornerRadius(10)
    }

    private var typeCard: some View {
        CardBox {
            VStack(alignment: .leading, spacing: 10) {
                Text("故障类型")
                    .font(.system(size: 13, weight: .semibold))
                let maxValue = typeCounts.map { $0.count }.max() ?? 0
                ForEach(typeCounts) { item in
                    StatBar(title: item.name, value: item.count, maxValue: maxValue, color: Theme.accent)
                }
            }
        }
    }

    private var deviceCard: some View {
        CardBox {
            VStack(alignment: .leading, spacing: 10) {
                Text("故障最多的设备")
                    .font(.system(size: 13, weight: .semibold))
                if deviceCounts.isEmpty {
                    Text("暂无数据").font(.footnote).foregroundColor(.secondary)
                } else {
                    let maxValue = deviceCounts.map { $0.count }.max() ?? 0
                    ForEach(deviceCounts) { item in
                        StatBar(title: item.name, value: item.count, maxValue: maxValue, color: Theme.orange)
                    }
                }
            }
        }
    }

    private var monthCard: some View {
        CardBox {
            VStack(alignment: .leading, spacing: 10) {
                Text("最近几个月")
                    .font(.system(size: 13, weight: .semibold))
                if monthlyCounts.isEmpty {
                    Text("暂无数据").font(.footnote).foregroundColor(.secondary)
                } else {
                    let maxValue = monthlyCounts.map { $0.count }.max() ?? 0
                    ForEach(monthlyCounts) { item in
                        StatBar(title: item.name, value: item.count, maxValue: maxValue,
                                color: Theme.teal)
                    }
                }
            }
        }
    }

    private var downtimeCard: some View {
        CardBox {
            VStack(alignment: .leading, spacing: 8) {
                Text("停机时长明细")
                    .font(.system(size: 13, weight: .semibold))
                if store.records.filter({ $0.downtimeMinutes != nil }).isEmpty {
                    Text("还没有记录停机时间的故障")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                } else {
                    ForEach(store.records.filter { $0.downtimeMinutes != nil }.prefix(6)) { record in
                        HStack {
                            Text(record.deviceName.isEmpty ? "未填写设备" : record.deviceName)
                                .font(.system(size: 12))
                                .lineLimit(1)
                            Spacer()
                            Text(record.downtimeMinutes.map { String(format: "%.0f 分钟", $0) } ?? "")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Theme.orange)
                        }
                    }
                }
            }
        }
    }
}
