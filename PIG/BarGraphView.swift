//
//  BarGraphView.swift
//  PIG
//
//  Created by ariane hine on 18/05/2021.
//

import SwiftUI

import SwiftUI

struct BarGraphView: View {
    @Binding var selection: String
    @State var divisor = 0;
    @State var barWidth = 0;
    @Binding var reports: [Report]
    @Binding var originalReports: [Report]
    @EnvironmentObject var statsController: StatsDataController
    var body: some View {
        
        VStack {
                    
                    HStack(alignment: .lastTextBaseline) {
                        if !(reports.count == 0 || selection == "") {
                        let maxValue =  reports.map { $0.average }.max()
                            let divisor = (maxValue ?? 500) / 5.0
                            let barWidth = 300 / reports.count
                        ForEach(self.reports, id: \.year) { report in
                            BarView(report: report, divisor: divisor, barWidth: CGFloat(barWidth)) //need to keep a dynamic list of bars/reports
                        }
                            
                        }else{
                            Text("No data for this time period").font(.title)
                        }
                        
                    }
                    ToggleView(selected: $selection).onChange(of: selection, perform: { value in
                        reports = statsController.updateReports(value: value, reports: originalReports, statsController: statsController)
                    });
                    
                    
        }.onAppear(perform: initFunc
    
          
                
    )
        }
func initFunc(){
    if (selection != "") {
        print("filter for ", selection)
    reports = statsController.updateReports(value: selection, reports: originalReports, statsController: statsController)
    }
            }
}

struct BarView: View {
    
    let report: Report
    let divisor: Double
    let barWidth: CGFloat
    
    var body: some View {
        
        let value = report.average / divisor
        let yValue = Swift.min(value * 20, divisor)
        
        return VStack {
            
            Text(String(format: "%.2f kg Co2",report.average)).font(/*@START_MENU_TOKEN@*/.caption/*@END_MENU_TOKEN@*/)
            Rectangle()
                .fill(report.average < 2200 ? Color.green : Color.red)
                .frame(width: barWidth, height: CGFloat(yValue))
            
            Text(report.year)
            
        }
        
        
    }
    
}


//struct BarGraphView_Previews: PreviewProvider {
//    static var previews: some View {
//        BarGraphView(reports: Report.all())
//    }
//}

struct Report: Hashable{
    var year: String;
    let average: Double;
    var date: Date;
    let transport: Double
    let household: Double
    let clothing: Double
    let health: Double
    let food: Double
    let transport_walking: Double;
    let transport_car: Double;
    let transport_train: Double;
    let transport_bus: Double;
    let transport_plane: Double;
    let household_heating: Double;
    let household_electricity: Double;
    let household_furnishings: Double;
    let household_lighting: Double;
    let clothing_fastfashion: Double;
    let clothing_sustainable: Double;
    let health_meds: Double;
    let health_scans: Double;
    let food_meat: Double;
    let food_fish: Double;
    let food_dairy: Double;
    let food_oils: Double;
}

//extension Report {
//    static func all() -> [Report]{
//        return [
//
//            Report(year: "2001", average: 900.0, date: Date()),
//            Report(year: "2003", average: 500.0, date: Date()),
//            Report(year: "2005", average: 1000.0, date: Date()),
//        ]
//    }
//}
//from https://stackoverflow.com/questions/33397101/how-to-get-mondays-date-of-the-current-week-in-swift
extension Date {
    
    static func getWeekday(date: Date) -> String {
        let customDateFormatter = DateFormatter();
        return customDateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: date ) - 1]
    }
    
    static func getMonth(date: Date) -> String {
        let customDateFormatter = DateFormatter();
        return customDateFormatter.monthSymbols[Calendar.current.component(.month, from: date ) - 1]
    }
    
    static func getWeekOfMonth(date: Date) -> String{
        let numberOfWeeks = Calendar.current.component(.weekOfMonth, from: date)
        return String("Week " + String(numberOfWeeks))
    }
    
    static func today() -> Date {
        return Date()
    }
    
    static func yesterday() -> Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }
    
    var startOfYear: Date {
        let components = Calendar.current.dateComponents([.year], from: startOfDay)
        return Calendar.current.date(from: components)!
    }
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.next,
                   weekday,
                   considerToday: considerToday)
    }
    
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
   
    func getDayNameBy(stringDate: String) -> String
        {
        let df  = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: stringDate)!
            df.dateFormat = "EEEE"
        return df.string(from: date);
        }
    
    
}

// MARK: Helper methods
extension Date {
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
}

