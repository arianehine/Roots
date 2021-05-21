//
//  BarGraphView.swift
//  PIG
//
//  Created by ariane hine on 18/05/2021.
//

import SwiftUI

import SwiftUI

struct BarGraphView: View {
    @State var selection = "";
    @Binding var reports: [Report]
    @Binding var originalReports: [Report]
    var body: some View {
        
        VStack {
            
            HStack(alignment: .lastTextBaseline) {
                
                ForEach(self.reports, id: \.year) { report in
                    BarView(report: report) //need to keep a dynamic list of bars/reports
                }
                
            }
//            ToggleView(selected: $selection).onChange(of: selection, perform: { value in
//                reports = updateReports(value: value, reports: originalReports)
//            });
            
            
        }
        
    }
}

func updateReports(value: String, reports: [Report]) -> [Report]{
    
    let copyOfReports = reports;
    print("Reports going in", copyOfReports)

    switch value {
    case "Day":
        let reportsToReturn = getToday(reports: copyOfReports)
        print("Reports returned: ", reportsToReturn)
        return reportsToReturn;
        break;
    case "Week":
        let reportsToReturn = getThisWeek(reports: copyOfReports)
        print("Reports returned: ", reportsToReturn)
        return reportsToReturn;
        break;
    case "Month":
        let reportsToReturn = getThisMonth(reports: copyOfReports)
        print("Reports returned: ", reportsToReturn)
        return reportsToReturn;
        break;
    case "Year":
        let reportsToReturn = getThisYear(reports: copyOfReports)
        print("Reports returned: ", reportsToReturn)
        return reportsToReturn;
        break;
    default: break
    //yeek
    }
    
    return [Report]()
    
    
}



func getToday(reports: [Report]) -> [Report]{
    
    var returnReports = [Report]();
    var now = Date();
    let tz = TimeZone.current
    if tz.isDaylightSavingTime(for: now) {
        now = now.addingTimeInterval(+3600)
        }
    

    
    for report in reports{
        if report.date<now.endOfDay && report.date>now.startOfDay{
            returnReports.append(report)
        }
    }
   
    return returnReports;
    
}
func getThisMonth(reports: [Report]) -> [Report]{
    var returnReports = [Report]();
    var now = Date();
    let startOfMonth = now.startOfMonth
    let tz = TimeZone.current
    if tz.isDaylightSavingTime(for: now) {
        now = now.addingTimeInterval(+3600)
        }
    
  
    
    for report in reports{
        if report.date<now.endOfDay && report.date>startOfMonth.startOfDay{
            returnReports.append(report)
        }
    }
   
    return returnReports;
 
}

func getThisWeek(reports: [Report]) -> [Report]{
   
    let monday = Date.today().previous(.monday)
    var returnReports = [Report]();
    var now = Date();
    let tz = TimeZone.current
    if tz.isDaylightSavingTime(for: now) {
        now = now.addingTimeInterval(+3600)
        }
    
  
    
    for report in reports{
        if report.date<now.endOfDay && report.date>monday.startOfDay{
            returnReports.append(report)
        }
    }
   
    return returnReports;
    
}
func getThisYear(reports: [Report]) -> [Report]{
    var returnReports = [Report]();
    var now = Date();
    let startOfYear = now.startOfYear
    let tz = TimeZone.current
    if tz.isDaylightSavingTime(for: now) {
        now = now.addingTimeInterval(+3600)
        }
    
  
    
    for report in reports{
        if report.date<now.endOfDay && report.date>startOfYear.startOfDay{
            returnReports.append(report)
        }
    }
   
    return returnReports;
    
}
struct BarView: View {
    
    let report: Report
    
    var body: some View {
        
        let value = report.average / 300
        let yValue = Swift.min(value * 20, 300)
        
        return VStack {
            
            Text(String(format: "$%.2f",report.average))
            Rectangle()
                .fill(report.average < 2200 ? Color.green : Color.red)
                .frame(width: 100, height: CGFloat(yValue))
            
            Text(report.year)
            
        }
        
        
    }
    
}


//struct BarGraphView_Previews: PreviewProvider {
//    static var previews: some View {
//        BarGraphView(reports: Report.all())
//    }
//}

struct Report{
    let year: String;
    let average: Double;
    let date: Date;
}

extension Report {
    static func all() -> [Report]{
        return [
            
            Report(year: "2001", average: 900.0, date: Date()),
            Report(year: "2003", average: 500.0, date: Date()),
            Report(year: "2005", average: 1000.0, date: Date()),
        ]
    }
}
//from https://stackoverflow.com/questions/33397101/how-to-get-mondays-date-of-the-current-week-in-swift
extension Date {

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

