//
//  DateTimeExtensions.swift
//  DateTimeExtensions
//
//  Created by Ariane Hine on 28/07/2021.
//

import Foundation
//Extensions to the date/time class
extension Date{
    //Gets the day of the week from a date
    static func getWeekday(date: Date) -> String {
        let customDateFormatter = DateFormatter();
        return customDateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: date ) - 1]
    }
    //Gets the month from a date
    static func getMonth(date: Date) -> String {
        let customDateFormatter = DateFormatter();
        return customDateFormatter.monthSymbols[Calendar.current.component(.month, from: date ) - 1]
    }
    //Gets the week which a date is, within the month
    static func getWeekOfMonth(date: Date) -> String{
        let numberOfWeeks = Calendar.current.component(.weekOfMonth, from: date)
        return String("Week " + String(numberOfWeeks))
    }
    //Gets today's date
    static func today() -> Date {
        return Date()
    }
    //Gets date of yesterday
    static func yesterday() -> Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }
    //Returns the date which is the start of the day for a certain date
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    //Gets the end of the day for a certain date
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    //Gets the start of the month from a date
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }
    //Gets start of the year from a date
    var startOfYear: Date {
        let components = Calendar.current.dateComponents([.year], from: startOfDay)
        return Calendar.current.date(from: components)!
    }
    //Gets the end of the month from a date
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
    //Returns the next date
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.next,
                   weekday,
                   considerToday: considerToday)
    }
    //Returns the prev date
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
        nextDateComponent.weekday = searchWeekdayIndex
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    //Get the name of a day from stringDate
    func getDayNameBy(stringDate: String) -> String
    {
        let df  = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: stringDate)!
        df.dateFormat = "EEEE"
        return df.string(from: date);
    }
    //Gets the day of the week in a string format
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case next
        case previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .next:
                return .forward
            case .previous:
                return .backward
            }
        }
    }
    //Converts a date into string format for parsing elsewhere
    public func dateToString(date: Date) -> String{
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        
        // Set Date Format
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // Convert Date to String
        return dateFormatter.string(from: date)
    }
    
    
    
}
