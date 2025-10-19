import SwiftUI

@main
struct StepperApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(MainViewModel())
        }
    }
}
