//
//  StatsView.swift
//  PIG
//
//  Created by ariane hine on 17/05/2021.
//

import SwiftUI
import Charts

struct StatsView: View {
    let ID: String
   @State var average: String = "not defined"
   @State var ltOrGt: String = "not defined"
   @State var people = [UserData]()
   @State var color = 0;
   @State var averageInKg: Double = 0;
   @State var reports: [Report] = [Report]();
    
    var body: some View {
 
       
        BarGraphView(reports: reports).onAppear{ self.convertCSVIntoArray();
        let user = self.findUserData();
            self.reports = self.convertToReports(users: user);
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

    func convertToReports(users: [UserData]) -> [Report]{
        var reports = [Report]()
        for x in users{
            reports.append(Report(year:  String(x.date.split(separator: "-")[0]), average: x.average))
        }
        return reports;
        
    }

    func createChart(){
        
        //create bar chart
        
        var entries = [BarChartDataEntry]()
        for x in 0..<10{
            entries.append(BarChartDataEntry(x: Double(x), y: Double.random(in: 0...30)))
        }
        let barChart = BarChartView();
        //configure axes
        //configure legend
        //supply data to chart
        let set = BarChartDataSet(entries: entries, label: "cost")
        let data = BarChartData()
    
    }

//ID, average, transport, household, clothing, health, food
struct UserData {
    var ID: String
    var date:String
    var average: Double
    var transport: Double
    var household: Double
    var clothing: Double
    var health: Double
    var food: Double
}

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


func convertCSVIntoArray() {

       //locate the file you want to use
       guard let filepath = Bundle.main.path(forResource: "synthesisedData", ofType: "csv") else {
           print("not found")
           return
       }

       //convert that file into one long string
       var data = ""
       do {
           data = try String(contentsOfFile: filepath)
       } catch {
           print(error)
           print("no")
           return
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
            let date = String(columns[1])
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
}

}


struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(ID: "1")
    }
}

