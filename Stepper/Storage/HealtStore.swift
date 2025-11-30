import Foundation
import HealthKit
import Observation


//MARK: - error throw
enum HealtError: Error {
    case healtDataIsNotAvailable
}

@Observable
final class HealtStore {
    var todaySteps: [StepModel] = []
    var totalSteps: [StepModel] = []
    var weekSteps: [StepModel] = []
    var monthSteps: [StepModel] = []
    var healtStore: HKHealthStore?
    var lastError: Error?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            self.healtStore = HKHealthStore()
        } else {
            self.lastError = HealtError.healtDataIsNotAvailable
        }
    }
    //MARK: - Methods Auth HK
    ///MARK: HealthStore setup
    ///
    public func requestAuth() async {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        guard let healtStore = self.healtStore else { return }
        
        do {
            try await healtStore.requestAuthorization(toShare: [], read: [stepType])
        } catch {
            self.lastError = error
        }
    }
    
    //MARK: - Methods Steps
    ///MARK: today steps
    public func getTodaySteps() async throws {
        guard let healtStore = self.healtStore else { return }
        let stepType = HKQuantityType(.stepCount)
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: stepType,
                                          quantitySamplePredicate: predicate,
                                          options: .cumulativeSum) { _, result, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let sum = result?.sumQuantity() else {
                    continuation.resume(returning: ())
                    return
                }
                
                
                let count = sum.doubleValue(for: .count())
                let step = StepModel(count: Int(count), date: startOfDay)
                
                DispatchQueue.main.async {
                    self.todaySteps = [step]
                    continuation.resume(returning: ())
                }
            }
            healtStore.execute(query)
        }
    }
    
    /// MARK: week steps
    /// debug func
    public func getWeekSteps() async throws {
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
                DispatchQueue.main.async {
                    self.weekSteps.append(step)
                }
            }
        }
    }
    
    ///MARK: month steps
    ///
    public func getMonthSteps(for date: Date) async throws {
        guard let healtStore = healtStore else { return }
        let startDate = date.startOfMonth
        let endDate = date.valueEndOfMont
        
        let stepType = HKQuantityType(.stepCount)
        let everyDay = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let stepThisMonth = HKSamplePredicate.quantitySample(type: stepType, predicate: predicate)
        
        let sumOfStepsQuery = HKStatisticsCollectionQueryDescriptor(predicate: stepThisMonth,
                                                                    options: .cumulativeSum,
                                                                    anchorDate: endDate,
                                                                    intervalComponents: everyDay)
        
        let stepCount = try await sumOfStepsQuery.result(for: healtStore)
        
        DispatchQueue.main.async {
            self.monthSteps.removeAll()
        }
        
        stepCount.enumerateStatistics(from: startDate, to: endDate) { statistic, _ in
            let count = statistic.sumQuantity()?.doubleValue(for: .count()) ?? 0
            let step = StepModel(count: Int(count), date: statistic.startDate)
            if step.count > 0 {
                DispatchQueue.main.async {
                    self.monthSteps.append(step)
                }
            }
        }
    }
    
    ///MARK: All steps for all time
    ///x Streaks
    public func getAlltimeSteps() async throws {
        guard let healtStore = healtStore else { return }
        let calendar = Calendar.current
        let stepType = HKQuantityType(.stepCount)
        let currentDate = Date()
        
        let startDate = calendar.date(byAdding: .year, value: -10, to: currentDate)
        let endDate = currentDate
        
        let interval = DateComponents(day: 1)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let stepsPredicate = HKSamplePredicate.quantitySample(type: stepType, predicate: predicate)
        
        let descriptor = HKStatisticsCollectionQueryDescriptor(predicate: stepsPredicate,
                                                               options: .cumulativeSum,
                                                               anchorDate: endDate,
                                                               intervalComponents: interval)
        
        let result = try await descriptor.result(for: healtStore)
        
        guard let startDate = startDate else {
            print("nil here")
            return
        }
        
        result.enumerateStatistics(from: startDate, to: endDate) { stats, _ in
            let count = stats.sumQuantity()?.doubleValue(for: .count()) ?? 0
            let step = StepModel(count: Int(count ?? 0), date: stats.startDate)
            
            if step.count > 0 {
                DispatchQueue.main.async {
                    self.totalSteps.append(step)
                }
            }
        }
        
    }
    
    //MARK: - Methods Calories
    public func getTodaysCalories() async throws {
        
    }
    
    //MARK: - Methods Distance
    public func getTodayDistance() async throws {
        
    }
}

//MARK: - Extensions
extension HealtStore {
    func enableBackgroundUpdate() {
        guard let healtStore = self.healtStore else { return }
        let stepType = HKQuantityType(.stepCount)
        
        healtStore.enableBackgroundDelivery(for: stepType, frequency: .immediate) { success, error in
            if success {
                let query = HKObserverQuery(sampleType: stepType, predicate: nil) { [weak self] _, _, error in
                    guard let self else { return }
                    
                    Task {
                        try? await self.getTodaySteps()
                    }
                }
                healtStore.execute(query)
            } else {
                self.lastError = error
            }
        }
    }
}
