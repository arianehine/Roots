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
    @State var showFurtherInfoProgress:Bool = false
    @EnvironmentObject var fbLogic: FirebaseLogic
    @State var selectedForFurtherInfo: Pledge = emptyPledge;
    @State var durationSelected: Int?
   
    var pledgePicked: Pledge?
    @State var morePledges = false

    var body: some View {
        
        VStack{

        Text("Pledges in progress...")
            WrappingHStack(0..<fbLogic.pledgesInProgress.count, id:\.self, alignment: .center) { index in
                
                VStack{
                  


                        Button(action: {
                        
                            showFurtherInfo = true
                            showFurtherInfoProgress = true
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
                            
                                
      
                 

            Button(action: {
                
                self.morePledges = true
                
            }) {
                
            Text("Take more pledges?").padding(.vertical).padding(.horizontal,25).foregroundColor(.white)
            }
            .background(LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1")]), startPoint: .leading, endPoint: .trailing))
            .clipShape(Capsule())
            
            Spacer()
            
           

        }.toast(isPresenting: $showFurtherInfo, message: selectedForFurtherInfo.description).onAppear(perform: initVars)
        .background(
            VStack{
            NavigationLink(destination: AdditionalPledgesView(ID: "6", fbLogic: fbLogic), isActive: $morePledges) {
                            
                        }
            .hidden();
                
                NavigationLink(destination: TrackPledges(selectedForFurtherInfo: selectedForFurtherInfo), isActive: $showFurtherInfoProgress) {
                            
                        }
                        .hidden()
            }
                    )
            
                    
 
    }
    
    func initVars(){
 
        fbLogic.allPledges = fbLogic.getAllPledges();
        fbLogic.pledgesCompleted = fbLogic.getPledgesCompleted()
        fbLogic.pledgesInProgress = fbLogic.getPledgesInProgress(pledgePicked: pledgePicked ?? emptyPledge, durationSelected: durationSelected ?? 7)
  
       
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
@Published var userData = [UserData]()
@Published var results = [Bool]()
@Published var streak = 0
@Published var lastVisit = Date()
@Published var moreThan1Visit = false;

    func getPledgesInProgress(pledgePicked: Pledge, durationSelected: Int)-> [Pledge]{
    let db = Firestore.firestore()
    let auth = Auth.auth();
    pledgesInProgress = [Pledge]()

    let currentUser = (auth.currentUser?.uid)!
     if(pledgePicked.description != "nil"){
        let id = pledgePicked.id
        let userPledges = db.collection("UserPledges").document(currentUser).collection("Pledges").document(String(id)).updateData(["started":true, "durationInDays": durationSelected, "XP": (durationSelected*10)])
        
        
//     pledgesToReturn.append(pledgePicked)
     }
    
    db.collection("UserPledges").document(currentUser).collection("Pledges")
    .getDocuments { [self] (snapshot, error) in
         guard let snapshot = snapshot, error == nil else {
          //handle error
          return
        }
    
        snapshot.documents.forEach({ (documentSnapshot) in
            
            
          let documentData = documentSnapshot.data()
            let started = documentData["started"] as? Bool
            let endDate = documentData["endDate"] as? String
         
            if (started == true && endDate==""){
          
                pledgesInProgress.append(self.findPledgeWithThisID(ID: documentData["ID"] as! Int))
            }

        })
      }
     
    return pledgesInProgress;

}
    
    
    
    func getStreak(uid: String){
        let db = Firestore.firestore()
        var dates = [Date]();
        db.collection("Users").document(uid).collection("logins").getDocuments { (snapshot, error) in
              guard let snapshot = snapshot, error == nil else {
               //handle error
               return
             }
           
             snapshot.documents.forEach({ (documentSnapshot) in
                 
                 
              let documentData = documentSnapshot.data()
              let date = documentData["date"] as? Timestamp
                dates.append(date!.dateValue())
              let dateConverted = Date(timeIntervalSince1970: TimeInterval(date!.seconds))
                if(Calendar.current.isDateInToday(dateConverted)){
               
                 
                }
              
             })
            if(dates.count>2){
            self.lastVisit = dates[dates.count-2]
                self.moreThan1Visit = true;
            }else{
                self.lastVisit = dates[dates.count-1]
                self.moreThan1Visit = false;
            }
            print(self.lastVisit)
            self.countStreak(dateArray: dates)


           }

        
    }
    
    //inspiration from https://stackoverflow.com/questions/39334697/core-data-how-to-check-if-data-is-in-consecutive-dates
    func countStreak(dateArray: [Date]) {

        // The incoming parameter dateArray is immutable, so first make it mutable
        var mutableArray = dateArray

        // Next, sort the incoming array
        mutableArray.sort()

        var x = 0
        var numberOfConsecutiveDays = 1
        var streakArray = [Int]()

        // Cycle through the array, comparing the x and x + 1 elements
        while x + 1 < mutableArray.count {

            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: mutableArray[x], to: mutableArray[x + 1])

            // If the difference between the dates is greater than 1, append the streak to streakArray and reset the counter
            if abs(components.day!) > 1 {
                streakArray.append(numberOfConsecutiveDays)
                numberOfConsecutiveDays = 1
            }

            // If the difference between the days is exactly 1, add one to the current streak
            else if abs(components.day!) == 1 {
                numberOfConsecutiveDays += 1
            }

            x += 1
        }

        // Append the final streak to streakArray
        streakArray.append(numberOfConsecutiveDays)
        print(streakArray)

        // Return the user's longest streak
       streak = streakArray.max()!
    }
    

    
    func incrementUserXPPledge(pledge: Pledge, uid: String){
        let db = Firestore.firestore()
        db.collection("Users").document(uid).updateData(["XP": FieldValue.increment(Int64(pledge.XP))])
        
    }
    func incrementUserXP(amount: Int, uid: String){
        let db = Firestore.firestore()
        db.collection("Users").document(uid).updateData(["XP": FieldValue.increment(Int64(amount))])
        
    }
    

    func incrementPledgeCompletedDays(pledge: Pledge, uid: String, completion: @escaping (Bool) ->Void){
        let db = Firestore.firestore()
        var found = [Bool]()


            ///if completed
         
            
            db.collection("UserPledges").document(uid).collection("Pledges").document(String(pledge.id)).collection("Records").getDocuments { [self] (snapshot, error) in
                  guard let snapshot = snapshot, error == nil else {
                   //handle error
                   return
                 }
                if((snapshot.documents.count)==0){
                    completion(true)
                }
                 snapshot.documents.forEach({ (documentSnapshot) in
                     
                     
                  let documentData = documentSnapshot.data()
                  let date = documentData["date"] as? Timestamp
                  
                  let dateConverted = Date(timeIntervalSince1970: TimeInterval(date!.seconds))
                    if(Calendar.current.isDateInToday(dateConverted)){
                   
                        completion(false)
                        found.append(false)
                    }
                 })
                if(!(found.count > 0)){
                    completion(true)
                }
    
    
               }
        
        

          
            }
      

    
func incrementPledgeCompletedDays2(pledge: Pledge, uid: String){
    let db = Firestore.firestore()
    
    if(pledge.daysCompleted+1 == pledge.durationInDays){

        ///if completed
     
db.collection("UserPledges").document(uid).collection("Pledges").document(String(pledge.id)).updateData(["daysCompleted": FieldValue.increment(Int64(1)), "completed": true, "endDate": Date()])
    let date =  Date()
db.collection("UserPledges").document(uid).collection("Pledges").document(String(pledge.id)).collection("Records").document(dateToString(date: date)).setData(["date": date])
        
        
    } else{
  
        db.collection("UserPledges").document(uid).collection("Pledges").document(String(pledge.id)).updateData(["daysCompleted": FieldValue.increment(Int64(1))])
                let date = Date()
            db.collection("UserPledges").document(uid).collection("Pledges").document(String(pledge.id)).collection("Records").document(dateToString(date:date)).setData(["date": date])
            

        }

}
    public func dateToString(date: Date) -> String{
        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        // Convert Date to String
        return dateFormatter.string(from: date)
    }

    
    func getUserData(uid: String) -> [UserData]{
            let db = Firestore.firestore()
            userData = [UserData]()
            let auth = Auth.auth();
            let currentUser = (auth.currentUser?.uid)!
        
            
                let data = db.collection("UserData").document(currentUser).collection("Data")    .getDocuments { [self] (snapshot, error) in
                    guard let snapshot = snapshot, error == nil else {
                     //handle error
                     return
                   }
                
                   snapshot.documents.forEach({ (documentSnapshot) in
                       
                       
                    let documentData = documentSnapshot.data()
                    let ID = documentData["ID"] as? String
                    let date = documentData["date"] as? Timestamp
                    let average = documentData["average"] as? Double
                    let transport = documentData["transport"] as? Double
                    let household = documentData["household"] as? Double
                    let clothing = documentData["clothing"] as? Double
                    let health = documentData["health"] as? Double
                    let food = documentData["food"] as? Double
                    let transport_walking = documentData["transport_walking"] as? Double
                    let transport_car = documentData["transport_car"] as? Double
                    let transport_train = documentData["transport_train"] as? Double
                    let transport_bus = documentData["transport_bus"] as? Double
                    let transport_plane = documentData["transport_plane"] as? Double
                    let household_heating = documentData["household_heating"] as? Double
                    let household_electricity = documentData["household_electricity"] as? Double
                    let household_furnishings = documentData["household_furnishings"] as? Double
                    let household_lighting = documentData["household_lighting"] as? Double
                    let clothing_fastfashion = documentData["clothing_fastfashion"] as? Double
                    let clothing_sustainable = documentData["clothing_sustainable"] as? Double
                    let health_meds = documentData["health_meds"] as? Double
                    let health_scans = documentData["health_scans"] as? Double
                    let food_meat = documentData["food_meat"] as? Double
                    let food_fish = documentData["food_fish"] as? Double
                    let food_dairy = documentData["food_dairy"] as? Double
                    let food_oils = documentData["food_oils"] as? Double
                    let dateConverted = Date(timeIntervalSince1970: TimeInterval(date!.seconds))
                    
                   
                    userData.append(UserData(ID: ID!, date: dateConverted, average: average!, transport: transport!, household: household!, clothing: clothing!, health: health!, food: food!, transport_walking: transport_walking!, transport_car: transport_car!, transport_train: transport_train!, transport_bus: transport_bus!, transport_plane: transport_plane!, household_heating: household_heating!, household_electricity: household_electricity!, household_furnishings: household_furnishings!, household_lighting: household_lighting!, clothing_fastfashion: clothing_fastfashion!, clothing_sustainable: clothing_sustainable!, health_meds: health_meds!, health_scans: health_scans!, food_meat: food_meat!, food_fish: food_fish!, food_dairy: food_dairy!, food_oils: food_oils!))
                    
    //                   print(started)
    //                   if (started == true && endDate==""){
    //                       print("append", self.findPledgeWithThisID(ID: documentData["ID"] as! Int))
    //                       pledgesInProgress.append(self.findPledgeWithThisID(ID: documentData["ID"] as! Int))
    //                   }

                   })
                 
                 }
                
                
        //     pledgesToReturn.append(pledgePicked)
           
            
            return userData
            
        }
    
    func getAllPledges() -> [Pledge]{
        
        let db = Firestore.firestore()
        let auth = Auth.auth();
        let currentUser = (auth.currentUser?.uid)!
        self.allPledges = [Pledge]()
        var pledgesToReturn = [Pledge]()
    
        db.collection("UserPledges").document(currentUser).collection("Pledges")
          .getDocuments { (snapshot, error) in
             guard let snapshot = snapshot, error == nil else {
              //handle error
              return
            }
          
            snapshot.documents.forEach({ (documentSnapshot) in
                let documentData = documentSnapshot.data()
                let ID = documentData["ID"]! as? Int
                let description = documentData["description"] as? String
                let category = documentData["category"] as? String
                let imageName = documentData["imageName"] as? String
                let durationInDays = documentData["durationInDays"] as? Int
                let started = documentData["started"] as? Bool
                let completed = documentData["completed"] as? Bool
                let daysCompleted = documentData["daysCompleted"] as? Int
                let startDateInterval = documentData["startDate"] as? Timestamp
                let endDate = documentData["endDate"] as? String
                let XP = documentData["XP"] as? Int
                let startDate = Date(timeIntervalSince1970: TimeInterval(startDateInterval!.seconds))

                let object = Pledge(id: ID!, description: description!, category: category!, imageName: imageName!, durationInDays: durationInDays!, startDate: startDate, started: started!, completed: completed!, daysCompleted: daysCompleted!, endDate: endDate ?? "", XP: XP!)
            
                    self.allPledges.append(object)
                
            })
          }
         return pledgesToReturn;
    

    }
    


func findPledgeWithThisID(ID: Int) -> Pledge{
    for pledge in allPledges{
        if pledge.id == ID{
         
            return pledge;
        }
    }
    return emptyPledge;
}
    func getPledgesCompleted() -> [Pledge]{
        
        let db = Firestore.firestore()
        let auth = Auth.auth();
        pledgesCompleted = [Pledge]()

        let currentUser = (auth.currentUser?.uid)!
        db.collection("UserPledges").document(currentUser).collection("Pledges")
          .getDocuments { (snapshot, error) in
             guard let snapshot = snapshot, error == nil else {
              //handle error
              return
            }
           
            snapshot.documents.forEach({ (documentSnapshot) in
              let documentData = documentSnapshot.data()
                let endDate = documentData["endDate"] as? String
                if (endDate != ""){
                    self.pledgesCompleted.append(self.findPledgeWithThisID(ID: documentData["ID"] as! Int))
                }
            })
          }
      
         return pledgesCompleted;
    

    }
    
    public func getPledgesToChooseFromArea(chosenArea: String) -> [Pledge]{
        
        let db = Firestore.firestore()
        let auth = Auth.auth();
        pledgesCompleted = [Pledge]()
        var pledgesForArea = [Pledge]()
        let currentUser = (auth.currentUser?.uid)!
        db.collection("UserPledges").document(currentUser).collection("Pledges")
          .getDocuments { (snapshot, error) in
             guard let snapshot = snapshot, error == nil else {
              //handle error
              return
            }
         
            snapshot.documents.forEach({ (documentSnapshot) in
              let documentData = documentSnapshot.data()
                let category = documentData["category"] as? String
                let started = documentData["started"] as? Bool
                if (!started! && category == chosenArea){
                    self.pledgesForArea.append(self.findPledgeWithThisID(ID: documentData["ID"] as! Int))
                 
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

let emptyPledge = Pledge(id: 1, description: "nil", category: "nil", imageName: "nil", durationInDays: 0, startDate: Date(), started: false, completed: false, daysCompleted: 0, endDate: "", XP: 0)
