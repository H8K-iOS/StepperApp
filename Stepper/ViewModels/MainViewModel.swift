import Foundation


final class MainViewModel: ObservableObject {
    //user defaults
    private let kStepGoal = "stepGoal"
    private let kStreak = "activeStreak"
    private let kStepsToday = "steps"
    private let kCalories = "calories"
    
    private let widgetManager: WidgetRefreshable
    private let widgetStyleService = WidgetStyleService()
    var healthStore = HealtStore()
    @Published var activeStreak: Int = 0 {
        didSet {
            saveStreak()
            widgetManager.refresh()
        }
    }
    
    @Published var previusStreak: Int? = nil {
        didSet {
            saveStreak()
            widgetManager.refresh()
        }
    }
    
    @Published var goal: Int = 5000 {
        didSet {
            saveGoal()
            widgetManager.refresh()
            Task { @MainActor in
                      try? await Task.sleep(nanoseconds: 50000000)
                      self.updateStreak(goal: self.goal)
                  }
        }
    }
    
    private var caloriesToday: Int = 0 {
        didSet {
            
            widgetManager.refresh()
        }
    }
    private var distanceToday: Int = 0 {
        didSet {
            
            widgetManager.refresh()
        }
    }
    //MARK: - Initializer
    init(widgetManager: WidgetRefreshable = WidgetManager()) {
        self.widgetManager = widgetManager
        loadGoal()
        self.healthStore.enableBackgroundUpdate()
        
        Task { await setupHK() }
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
    
    //MARK: - Methods
    ///Health kit methods
    ///
    private func setupHK() async {
        await healthStore.requestAuth()
        //Steps
        try? await healthStore.getTodaySteps()
        saveStepsToday()
       
        //Calories
        
        //Distance
        
        //Widget
        widgetManager.refresh()
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
                self.saveStreak()
                self.saveStepsToday()
                widgetManager.refresh()
            }
        } catch {
            print("//Debug//")
        }
    }
    
    //MARK: UserDefaults Methods
    ///Goal
    ///for widget
    func saveGoal() {
        let shared = UserDefaults(suiteName: "group.com.mycompany.stepperApp")
        shared?.set(self.goal, forKey: kStepGoal)
        
    }
    
    func loadGoal() {
        let shared = UserDefaults(suiteName: "group.com.mycompany.stepperApp")
            let saved = shared?.integer(forKey: kStepGoal) ?? 0
            self.goal = saved == 0 ? 5000 : saved
    }
    ///Steps today
    ///for widget
    func saveStepsToday() {
        let shared = UserDefaults(suiteName: "group.com.mycompany.stepperApp")
        let steps = todaySteps.first?.count ?? 0
        shared?.set(steps, forKey: kStepsToday)
    }
    
    ///Streak Active
    ///for widget
    func saveStreak() {
        let shared = UserDefaults(suiteName: "group.com.mycompany.stepperApp")
        if activeStreak == 0 {
            guard let previusStreak else { return }
            shared?.set(previusStreak, forKey: kStreak)
        } else {
            shared?.set(activeStreak, forKey: kStreak)
        }
    }
    
    ///Calories today
    ///for widget
    func saveCalories() {
        let shared = UserDefaults(suiteName: "group.com.mycompany.stepperApp")
        shared?.set(self.caloriesToday, forKey: kCalories)
    }
    
    ///Distance today
    ///for widget
    func saveDistance() {
        
    }
    
    //MARK: - Other Methods in App
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
