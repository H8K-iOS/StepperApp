import Foundation

final class MainViewModel: ObservableObject {
    var healthStore = HealtStore()
    @Published var activeStreak: Int = 0
    @Published var previusStreak: Int? = nil
    var goal: Int = 8000
    
    //MARK: - Initializer
    init() {
        self.healthStore.enableBackgroundUpdate()
        
        Task {
            await setupHK()
        }
    }
    
    //MARK: Properties
    var montSteps: [StepModel] {
        self.healthStore.monthSteps.sorted { lhs, rhs in
            lhs.date > rhs.date
        }
    }
    
    var todaySteps: [StepModel] {
        self.healthStore.todaySteps
    }
    
    //MARK: Methods
    ///Health kit methods
    ///
    private func setupHK() async {
        await healthStore.requestAuth()
        try? await healthStore.getTodaySteps()
    }
    
    @MainActor
    func loadMonthSteps(_ date: Date) async {
        try? await healthStore.getMonthSteps(for: date)
    }
    
    func loadStepsForAllTime() async {
        do {
            try await healthStore.getAlltimeSteps()
            await MainActor.run {
                self.updateStreak(goal: goal)
            }
        } catch {
            print("//Debug//")
        }
    }
    
    //MARK: Other methods
    ///Streak Methods
    ///Updating + calculate actual streak
    func updateStreak(goal: Int) {
        let result = calculateStreak(from: healthStore.totalSteps, goal: goal)
        DispatchQueue.main.async {
            self.activeStreak = result.active
            self.previusStreak = result.previus
        }
    }
    
    private func calculateStreak(from steps: [StepModel], goal: Int) -> (active: Int, previus: Int?) {
        let calendar = Calendar.current
        let sorted = steps.sorted(by: { $0.date < $1.date })
        
        var activeStreak = 0
        var prevStreak: Int? = nil
        var isStreakBroken: Bool = false
        
        guard let first = sorted.first else { return (0, nil) }
        var prevDate = calendar.startOfDay(for: first.date)
        
        for step in sorted {
            let stepDate = calendar.startOfDay(for: step.date)
            let daysDiff = calendar.dateComponents([.day], from: prevDate, to: stepDate).day ?? 0
            
            if daysDiff > 1 {
                prevStreak = activeStreak
                activeStreak = 0
            }
            
            if step.count >= goal {
                activeStreak += 1
            } else {
                prevStreak = activeStreak
                activeStreak = 0
            }
            prevDate = stepDate
        }
        
        return (activeStreak, prevStreak)
    }
}


//MARK: - Extension
