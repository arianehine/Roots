//
//  StatsView.swift
//  PIG
//
//  Created by ariane hine on 17/05/2021.
//

import SwiftUI
import Charts


struct StatsView: View {
    let ID: String;
    @EnvironmentObject var statsController: StatsDataController
   @State var average: String = "not defined"
   @State var ltOrGt: String = "not defined"
   @State var people = [UserData]()
   @State var color = 0;
   @State var averageInKg: Double = 0;
   @State var reports: [Report] = [Report]();
   @State var originalReports: [Report] = [Report]();
   
    
    var body: some View {
 
       
        BarGraphView(reports: $reports, originalReports: $originalReports).onAppear{ people = statsController.convertCSVIntoArray();
        let user = self.findUserData();
            self.reports = self.convertToReports(users: user);
            self.originalReports = self.convertToReports(users: user);
            print(reports);};
        
        
     
        
//            Text("Hello, user \(ID), your average carbon usage is \(average) which is \(ltOrGt)the UK average")
//                .onAppear { self.convertCSVIntoArray()
//                    print(people.count)
//                    let user = findUserData()
//                    if user.count == 0{
//                        print("no user exists")
//                    }
//                      else{
//
//                        let averageDoubleInKg = user[0].average/1000;
//                        averageInKg = averageDoubleInKg;
//                        average = String(averageDoubleInKg);
//                        if(averageDoubleInKg>2.2){ltOrGt = "greater than " }else{
//                            ltOrGt = "less than "
//                        }
//
//                        }
//                }.foregroundColor(averageInKg > 2.2 ? .red : averageInKg < 2.2 ? .green : .gray)
//
//
//        }
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
            reportsToReturn.append(Report(year:  String(stringDate.split(separator: "-")[0] + stringDate.split(separator: "-")[1]), average: x.average, date: x.date))
        }
        return reportsToReturn;
        
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

    func findUserData() -> [UserData]{
        var user = [UserData]();
        let matches = people.filter { $0.ID == ID }
       
        for item in matches{
            user.append(item)
    }
        print(user.count)
        return user;

  
}

func textColour(gtOrLt: String) -> Color
{
    if(gtOrLt == "greater than" )
    {
        return Color.red;
    }
    else if( gtOrLt == "less than" )
    {
        return Color.green;
    }
    else
    {
        return Color.gray;
    }
}


}
func stringToDate(string: String) -> Date{
    let dateFormatter = DateFormatter()

    // Set Date Format
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

    // Convert String to Date
    return dateFormatter.date(from: string) ?? Date()
}


struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(ID: "1")
    }
}

