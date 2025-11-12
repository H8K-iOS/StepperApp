import Foundation

extension Date {
    static var cpitalizedFirstLetterOfWeek: [String] {
        let calendar = Calendar.current
        let weekDays = calendar.shortWeekdaySymbols
        
        return weekDays.map { weekday in
            guard let firstLetter = weekday.first else { return "" }
            return String(firstLetter).capitalized
        }
    }
    
    var startOfMonth: Date {
        Calendar.current.dateInterval(of: .month, for: self)!.start
    }
    
    var calendarViewEndOfMonth: Date {
        let lastDay = Calendar.current.dateInterval(of: .month, for: self)!.end
        return Calendar.current.date(byAdding: .day, value: -1, to: lastDay)!
    }
    
    var valueEndOfMont: Date {
        let lastDay = Calendar.current.dateInterval(of: .month, for: self)!.end
        return Calendar.current.date(byAdding: .day, value: 0, to: lastDay)!
    }
    
    var startOfPreviusMonth: Date {
        let dayInPreviusMonth = Calendar.current.date(byAdding: .month, value: -1, to: self)
        return dayInPreviusMonth!.startOfMonth
    }
    
    var numbersOfDayInMonth: Int {
        Calendar.current.component(.day, from: calendarViewEndOfMonth)
    }
    
    var sundayBeforeStart: Date {
        let calendar = Calendar.current
        var weekday = Calendar.current.component(.weekday, from: startOfMonth)
        weekday = (weekday + 5) % 7 + 1
        let numbFromPrevMonth = weekday - 1
        return Calendar.current.date(byAdding: .day, value: -numbFromPrevMonth, to: startOfMonth)!
    }
    
    var calendarDisplayDays: [Date] {
        var days: [Date] = []
        
        for dayOffset in 0..<numbersOfDayInMonth {
            let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfMonth)
            days.append(newDay!)
        }
        
        for dayOffset in 0..<startOfPreviusMonth.numbersOfDayInMonth {
            let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfPreviusMonth)
            days.append(newDay!)
        }
        
        return days.filter({ $0 >= sundayBeforeStart && $0 <= calendarViewEndOfMonth}).sorted(by: <)
    }
    
    var monthInt: Int {
        Calendar.current.component(.month, from: self)
    }
}
