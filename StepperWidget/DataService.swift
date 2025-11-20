import SwiftUI
import Foundation

struct DataService {
    @AppStorage("stepGoal",
                store: UserDefaults(suiteName: "group.com.mycompany.stepperApp"))
    private var goal: Int = 5000
    
    
    @AppStorage("steps",
                store: UserDefaults(suiteName: "group.com.mycompany.stepperApp"))
    private var steps: Int = 0
    
    
    @AppStorage("activeStreak",
                store: UserDefaults(suiteName: "group.com.mycompany.stepperApp"))
    private var streak: Int = 0
    
    //MARK: Methods 
    func getGoal() -> Int {
        return goal
    }
    
    func getSteps() -> Int {
        return steps
    }
    func getStreak() -> Int {
        return streak
    }
}
