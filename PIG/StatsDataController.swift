//
//  StatsDataController.swift
//  PIG
//
//  Created by ariane hine on 21/05/2021.
//

import SwiftUI
import FirebaseAuth
import Keys

class StatsDataController: ObservableObject {
    @Published var originalPeople =  [UserData]();
    @State var stateUser = [UserData]();
    @State var fbLogic: FirebaseLogic
    
//    init() {
//
//        self.originalPeople = convertCSVIntoArray()
//        self.stateUser = findUserData(people: originalPeople, ID: "6")
//        }
  
    public init(fbLogic: FirebaseLogic) {
        self.fbLogic = fbLogic
    }
    
    func retrieveUserData() -> [UserData]{

        let auth = Auth.auth();
        var toReturn = [UserData]()
        if(auth.currentUser != nil){
        

            fbLogic.userData = fbLogic.getUserData(uid: auth.currentUser!.uid)
            toReturn = fbLogic.userData
            
          

        }
        return toReturn;
        
        


    }
    
    func convertCSVIntoArray(csvHandler: CSVHandler, directory: URL) -> [UserData]{
print("converting")
        let encryptionKEY = PIGKeys().encryptionKEY
    if(originalPeople.count == 0){

    var people = [UserData]()
    

       //locate the file you want to use
        
                             

       //convert that file into one long string
       var data = ""
        var encryptedData = ""
       do {
           encryptedData =  try String(contentsOf: directory)
       } catch {
   
           return [UserData]()
       }
        data = csvHandler.decryptCSV(encryptedText: encryptedData, password: encryptionKEY)

       //now split that string into an array of "rows" of data.  Each row is a string.
       var rows = data.components(separatedBy: "\n")
        print(rows.count)

        

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
        print("wrong num columns at ID with rows \(row.count)")
       }
      
          
    }
        people.append(UserData(ID: "8", date: Date(), average: 2226.49, transport: 639.88, household: 551.62, clothing: 328.91, health: 308.91, food: 397.17, transport_walking: 159.97, transport_car: 63.99, transport_train: 121.58, transport_bus: 121.58, transport_plane: 70.39, household_heating: 126.87, household_electricity: 165.49, household_furnishings: 132.39, household_lighting: 126.87, clothing_fastfashion: 179.17, clothing_sustainable: 129.74, health_meds: 210.06, health_scans: 98.85, food_meat: 123.12, food_fish: 91.35, food_dairy: 99.29, food_oils: 83.41))
       
//        people.append(UserData(ID: "8", date: Date(), average: 0.01, transport: 0.01, household: 0, clothing:0, health: 0, food:0, transport_walking:0, transport_car: 0, transport_train: 0, transport_bus: 0, transport_plane: 0, household_heating: 0, household_electricity: 0, household_furnishings: 0, household_lighting: 0, clothing_fastfashion: 0, clothing_sustainable: 0, health_meds: 0, health_scans: 0, food_meat: 0, food_fish: 0, food_dairy: 0, food_oils: 0))
//
    originalPeople = orderByDate(array: people);
        print(people.count)
        return people
    }else {
  print("original \(originalPeople)")
     
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

            let stringDate = String(dateToString(date: x.date))
            reportsToReturn.append(Report(year:  String(stringDate.split(separator: "-")[0] + "-" + stringDate.split(separator: "-")[1]), average: x.average, date: x.date, transport: x.transport, household: x.household, clothing: x.clothing, health: x.health, food: x.health, transport_walking: x.transport_walking, transport_car: x.transport_car, transport_train: x.transport_train, transport_bus: x.transport_bus, transport_plane: x.transport_plane, household_heating: x.household_heating, household_electricity: x.household_electricity, household_furnishings: x.household_furnishings, household_lighting: x.household_lighting, clothing_fastfashion: x.clothing_fastfashion, clothing_sustainable: x.clothing_sustainable, health_meds: x.health_meds, health_scans: x.health_scans, food_meat: x.food_meat, food_fish: x.food_fish, food_dairy: x.food_dairy, food_oils: x.food_oils, numReportsComposingReport: 1))
        }
        
        return reportsToReturn;
        
    }
    
    func getToday(reports: [Report]) -> [Report]{
    
        var returnReports = [Report]();
        if(reports.count>=1){
        print("user reports \(reports[reports.count-1])")
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
        print((reports[reports.count-1]).date > now.startOfDay, (reports[reports.count-1]).date < now.endOfDay)
        }
        return returnReports;
        
    }
    func getThisMonth(reports: [Report]) -> [Report]{
        var returnReports = [Report]();
        var reportsCopy = reports;
        var now = Date();
        let startOfMonth = now.startOfMonth
        let tz = TimeZone.current
        var count = 0;
        if tz.isDaylightSavingTime(for: now) {
            now = now.addingTimeInterval(+3600)
            }
        
      
        reportsCopy = orderReportsByDate(array: reports)
        
        for report in reportsCopy{
            if report.date<now.endOfDay && report.date>startOfMonth.startOfDay{
                count += 1;
                let weekOfMonth = Date.getWeekOfMonth(date: report.date);
                let reportNew = Report(year: weekOfMonth, average: report.average, date: report.date, transport: report.transport, household: report.household, clothing: report.clothing, health: report.health, food: report.food, transport_walking: report.transport_walking, transport_car: report.transport_car, transport_train: report.transport_train, transport_bus: report.transport_bus, transport_plane: report.transport_plane, household_heating: report.household_heating,household_electricity: report.household_electricity, household_furnishings: report.household_furnishings, household_lighting: report.household_lighting, clothing_fastfashion: report.clothing_fastfashion, clothing_sustainable: report.clothing_sustainable, health_meds: report.health_meds, health_scans: report.health_scans, food_meat: report.food_meat, food_fish: report.food_fish, food_dairy: report.food_dairy, food_oils: report.food_oils, numReportsComposingReport: 1)
                returnReports.append(reportNew)
            }
        }
      
       
        return returnReports;
     
    }

  
    
    func getThisWeek(reports: [Report]) -> [Report]{
        var reportsCopy = orderReportsByDate(array: reports);
        var count = 0;
        let monday = Date.today().previous(.monday)
        var returnReports = [Report]();
        var now = Date();
        let tz = TimeZone.current
        if tz.isDaylightSavingTime(for: now) {
            now = now.addingTimeInterval(+3600)
            }
        
      
        
        for report in reportsCopy{
            if report.date<now.endOfDay && report.date>monday.startOfDay{
                count += 1;
                var stringWeekday = Date.getWeekday(date: report.date)
                stringWeekday = String(stringWeekday.prefix(3))
                let reportNew = Report(year: stringWeekday, average: report.average, date: report.date, transport: report.transport, household: report.household, clothing: report.clothing, health: report.health, food: report.food, transport_walking: report.transport_walking, transport_car: report.transport_car, transport_train: report.transport_train, transport_bus: report.transport_bus, transport_plane: report.transport_plane, household_heating: report.household_heating,household_electricity: report.household_electricity, household_furnishings: report.household_furnishings, household_lighting: report.household_lighting, clothing_fastfashion: report.clothing_fastfashion, clothing_sustainable: report.clothing_sustainable, health_meds: report.health_meds, health_scans: report.health_scans, food_meat: report.food_meat, food_fish: report.food_fish, food_dairy: report.food_dairy, food_oils: report.food_oils, numReportsComposingReport: 1)
                returnReports.append(reportNew)
            }
        }
       
        return returnReports;
        
    }
   
    func getThisYear(reports: [Report]) -> [Report]{
        print("getting year reports in \(reports.count)")
        var reportsCopy = orderReportsByDate(array: reports);
        var returnReports = [Report]();
        var count = 0;
        var now = Date();
        let startOfYear = now.startOfYear
        let tz = TimeZone.current
        if tz.isDaylightSavingTime(for: now) {
            
            now = now.addingTimeInterval(+3600)
            }
        
      
        
        for report in reportsCopy{
            if report.date<now.endOfDay && report.date>startOfYear.startOfDay{
                count += 1;
                var stringMonth = Date.getMonth(date: report.date)
     
        
                stringMonth = String(stringMonth.prefix(3))
                let reportNew = Report(year: stringMonth, average: report.average, date: report.date, transport: report.transport, household: report.household, clothing: report.clothing, health: report.health, food: report.food, transport_walking: report.transport_walking, transport_car: report.transport_car, transport_train: report.transport_train, transport_bus: report.transport_bus, transport_plane: report.transport_plane, household_heating: report.household_heating,household_electricity: report.household_electricity, household_furnishings: report.household_furnishings, household_lighting: report.household_lighting, clothing_fastfashion: report.clothing_fastfashion, clothing_sustainable: report.clothing_sustainable, health_meds: report.health_meds, health_scans: report.health_scans, food_meat: report.food_meat, food_fish: report.food_fish, food_dairy: report.food_dairy, food_oils: report.food_oils, numReportsComposingReport: 1)
                returnReports.append(reportNew)
                if(reportNew.year == "Jul"){
                    print("yes jul")
                }
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
     

        switch value {
        case "Day":
            var reportsToReturn = statsController.getToday(reports: copyOfReports)
           
            reportsToReturn = checkIfMerge(reports: reportsToReturn)
            //print("reports to return size \(reportsToReturn.count)")
            return reportsToReturn;
            break;
        case "Week":
            var reportsToReturn = statsController.getThisWeek(reports: copyOfReports)
            reportsToReturn = checkIfMerge(reports: reportsToReturn)
          
            return reportsToReturn;
            break;
        case "Month":
            var reportsToReturn = statsController.getThisMonth(reports: copyOfReports)
            reportsToReturn = checkIfMerge(reports: reportsToReturn)
         
            return reportsToReturn;
            break;
        case "Year":
            var reportsToReturn = statsController.getThisYear(reports: copyOfReports)
            print("reports to return size \(reportsToReturn.count)")
            reportsToReturn = checkIfMerge(reports: reportsToReturn)
            print("reports to return size \(reportsToReturn.count)")
            return reportsToReturn;
            break;
        default: break
        //yeek
        }
        
        return [Report]()
        
        
    }




    func findUserData(people: [UserData], ID: String) -> [UserData]{

        var user = [UserData]();
        if(stateUser.count == 0 ){
        let matches = people.filter { $0.ID == ID }
       
        for item in matches{
            user.append(item)
    }

        }else {
            user = stateUser;}
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
            
            mergedReports.append(Report(year: year, average: average, date: date, transport: transport, household: household, clothing: clothing, health: health, food: food, transport_walking: transport_walking, transport_car: transport_car, transport_train: transport_train, transport_bus: transport_bus,transport_plane: transport_plane,household_heating: household_heating, household_electricity: household_electricity,household_furnishings: household_furnishings,household_lighting: household_lighting,clothing_fastfashion: clothing_fastfashion, clothing_sustainable: clothing_sustainable,health_meds: health_meds, health_scans: health_scans, food_meat: food_meat, food_fish: food_fish, food_dairy: food_dairy, food_oils: food_oils, numReportsComposingReport: matches.count))
            
        }else{
            print("else report \(report.year)")
            mergedReports.append(report)
            print(report)
        }
        
        
    }
        mergedReports = mergedReports.uniqued();
    

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
struct UserData: Hashable{
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

