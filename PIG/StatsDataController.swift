//
//  StatsDataController.swift
//  PIG
//
//  Created by ariane hine on 21/05/2021.
//

import SwiftUI

class StatsDataController: ObservableObject {
  
func convertCSVIntoArray() -> [UserData]{
    var people = [UserData]()
    

       //locate the file you want to use
       guard let filepath = Bundle.main.path(forResource: "synthesisedData", ofType: "csv") else {
           print("not found")
           return [UserData]()
       }

       //convert that file into one long string
       var data = ""
       do {
           data = try String(contentsOfFile: filepath)
       } catch {
           print(error)
           print("no")
           return [UserData]()
       }

       //now split that string into an array of "rows" of data.  Each row is a string.
       var rows = data.components(separatedBy: "\n")

       //if you have a header row, remove it here
       rows.removeFirst()

       //now loop around each row, and split it into each of its columns
       for row in rows {
           let columns = row.components(separatedBy: ",")

           //check that we have enough columns
           if columns.count == 8 {
            let ID = String(columns[0])
            let date = stringToDate(string: columns[1])
            let average = Double(columns[2]) ?? 0
            let transport = Double(columns[3]) ?? 0
            let household = Double(columns[4]) ?? 0
            let clothing = Double(columns[5]) ?? 0
            let health = Double(columns[6]) ?? 0
            let food = Double(columns[7]) ?? 0
            
            let person = UserData(ID: ID, date: date, average: average, transport: transport, household: household, clothing: clothing, health: health, food: food)
               people.append(person)
           }
       }
    return people;
}
    func dateToString(date: Date) -> String{
        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        // Convert Date to String
        return dateFormatter.string(from: date)
    }

    func convertToReports(users: [UserData]) -> [Report]{
        var reportsToReturn = [Report]()
        for x in users{
            let stringDate = String(dateToString(date: x.date))
            reportsToReturn.append(Report(year:  String(stringDate.split(separator: "-")[0] + stringDate.split(separator: "-")[1]), average: x.average, date: x.date, transport: x.transport, household: x.household, clothing: x.clothing, health: x.health, food: x.health))
        }
        return reportsToReturn;
        
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

//    func createChart(){
//
//        //create bar chart
//
//        var entries = [BarChartDataEntry]()
//        for x in 0..<10{
//            entries.append(BarChartDataEntry(x: Double(x), y: Double.random(in: 0...30)))
//        }
//        let barChart = BarChartView();
//        //configure axes
//        //configure legend
//        //supply data to chart
//        let set = BarChartDataSet(entries: entries, label: "cost")
//        let data = BarChartData()
//
//    }

//ID, average, transport, household, clothing, health, food
//struct UserData {
//    var ID: String
//    var date: Date
//    var average: Double
//    var transport: Double
//    var household: Double
//    var clothing: Double
//    var health: Double
//    var food: Double
//}
    func updateReports(value: String, reports: [Report], statsController: StatsDataController) -> [Report]{
        
        let copyOfReports = reports;
        print("Reports going in", copyOfReports)

        switch value {
        case "Day":
            let reportsToReturn = statsController.getToday(reports: copyOfReports)
            print("Reports returned: ", reportsToReturn)
            return reportsToReturn;
            break;
        case "Week":
            let reportsToReturn = statsController.getThisWeek(reports: copyOfReports)
            print("Reports returned: ", reportsToReturn)
            return reportsToReturn;
            break;
        case "Month":
            let reportsToReturn = statsController.getThisMonth(reports: copyOfReports)
            print("Reports returned: ", reportsToReturn)
            return reportsToReturn;
            break;
        case "Year":
            let reportsToReturn = statsController.getThisYear(reports: copyOfReports)
            print("Reports returned: ", reportsToReturn)
            return reportsToReturn;
            break;
        default: break
        //yeek
        }
        
        return [Report]()
        
        
    }




    func findUserData(people: [UserData], ID: String) -> [UserData]{
        var user = [UserData]();
        let matches = people.filter { $0.ID == ID }
       
        for item in matches{
            user.append(item)
    }
        print(user.count)
        return user;

  
}
    func stringToDate(string: String) -> Date{
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        // Convert String to Date
        return dateFormatter.date(from: string) ?? Date()
    }

}
struct UserData {
    var ID: String
    var date: Date
    var average: Double
    var transport: Double
    var household: Double
    var clothing: Double
    var health: Double
    var food: Double
}

