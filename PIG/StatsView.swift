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
   @State var originalPeople : [UserData]
    @Binding var fbLogic: FirebaseLogic
    @State var selection: String
    
    var body: some View {
 
       
        BarGraphView(selection: $selection, reports: $reports, originalReports: $originalReports).environmentObject(statsController).onAppear{
            
            if (statsController.originalPeople.count == 0) {
                people = originalPeople;
            } else{
            people = originalPeople;
            }
        let user = statsController.findUserData(people: people, ID: ID);
            
           // self.reports = statsController.convertToReports(users: user);
            self.originalReports = statsController.convertToReports(users: user);
        }.onChange(of: statsController.originalPeople){ value in
      
            self.originalPeople = statsController.originalPeople
            
        }
    
     
        
        
     
        
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


//struct StatsView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatsView(ID: "1")
//    }
//}

