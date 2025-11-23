import SwiftUI

@main
struct StepperApp: App {
    var body: some Scene {
        WindowGroup {
            HomeStepView()
                .environmentObject(MainViewModel())
                .withRouter()
        }
    }
}
