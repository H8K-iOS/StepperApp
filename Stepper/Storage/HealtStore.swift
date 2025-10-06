import Foundation
import HealthKit
import Observation

//MARK: - error throw
enum HealtError: Error {
    case healtDataIsNotAvailable
}

@Observable
final class HealtStore {
    var steps: [StepModel] = []
    var healtStore: HKHealthStore?
    var lastError: Error?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            self.healtStore = HKHealthStore()
        } else {
            self.lastError = HealtError.healtDataIsNotAvailable
        }
    }
    
    //MARK: - Methods
    public func getSteps() async throws {
        guard let healtStore = self.healtStore else { return }
        
        let calendar = Calendar(identifier: .gregorian)
        let startDate = calendar.date(byAdding: .day, value: -7, to: Date())
        let endData = Date()
        
        let stepType = HKQuantityType(.stepCount)
        let everyDay = DateComponents(day: 1)
        let thisWeek = HKQuery.predicateForSamples(withStart: startDate, end: endData)
        let stepsThisWeek = HKSamplePredicate.quantitySample(type: stepType, predicate: thisWeek)
        
       let sumOfStepsQuery = HKStatisticsCollectionQueryDescriptor(predicate: stepsThisWeek, options: .cumulativeSum, anchorDate: endData, intervalComponents: everyDay)
        
        let stepCount = try await sumOfStepsQuery.result(for: healtStore)
        
        guard let startDate = startDate else { return }
        
        stepCount.enumerateStatistics(from: startDate, to: endData) { statistics, stop in
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            let step = StepModel(count: Int(count ?? 0), date: statistics.startDate)
            
            if step.count > 0 {
                self.steps.append(step)
            }
        }
    }
    
    public func requestAuth() async {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        guard let healtStore = self.healtStore else { return }
        
        do {
            try await healtStore.requestAuthorization(toShare: [], read: [stepType])
        } catch {
            self.lastError = error
        }
    }
}
