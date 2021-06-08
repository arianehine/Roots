//
//  PledgesInProgress.swift
//  PIG
//
//  Created by ariane hine on 07/06/2021.
//
import WrappingHStack
import SwiftUI
import ToastSwiftUI

struct PledgesInProgress: View {
    @State var pledgesCompleted = [Pledge]()
    @State var showFurtherInfo :Bool = false
    @State var pledgesInProgress = [Pledge]()
    @State var selectedForFurtherInfo: Pledge = getPledgesCompleted()[1]
    var pledgePicked: Pledge
    var body: some View {
        VStack{
            let pledgesCompleted = getPledgesCompleted()
            let pledgesInProgress = getPledgesInProgress()
            
        Text("Pledges in progress...")
            WrappingHStack(0..<pledgesInProgress.count, id:\.self, alignment: .center) { index in
                
                VStack{


                        Button(action: {
                            
                            showFurtherInfo = true
                            selectedForFurtherInfo = pledgesInProgress[index]

                              }) {
                            Image(systemName: pledgesInProgress[index].imageName).renderingMode(.original)
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                               
                              }
                       

                    let calendar = Calendar.current
                    let endDate = Calendar.current.date(byAdding: .day, value: pledgesInProgress[index].durationInDays, to: pledgesInProgress[index].startDate)!
    
                    let date1 = calendar.date(bySettingHour: 12, minute: 00, second: 00, of: calendar.startOfDay(for: pledgesInProgress[index].startDate))
                    let date2 = calendar.date(bySettingHour: 12, minute: 00, second: 00, of: calendar.startOfDay(for: endDate))

                    let components = calendar.dateComponents([.day], from: date1!, to: date2!)
                    var numDays : Int = components.day!
                    Text("Days remaining: \(numDays)").font(.caption)
                }.frame(width: 150, height: 100, alignment: .center);
                       
                      
            }
               
            Divider()
            Text("Pledges complete")
            WrappingHStack(0..<pledgesCompleted.count, id:\.self, alignment: .center) { index in

                ZStack{

                    Button(action: {
                        
                        showFurtherInfo = true
                        selectedForFurtherInfo = pledgesCompleted[index]

                          }) {
                        Image(systemName: pledgesCompleted[index].imageName).renderingMode(.original)
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                           
                          }
                   
                }
                                    }
                                
                                
                                
      
                 

        
            Spacer()
        }.toast(isPresenting: $showFurtherInfo, message: selectedForFurtherInfo.description)
 
    }
}


func print(date1: Date, date2: Date, days: Int) ->String{
    print(date1)
    print(date2)
    print(days)
    return "hi"
}

func getPledgesInProgress()-> [Pledge]{
    return [
        Pledge(description: "Put your heating on a set timer!", category: "Household", imageName: "flame.fill",durationInDays: 7),
        Pledge( description: "Turn lights off when you leave the room", category: "Household", imageName: "bolt.fill",durationInDays: 7),
        Pledge(description: "Don't buy any furniature for 4 month", category: "Household", imageName: "house.fill",durationInDays: 7),
        Pledge(description: "Turn lights off when you leave the room!", category: "Household", imageName: "lightbulb.fill",durationInDays: 7)]
    
}

func getPledgesCompleted() -> [Pledge]{
    return [
        Pledge(description: "Walk to work 2 days a week", category: "Transport", imageName: "figure.walk", durationInDays: 7),
        Pledge(description: "Drive only 3 days this week", category: "Transport", imageName: "car.fill", durationInDays: 7),
        Pledge(description: "Swap the car for the train", category: "Transport", imageName: "tram.fill",durationInDays: 7),
        Pledge(description: "Take 0 taxis this week", category: "Transport", imageName: "figure.wave",durationInDays: 7)]
}
//struct PledgesInProgress_Previews: PreviewProvider {
//    static var previews: some View {
//        PledgesInProgress()
//    }
//}
public func daysBetween(start: Date, end: Date) -> Int {
   Calendar.current.dateComponents([.day], from: start, to: end).day!
}
