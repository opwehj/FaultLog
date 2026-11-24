import SwiftUI

@main
struct FaultLogApp: App {
    @StateObject private var store = FaultStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
