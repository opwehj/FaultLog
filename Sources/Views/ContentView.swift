import SwiftUI
import LocalAuthentication

/// 主容器：四个 Tab + 启动锁
struct ContentView: View {

    @EnvironmentObject private var store: FaultStore
    @EnvironmentObject private var settings: AppSettings
    @Environment(\.scenePhase) private var scenePhase

    @State private var locked = false
    @State private var authError: String?

    var body: some View {
        TabView {
            RecordListView()
                .tabItem {
                    Label("台账", systemImage: "list.bullet.rectangle")
                }
            KanbanView()
                .tabItem {
                    Label("看板", systemImage: "rectangle.split.3x1")
                }
            StatsView()
                .tabItem {
                    Label("统计", systemImage: "chart.bar.xaxis")
                }
            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gearshape")
                }
        }
        .accentColor(Theme.accent)
        .overlay(lockOverlay)
        .onAppear {
            if settings.lockEnabled {
                locked = true
                authenticate()
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background && settings.lockEnabled && settings.lockOnBackground {
                locked = true
            }
            if phase == .active && locked {
                authenticate()
            }
        }
    }

    @ViewBuilder
    private var lockOverlay: some View {
        if locked {
            ZStack {
                Theme.navy.ignoresSafeArea()
                VStack(spacing: 18) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 52))
                        .foregroundColor(Theme.orange)
                    Text("设备故障台账")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    Text("客户数据已锁定")
                        .font(.footnote)
                        .foregroundColor(Color.white.opacity(0.7))
                    if let error = authError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(Color.orange.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    Button {
                        authenticate()
                    } label: {
                        Text("解锁")
                            .font(.system(size: 15, weight: .semibold))
                            .padding(.horizontal, 34)
                            .padding(.vertical, 12)
                            .background(Theme.orange)
                            .foregroundColor(.white)
                            .cornerRadius(24)
                    }
                    .padding(.top, 6)
                }
            }
            .transition(.opacity)
        }
    }

    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            locked = false
            return
        }
        context.evaluatePolicy(.deviceOwnerAuthentication,
                               localizedReason: "解锁设备故障台账") { success, _ in
            DispatchQueue.main.async {
                if success {
                    locked = false
                    authError = nil
                } else {
                    authError = "验证未通过，请重试"
                }
            }
        }
    }
}
