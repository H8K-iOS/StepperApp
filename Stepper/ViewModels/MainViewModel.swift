import Foundation

final class MainViewModel: ObservableObject {
    var healthStore = HealtStore()
    
    //MARK: - Initializer
    init() {
        self.healthStore.enableBackgroundUpdate()
        
        Task {
            await setupHK()
        }
    }
    
    //MARK: Properties
    var weekSteps: [StepModel] {
        self.healthStore.steps.sorted { lhs, rhs in
            lhs.date > rhs.date
        }
    }
    
    var todaySteps: [StepModel] {
        self.healthStore.todaySteps
    }

    //MARK: Methods
    private func setupHK() async {
        await healthStore.requestAuth()
        try? await healthStore.getWeekSteps()
        try? await healthStore.getTodaySteps()
    }
}
