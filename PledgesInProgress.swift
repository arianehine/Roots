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
import FirebaseAuth

struct PledgesInProgress: View {
    @State var showFurtherInfo :Bool = false
    @EnvironmentObject var fbLogic: FirebaseLogic
    @State var selectedForFurtherInfo: Pledge = emptyPledge;
    var pledgePicked: Pledge?
    var body: some View {
        VStack{
       
        Text("Pledges in progress...")
            WrappingHStack(0..<fbLogic.pledgesInProgress.count, id:\.self, alignment: .center) { index in
                
                VStack{
                  


                        Button(action: {
                            print(fbLogic.pledgesInProgress[index].startDate);
                            showFurtherInfo = true
                            selectedForFurtherInfo = fbLogic.pledgesInProgress[index]

                              }) {
                            Image(systemName: fbLogic.pledgesInProgress[index].imageName).renderingMode(.original)
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                               
                              }
                       
                    

                    let calendar = Calendar.current
                    let endDate = Calendar.current.date(byAdding: .day, value:  fbLogic.pledgesInProgress[index].durationInDays, to: fbLogic.pledgesInProgress[index].startDate)!
                  
    
                    let date1 = calendar.date(bySettingHour: 12, minute: 00, second: 00, of: calendar.startOfDay(for:  Date()))
                    let date2 = calendar.date(bySettingHour: 12, minute: 00, second: 00, of: calendar.startOfDay(for: endDate))

                    let components = calendar.dateComponents([.day], from: date1!, to: date2!)
                    var numDays : Int = components.day!
                    Text("Days remaining: \(numDays)").font(.caption)

                }.frame(width: 150, height: 100, alignment: .center);
                       
        
                      
            }
               
            Divider()
            Text("Pledges complete")
            WrappingHStack(0..<fbLogic.pledgesCompleted.count, id:\.self, alignment: .center) { index in

                ZStack{

                    Button(action: {
                        
                        showFurtherInfo = true
                        selectedForFurtherInfo = fbLogic.pledgesCompleted[index]

                          }) {
                        Image(systemName: fbLogic.pledgesCompleted[index].imageName).renderingMode(.original)
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                           
                          }
                   
                }
                                    }
                            
                                
      
                 

        
            Spacer()
        }.toast(isPresenting: $showFurtherInfo, message: selectedForFurtherInfo.description).onAppear(perform: initVars)
 
    }
    
    func initVars(){
        fbLogic.allPledges = fbLogic.getAllPledges();
        fbLogic.pledgesCompleted = fbLogic.getPledgesCompleted()
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
@Published var pledgesCompleted = [Pledge]()
@Published var pledgesForArea = [Pledge]()
@Published var allPledges = [Pledge]()
let auth = Auth.auth();

func getPledgesInProgress(pledgePicked: Pledge)-> [Pledge]{
    let db = Firestore.firestore()
    pledgesInProgress = [Pledge]()

    let currentUser = (auth.currentUser?.uid)!
     if(pledgePicked.description != "nil"){
        let id = pledgePicked.id
        let userPledges = db.collection("UserPledges").document(currentUser).collection("Pledges").document(String(id)).updateData(["started":true])
        
        
//     pledgesToReturn.append(pledgePicked)
     }
    
    db.collection("UserPledges").document(currentUser).collection("Pledges")
    .getDocuments { [self] (snapshot, error) in
         guard let snapshot = snapshot, error == nil else {
          //handle error
          return
        }
        print("Number of documents: \(snapshot.documents.count ?? -1)")
        snapshot.documents.forEach({ (documentSnapshot) in
            
            
          let documentData = documentSnapshot.data()
            let started = documentData["started"] as? Bool
            let endDate = documentData["endDate"] as? String
            print(started)
            if (started == true && endDate==""){
                print("append", self.findPledgeWithThisID(ID: documentData["ID"] as! Int))
                pledgesInProgress.append(self.findPledgeWithThisID(ID: documentData["ID"] as! Int))
            }

        })
      }
    return pledgesInProgress;

}
    

        

    func getAllPledges() -> [Pledge]{
        
        let db = Firestore.firestore()
        let currentUser = (auth.currentUser?.uid)!
        self.allPledges = [Pledge]()
        var pledgesToReturn = [Pledge]()
    
        db.collection("UserPledges").document(currentUser).collection("Pledges")
          .getDocuments { (snapshot, error) in
             guard let snapshot = snapshot, error == nil else {
              //handle error
              return
            }
            print("Number of documents: \(snapshot.documents.count ?? -1)")
            snapshot.documents.forEach({ (documentSnapshot) in
                let documentData = documentSnapshot.data()
                let ID = documentData["ID"]! as? Int
                let description = documentData["description"] as? String
                let category = documentData["category"] as? String
                let imageName = documentData["imageName"] as? String
                let durationInDays = documentData["durationInDays"] as? Int
                let started = documentData["started"] as? Bool
                let startDateInterval = documentData["startDate"] as? Timestamp
                let endDate = documentData["endDate"] as? String
                let startDate = Date(timeIntervalSince1970: TimeInterval(startDateInterval!.seconds))

                let object = Pledge(id: ID!, description: description!, category: category!, imageName: imageName!, durationInDays: durationInDays!, startDate: startDate, started: started!, endDate: endDate ?? "")
            
                    self.allPledges.append(object)
                
            })
          }
         return pledgesToReturn;
    

    }
    


func findPledgeWithThisID(ID: Int) -> Pledge{
    for pledge in allPledges{
        if pledge.id == ID{
            print("ID WITH PLEDGE: ", pledge)
            return pledge;
        }
    }
    return emptyPledge;
}
    func getPledgesCompleted() -> [Pledge]{
        
        let db = Firestore.firestore()
        pledgesCompleted = [Pledge]()
        var pledgesToReturn = [Pledge]()
        let currentUser = (auth.currentUser?.uid)!
        db.collection("UserPledges").document(currentUser).collection("Pledges")
          .getDocuments { (snapshot, error) in
             guard let snapshot = snapshot, error == nil else {
              //handle error
              return
            }
            print("Number of documents: \(snapshot.documents.count ?? -1)")
            snapshot.documents.forEach({ (documentSnapshot) in
              let documentData = documentSnapshot.data()
                let endDate = documentData["endDate"] as? String
                if (endDate != ""){
                    self.pledgesCompleted.append(self.findPledgeWithThisID(ID: documentData["ID"] as! Int))
                }
            })
          }
         return pledgesToReturn;
    

    }
    
    public func getPledgesToChooseFromArea(chosenArea: String) -> [Pledge]{
        
        let db = Firestore.firestore()
        pledgesCompleted = [Pledge]()
        var pledgesForArea = [Pledge]()
        let currentUser = (auth.currentUser?.uid)!
        db.collection("UserPledges").document(currentUser).collection("Pledges")
          .getDocuments { (snapshot, error) in
             guard let snapshot = snapshot, error == nil else {
              //handle error
              return
            }
            print("Number of documents: \(snapshot.documents.count ?? -1)")
            snapshot.documents.forEach({ (documentSnapshot) in
              let documentData = documentSnapshot.data()
                let category = documentData["category"] as? String
                let started = documentData["started"] as? Bool
                if (!started! && category == chosenArea){
                    self.pledgesForArea.append(self.findPledgeWithThisID(ID: documentData["ID"] as! Int))
                    print("appending pledge for area")
                }
            })
          }
         return pledgesForArea;
    

    }

    //struct PledgesInProgress_Previews: PreviewProvider {
    //    static var previews: some View {
    //        PledgesInProgress()
    //    }
    //}
    public func daysBetween(start: Date, end: Date) -> Int {
       Calendar.current.dateComponents([.day], from: start, to: end).day!
    }

    
}

let emptyPledge = Pledge(id: 1, description: "nil", category: "nil", imageName: "nil", durationInDays: 0, startDate: Date(), started: false, endDate: "")
