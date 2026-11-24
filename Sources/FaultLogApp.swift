import SwiftUI

@main
struct FaultLogApp: App {

    @StateObject private var store = FaultStore()
    @StateObject private var settings = AppSettings.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(settings)
                .onAppear {
                    if settings.reminderEnabled {
                        NotificationService.shared.requestAuthorization()
                    }
                }
        }
    }
}
