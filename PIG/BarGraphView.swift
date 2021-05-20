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
    var reports: [Report]
    var body: some View {
        
        VStack {
            
            HStack(alignment: .lastTextBaseline) {
                
                ForEach(self.reports, id: \.year) { report in
                    BarView(report: report)
                }
                
            }
            ToggleView(selected: $selection).onChange(of: selection, perform: { value in
                updateReports(value: value, reports: reports)
            });
            
            
        }
        
    }
}

func updateReports(value: String, reports: [Report]) -> [Report]{
    
    var reportsToReturn: [Report];
    switch value {
    case "Day":
        reportsToReturn = getToday(reports: reports)
        break;
    case "Week":
        reportsToReturn = getThisWeek(reports: reports)
        break;
    case "Month":
        reportsToReturn = getThisMonth(reports: reports)
        break;
    case "Year":
        reportsToReturn = getThisYear(reports: reports)
        break;
    default: break
    //yeek
    }
    
    return [Report]()
    
    
}

func getToday(reports: [Report]) -> [Report]{
    let now = Date();
    
    print(now)
   
    return [Report]();
    
}
func getThisWeek(reports: [Report]) -> [Report]{
    let now = Date()
    let monday = Date.today().previous(.monday)
    let range = monday...now
 
    return [Report]();
}

func getThisMonth(reports: [Report]) -> [Report]{
    return [Report]();
    
}
func getThisYear(reports: [Report]) -> [Report]{
    return [Report]();
    
}
struct BarView: View {
    
    let report: Report
    
    var body: some View {
        
        let value = report.average / 500
        let yValue = Swift.min(value * 20, 500)
        
        return VStack {
            
            Text(String(format: "$%.2f",report.average))
            Rectangle()
                .fill(report.average < 2200 ? Color.green : Color.red)
                .frame(width: 100, height: CGFloat(yValue))
            
            Text(report.year)
            
        }
        
        
    }
    
}


struct BarGraphView_Previews: PreviewProvider {
    static var previews: some View {
        BarGraphView(reports: Report.all())
    }
}

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

