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
import UserNotifications

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
                    Toggle("Notifs?", isOn: $fbLogic.pledgesInProgress[index].notifications).padding(.leading)
                        .toggleStyle(SwitchToggleStyle(tint: .green)).onChange(of: fbLogic.pledgesInProgress[index].notifications, perform: {value in
                            
                            if(value){
                                //turn notifs on
                             requestPermissions(pledge: fbLogic.pledgesInProgress[index], value: value)
                            }else{
                                //turn them off
                            }
                         
                            
                           
                                fbLogic.turnNotificationsOn(pledge: fbLogic.pledgesInProgress[index], value: value)
                            
                        }
                            
                        
                                                                               
                        )

                       
                    

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
            
           

        }
        
        .toast(isPresenting: $showFurtherInfo, message: selectedForFurtherInfo.description).onAppear(perform: initVars)
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
    func setNotifReminder(pledge: Pledge){
        print("setting stuff")
        let content = UNMutableNotificationContent()
        content.title = "Complete your pledge"
        content.subtitle = "\(pledge.description)"
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: true)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
        print("done")
    }
    func requestPermissions(pledge: Pledge, value: Bool){
       
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
           
            if success && value{
              print("granted")
                    setNotifReminder(pledge: pledge)
              
                
            } else if let error = error {
                print("not granted")
                Swift.print(error.localizedDescription)
             
            }
        }
     
    }
    func initVars(){
 
        fbLogic.allPledges = fbLogic.getAllPledges();
        fbLogic.checkIfAnyPledgesToReset()
        fbLogic.allPledges = fbLogic.getAllPledges();
        fbLogic.pledgesCompleted = fbLogic.getPledgesCompleted()
        fbLogic.pledgesInProgress = fbLogic.getPledgesInProgress(pledgePicked: pledgePicked ?? emptyPledge, durationSelected: durationSelected ?? 7)
  
       
    }
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

    func turnNotificationsOn(pledge: Pledge, value: Bool){
        print("turn on notifs for \(pledge.description)")
        let db = Firestore.firestore()
        let auth = Auth.auth();

        let currentUser = (auth.currentUser?.uid)!
         if(pledge.description != "nil"){
            let id = pledge.id
            let userPledges = db.collection("UserPledges").document(currentUser).collection("Pledges").document(String(id)).updateData(["notficatons": value])
            
            
    //     pledgesToReturn.append(pledgePicked)
         }
        
    }
    
    func getPledgesInProgress(pledgePicked: Pledge, durationSelected: Int)-> [Pledge]{
    let db = Firestore.firestore()
    let auth = Auth.auth();
    pledgesInProgress = [Pledge]()

    let currentUser = (auth.currentUser?.uid)!
     if(pledgePicked.description != "nil"){
        let id = pledgePicked.id
        let userPledges = db.collection("UserPledges").document(currentUser).collection("Pledges").document(String(id)).updateData(["started":true, "durationInDays": durationSelected, "XP": (durationSelected*10), "startDate" : Date()])
        
        
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
        var lastVisit: Date = Date()
        var streak: Int = 0
    
            let docRef = db.collection("Users").document(uid)

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                    streak = document.data()?["currentStreak"] as! Int
        
                    return
                } else {
                    print("Document does not exist")
                }
                
                self.streak = document!.data()?["currentStreak"] as! Int

            }
        
    }
    
    //inspiration from https://stackoverflow.com/questions/39334697/core-data-how-to-check-if-data-is-in-consecutive-dates
   
    
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
                    


                   })
                 
                 }
                
        
           
            
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
                let notifications = documentData["notifications"] as? Bool
                let startDate = Date(timeIntervalSince1970: TimeInterval(startDateInterval!.seconds))

                let object = Pledge(id: ID!, description: description!, category: category!, imageName: imageName!, durationInDays: durationInDays!, startDate: startDate, started: started!, completed: completed!, daysCompleted: daysCompleted!, endDate: endDate ?? "", XP: XP!, notifications: notifications ?? false)
            
                    self.allPledges.append(object)
                
            })
          }
    
         return pledgesToReturn;
    

    }
    

    func checkIfAnyPledgesToReset(){
      
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
                let startDateInterval = documentData["startDate"] as? Timestamp
                let durationInDays = documentData["durationInDays"] as? Int
                let endDate = documentData["endDate"] as? String
                let startDate = Date(timeIntervalSince1970: TimeInterval(startDateInterval!.seconds))
                let calendar = Calendar.current
                let components = calendar.dateComponents([.day], from: startDate, to: Date())
                var numDays : Int = components.day!
               
                if(numDays >= durationInDays!){
                    self.resetPledge(pledgeID: ID!)
                }
                })
                
                
              }

    
        
    }
    
    func resetPledge(pledgeID: Int){
        let db = Firestore.firestore()
        let auth = Auth.auth();
        let currentUser = (auth.currentUser?.uid)!
       
        self.allPledges = [Pledge]()
        var pledgesToReturn = [Pledge]()
    
        db.collection("UserPledges").document(currentUser).collection("Pledges")
            .document(String(pledgeID)).updateData(["started": false, "daysCompleted": 0])
        db.collection("UserPledges").document(currentUser).collection("Pledges")
            .document(String(pledgeID)).collection("Records").getDocuments { (snapshot, error) in
                guard let snapshot = snapshot, error == nil else {
                 //handle error
                 return
               }
             
               snapshot.documents.forEach({ (documentSnapshot) in
                let documentData = documentSnapshot.data()
                let date = documentData["date"]! as? Timestamp
                let dateConverted = Date(timeIntervalSince1970: TimeInterval(date!.seconds))
                db.collection("UserPledges").document(currentUser).collection("Pledges")
                    .document(String(pledgeID)).collection("Records").document(self.dateToString(date: dateConverted)).delete()
                
               })
            }
        self.allPledges = getAllPledges()
          
        
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

let emptyPledge = Pledge(id: 1, description: "nil", category: "nil", imageName: "nil", durationInDays: 0, startDate: Date(), started: false, completed: false, daysCompleted: 0, endDate: "", XP: 0, notifications: false)
