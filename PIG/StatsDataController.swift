//
//  StatsDataController.swift
//  PIG
//
//  Created by ariane hine on 21/05/2021.
//

import SwiftUI

class StatsDataController: ObservableObject {
    @State var originalPeople =  [UserData]();
  
func convertCSVIntoArray() -> [UserData]{
    if(originalPeople.count == 0){
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
           if columns.count == 25 {
            let ID = String(columns[0])
            let date = stringToDate(string: columns[1])
            let average = Double(columns[2]) ?? 0
            let transport = Double(columns[3]) ?? 0
            let household = Double(columns[4]) ?? 0
            let clothing = Double(columns[5]) ?? 0
            let health = Double(columns[6]) ?? 0
            let food = Double(columns[7]) ?? 0
            let transport_walking = Double(columns[8]) ?? 0
            let transport_car = Double(columns[9]) ?? 0
            let transport_train = Double(columns[10]) ?? 0
            let transport_bus = Double(columns[11]) ?? 0
            let transport_plane = Double(columns[12]) ?? 0
            let household_heating = Double(columns[13]) ?? 0
            let household_electricity = Double(columns[14]) ?? 0
            let household_furnishings = Double(columns[15]) ?? 0
            let household_lighting = Double(columns[16]) ?? 0
            let clothing_fastfashion = Double(columns[17]) ?? 0
            let clothing_sustainable = Double(columns[18]) ?? 0
            let health_meds = Double(columns[19]) ?? 0
            let health_scans = Double(columns[20]) ?? 0
            let food_meat = Double(columns[21]) ?? 0
            let food_fish = Double(columns[22]) ?? 0
            let food_dairy = Double(columns[23]) ?? 0
            let food_oils = Double(columns[24]) ?? 0
            
            let person = UserData(ID: ID, date: date, average: average, transport: transport, household: household, clothing: clothing, health: health, food: food, transport_walking: transport_walking, transport_car: transport_car, transport_train: transport_train, transport_bus: transport_bus, transport_plane: transport_plane, household_heating: household_heating, household_electricity: household_electricity, household_furnishings: household_furnishings, household_lighting: household_lighting, clothing_fastfashion: clothing_fastfashion, clothing_sustainable: clothing_sustainable, health_meds: health_meds, health_scans: health_scans, food_meat: food_meat, food_fish: food_fish, food_dairy: food_dairy, food_oils: food_oils)
               people.append(person)
           }
    else {
        print("wrong num columns at ID \(columns[0])")
       }
    }
    
    
    originalPeople = orderByDate(array: people);
        return people;
    }else {
        print("original people has", originalPeople.count)
        return originalPeople;
    }
}
    
    func orderByDate(array: [UserData]) -> [UserData]{
      
        var dateFormatter = DateFormatter()
        var convertedArray = [UserData]()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        for data in array {
            let date = dateFormatter.date(from: dateToString(date: data.date))
            if let date = date {
                convertedArray.append(data)
            }
        }

        let ready = convertedArray.sorted(by: { $0.date.compare($1.date) == .orderedAscending })

        return ready;
    }
    
    func orderReportsByDate(array: [Report]) -> [Report]{
      
        var dateFormatter = DateFormatter()
        var convertedArray = [Report]()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        for data in array {
            let date = dateFormatter.date(from: dateToString(date: data.date))
            if let date = date {
                convertedArray.append(data)
            }
        }

        let ready = convertedArray.sorted(by: { $0.date.compare($1.date) == .orderedAscending })

        return ready;
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
            print("converting")
            let stringDate = String(dateToString(date: x.date))
            reportsToReturn.append(Report(year:  String(stringDate.split(separator: "-")[0] + "-" + stringDate.split(separator: "-")[1]), average: x.average, date: x.date, transport: x.transport, household: x.household, clothing: x.clothing, health: x.health, food: x.health, transport_walking: x.transport_walking, transport_car: x.transport_car, transport_train: x.transport_train, transport_bus: x.transport_bus, transport_plane: x.transport_plane, household_heating: x.household_heating, household_electricity: x.household_electricity, household_furnishings: x.household_furnishings, household_lighting: x.household_lighting, clothing_fastfashion: x.clothing_fastfashion, clothing_sustainable: x.clothing_sustainable, health_meds: x.health_meds, health_scans: x.health_scans, food_meat: x.food_meat, food_fish: x.food_fish, food_dairy: x.food_dairy, food_oils: x.food_oils))
        }
        print("NUMBER OF REPORTS:", reportsToReturn.count)
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
                let weekOfMonth = Date.getWeekOfMonth(date: report.date);
                let reportNew = Report(year: weekOfMonth, average: report.average, date: report.date, transport: report.transport, household: report.household, clothing: report.clothing, health: report.health, food: report.food, transport_walking: report.transport_walking, transport_car: report.transport_car, transport_train: report.transport_train, transport_bus: report.transport_bus, transport_plane: report.transport_plane, household_heating: report.household_heating,household_electricity: report.household_electricity, household_furnishings: report.household_furnishings, household_lighting: report.household_lighting, clothing_fastfashion: report.clothing_fastfashion, clothing_sustainable: report.clothing_sustainable, health_meds: report.health_meds, health_scans: report.health_scans, food_meat: report.food_meat, food_fish: report.food_fish, food_dairy: report.food_dairy, food_oils: report.food_oils)
                returnReports.append(reportNew)
            }
        }
       
        return returnReports;
     
    }

    func getThisWeek(reports: [Report]) -> [Report]{
        var reportsCopy = orderReportsByDate(array: reports);
       
        let monday = Date.today().previous(.monday)
        var returnReports = [Report]();
        var now = Date();
        let tz = TimeZone.current
        if tz.isDaylightSavingTime(for: now) {
            now = now.addingTimeInterval(+3600)
            }
        
      
        
        for report in reportsCopy{
            if report.date<now.endOfDay && report.date>monday.startOfDay{
                var stringWeekday = Date.getWeekday(date: report.date)
                stringWeekday = String(stringWeekday.prefix(3))
                let reportNew = Report(year: stringWeekday, average: report.average, date: report.date, transport: report.transport, household: report.household, clothing: report.clothing, health: report.health, food: report.food, transport_walking: report.transport_walking, transport_car: report.transport_car, transport_train: report.transport_train, transport_bus: report.transport_bus, transport_plane: report.transport_plane, household_heating: report.household_heating,household_electricity: report.household_electricity, household_furnishings: report.household_furnishings, household_lighting: report.household_lighting, clothing_fastfashion: report.clothing_fastfashion, clothing_sustainable: report.clothing_sustainable, health_meds: report.health_meds, health_scans: report.health_scans, food_meat: report.food_meat, food_fish: report.food_fish, food_dairy: report.food_dairy, food_oils: report.food_oils)
                returnReports.append(reportNew)
            }
        }
       
        return returnReports;
        
    }
   
    func getThisYear(reports: [Report]) -> [Report]{
        var reportsCopy = orderReportsByDate(array: reports);
        var returnReports = [Report]();
        var now = Date();
        let startOfYear = now.startOfYear
        let tz = TimeZone.current
        if tz.isDaylightSavingTime(for: now) {
            
            now = now.addingTimeInterval(+3600)
            }
        
      
        
        for report in reportsCopy{
            if report.date<now.endOfDay && report.date>startOfYear.startOfDay{
                
                var stringMonth = Date.getMonth(date: report.date)
                print("string month ", stringMonth)
                stringMonth = String(stringMonth.prefix(3))
                let reportNew = Report(year: stringMonth, average: report.average, date: report.date, transport: report.transport, household: report.household, clothing: report.clothing, health: report.health, food: report.food, transport_walking: report.transport_walking, transport_car: report.transport_car, transport_train: report.transport_train, transport_bus: report.transport_bus, transport_plane: report.transport_plane, household_heating: report.household_heating,household_electricity: report.household_electricity, household_furnishings: report.household_furnishings, household_lighting: report.household_lighting, clothing_fastfashion: report.clothing_fastfashion, clothing_sustainable: report.clothing_sustainable, health_meds: report.health_meds, health_scans: report.health_scans, food_meat: report.food_meat, food_fish: report.food_fish, food_dairy: report.food_dairy, food_oils: report.food_oils)
                returnReports.append(reportNew)
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
            var reportsToReturn = statsController.getToday(reports: copyOfReports)
            reportsToReturn = checkIfMerge(reports: reportsToReturn)
            print("Reports returned: ", reportsToReturn)
            return reportsToReturn;
            break;
        case "Week":
            var reportsToReturn = statsController.getThisWeek(reports: copyOfReports)
            reportsToReturn = checkIfMerge(reports: reportsToReturn)
            print("Reports returned: ", reportsToReturn)
            return reportsToReturn;
            break;
        case "Month":
            var reportsToReturn = statsController.getThisMonth(reports: copyOfReports)
            reportsToReturn = checkIfMerge(reports: reportsToReturn)
            print("Reports returned: ", reportsToReturn)
            return reportsToReturn;
            break;
        case "Year":
            var reportsToReturn = statsController.getThisYear(reports: copyOfReports)
            reportsToReturn = checkIfMerge(reports: reportsToReturn)
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

func checkIfMerge(reports: [Report]) -> [Report]{
    var reportsEdit = reports;
    var mergedReports = [Report]()
    for report in reports{
        let matches = reports.filter { $0.year == report.year }
        if(matches.count>1){
        
            var year = ""
            var average = 0.0
            var date = Date()
            var transport = 0.0
            var household = 0.0
            var clothing = 0.0
            var health = 0.0
            var food = 0.0
            var transport_walking = 0.0
            var transport_car = 0.0
            var transport_train = 0.0
            var transport_bus = 0.0
            var transport_plane = 0.0
            var household_heating = 0.0
            var household_electricity = 0.0
            var household_furnishings = 0.0
            var household_lighting = 0.0
            var clothing_fastfashion = 0.0
            var clothing_sustainable = 0.0
            var health_meds = 0.0
            var health_scans = 0.0
            var food_meat = 0.0
            var food_fish = 0.0
            var food_dairy = 0.0
            var food_oils = 0.0

            
            for (index,item) in matches.enumerated(){
                
                year = item.year
                average = average + item.average
                date = item.date
                transport = transport + item.transport
                household = household + item.household
                clothing = clothing + item.clothing
                health = health + item.health
                food = food + item.food
                transport_walking = transport_walking + item.transport_walking
                transport_car = transport_car + item.transport_car
                transport_train = transport_train + item.transport_train
                transport_bus = transport_bus + item.transport_bus
                transport_plane = transport_plane + item.transport_plane
                household_heating = household_heating + item.household_heating
                household_electricity = household_electricity + item.household_electricity
                household_furnishings = household_furnishings + item.household_furnishings
                household_lighting = household_lighting + item.household_lighting
                clothing_fastfashion = clothing_fastfashion + item.clothing_fastfashion
                clothing_sustainable = clothing_sustainable + item.clothing_sustainable
                health_meds = health_meds + item.health_meds
                health_scans = health_scans + item.health_scans
                food_meat = food_meat + item.food_meat
                food_fish = food_fish + item.food_fish
                food_dairy = food_dairy + item.food_dairy
                food_oils = food_oils + item.food_oils
                
                //remove it because it's counting it twice
                
            }
            
            //average it out
//            average = average / Double(matches.count)
//            transport = transport / Double(matches.count)
//            household = household / Double(matches.count)
//            clothing = clothing / Double(matches.count)
//            health = health / Double(matches.count)
//            food = food / Double(matches.count)
//            transport_walking = transport_walking / Double(matches.count)
//            transport_car = transport_car / Double(matches.count)
//            transport_train = transport_train / Double(matches.count)
//            transport_bus = transport_bus / Double(matches.count)
//            transport_plane = transport_plane / Double(matches.count)
//            household_heating = household_heating / Double(matches.count)
//            household_electricity = household_electricity / Double(matches.count)
//            household_furnishings = household_furnishings / Double(matches.count)
//            household_lighting = household_lighting / Double(matches.count)
//            clothing_fastfashion = clothing_fastfashion  / Double(matches.count)
//            clothing_sustainable = clothing_sustainable / Double(matches.count)
//            health_meds = health_meds / Double(matches.count)
//            health_scans = health_scans  / Double(matches.count)
//            food_meat = food_meat  / Double(matches.count)
//            food_fish = food_fish / Double(matches.count)
//            food_dairy = food_dairy / Double(matches.count)
//            food_oils = food_oils / Double(matches.count)
            
            mergedReports.append(Report(year: year, average: average, date: date, transport: transport, household: household, clothing: clothing, health: health, food: food, transport_walking: transport_walking, transport_car: transport_car, transport_train: transport_train, transport_bus: transport_bus,transport_plane: transport_plane,household_heating: household_heating, household_electricity: household_electricity,household_furnishings: household_furnishings,household_lighting: household_lighting,clothing_fastfashion: clothing_fastfashion, clothing_sustainable: clothing_sustainable,health_meds: health_meds, health_scans: health_scans, food_meat: food_meat, food_fish: food_fish, food_dairy: food_dairy, food_oils: food_oils))
            
        }
        
        mergedReports = mergedReports.uniqued();
    
    }
    
    return mergedReports;
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}


func removeArrayFromArray(allReports:[Report], reportsToRemove:[Report]) -> [Report]{
    
    var reportsEdit = allReports;
    for item in reportsToRemove {
        if let ix = reportsEdit.index(of: item) {
            reportsEdit.remove(at: ix)
        }
    }
    return reportsEdit
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

