//
//  PledgesInProgress.swift
//  PIG
//
//  Created by ariane hine on 07/06/2021.
//
import WrappingHStack
import SwiftUI
import ToastSwiftUI
import FirebaseFirestore

struct PledgesInProgress: View {
    @State var pledgesCompleted = [Pledge]()
    @State var showFurtherInfo :Bool = false
    @EnvironmentObject var fbLogic: FirebaseLogic
    @State var selectedForFurtherInfo: Pledge = getPledgesCompleted()[1]
    var pledgePicked: Pledge?
    var body: some View {
        VStack{
       
            if(fbLogic.pledgesInProgress.count>0){
            Text("\(fbLogic.pledgesInProgress.count)")
            }
        Text("Pledges in progress...")
            WrappingHStack(0..<fbLogic.pledgesInProgress.count, id:\.self, alignment: .center) { index in
                
                VStack{
               


                        Button(action: {
                            
                            showFurtherInfo = true
                            selectedForFurtherInfo = fbLogic.pledgesInProgress[index]

                              }) {
                            Image(systemName: fbLogic.pledgesInProgress[index].imageName).renderingMode(.original)
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                               
                              }
                       

                    let calendar = Calendar.current
                    let endDate = Calendar.current.date(byAdding: .day, value:  fbLogic.pledgesInProgress[index].durationInDays, to: fbLogic.pledgesInProgress[index].startDate)!
    
                    let date1 = calendar.date(bySettingHour: 12, minute: 00, second: 00, of: calendar.startOfDay(for:  fbLogic.pledgesInProgress[index].startDate))
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
        }.toast(isPresenting: $showFurtherInfo, message: selectedForFurtherInfo.description).onAppear(perform: initVars)
 
    }
    
    func initVars(){      
        pledgesCompleted = getPledgesCompleted()
        fbLogic.pledgesInProgress = fbLogic.getPledgesInProgress(pledgePicked: pledgePicked ?? emptyPledge)
    }
}


func print(date1: Date, date2: Date, days: Int) ->String{
    print(date1)
    print(date2)
    print(days)
    return "hi"
}
class FirebaseLogic: ObservableObject {
@Published var pledgesInProgress = [Pledge]()
func getPledgesInProgress(pledgePicked: Pledge)-> [Pledge]{
    let db = Firestore.firestore()

     if(pledgePicked.description != "nil"){
        let id = pledgePicked.id
        db.collection("Pledges").document(String(id)).updateData(["started":true])
        
        
//     pledgesToReturn.append(pledgePicked)
     }
    
   db
      .collection("Pledges")
    .getDocuments { [self] (snapshot, error) in
         guard let snapshot = snapshot, error == nil else {
          //handle error
          return
        }
        print("Number of documents: \(snapshot.documents.count ?? -1)")
        snapshot.documents.forEach({ (documentSnapshot) in
            
            
          let documentData = documentSnapshot.data()
            let started = documentData["started"] as? Bool
            print(started)
            if (started == true){
                print("append", self.findPledgeWithThisID(ID: documentData["ID"] as! Int))
                pledgesInProgress.append(self.findPledgeWithThisID(ID: documentData["ID"] as! Int))
            }

        })
      }
    return pledgesInProgress;

}



func findPledgeWithThisID(ID: Int) -> Pledge{
    for pledge in pledges{
        if pledge.id == ID{
            return pledge;
        }
    }
    return emptyPledge;
}
}
func getPledgesCompleted() -> [Pledge]{
    return [
        Pledge(id: 1, description: "Walk to work 2 days a week", category: "Transport", imageName: "figure.walk", durationInDays: 7),
        Pledge(id: 2, description: "Drive only 3 days this week", category: "Transport", imageName: "car.fill", durationInDays: 7),
        Pledge(id: 3, description: "Swap the car for the train", category: "Transport", imageName: "tram.fill",durationInDays: 7),
        Pledge(id: 4, description: "Take 0 taxis this week", category: "Transport", imageName: "figure.wave",durationInDays: 7)]
    
//    let db = Firestore.firestore()
//    var pledgesToReturn = [Pledge]()
//
//   db
//      .collection("Pledges")
//      .getDocuments { (snapshot, error) in
//         guard let snapshot = snapshot, error == nil else {
//          //handle error
//          return
//        }
//        print("Number of documents: \(snapshot.documents.count ?? -1)")
//        snapshot.documents.forEach({ (documentSnapshot) in
//          let documentData = documentSnapshot.data()
//            let endDate = documentData["endDate"] as? String
//            if (endDate != ""){
//                pledgesToReturn.append(findPledgeWithThisID(ID: documentData["ID"] as! Int))
//            }
//        })
//      }
//     return pledgesToReturn;
//

}

//struct PledgesInProgress_Previews: PreviewProvider {
//    static var previews: some View {
//        PledgesInProgress()
//    }
//}
public func daysBetween(start: Date, end: Date) -> Int {
   Calendar.current.dateComponents([.day], from: start, to: end).day!
}

let emptyPledge = Pledge(id: 1, description: "nil", category: "nil", imageName: "nil", durationInDays: 0)
