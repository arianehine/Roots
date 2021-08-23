//
//  FirebaseHandler.swift
//  FirebaseHandler
//
//  Created by Ariane Hine on 28/07/2021.
//

import Foundation
import Firebase
import FirebaseFirestore

//The class which deals with most of the requests and interactgions with the Firestore Firebase database
class FirebaseLogic: ObservableObject {
    //All the published vars which other classes read the data from
    @Published var pledgesInProgress = [Pledge]()
    @Published var pledgesCompleted = [Pledge]()
    @Published var pledgesForArea = [Pledge]()
    @Published var allPledges = [Pledge]()
    @Published var userData = [UserData]()
    @Published var results = [Bool]()
    @Published var streak = 0
    @Published var lastVisit = Date()
    @Published var moreThan1Visit = false;
    
    //Adds all of the data from a userDate variable into the user's firestore records
    func addData(user: UserData, userId: String){
        let db = Firestore.firestore()
        db.collection("UserData").document(userId).collection("Data").document(dateToString(date: user.date))
            .setData([ "ID": userId, "date": user.date, "average": user.average, "transport": user.transport, "household": user.household, "clothing": user.clothing, "health": user.health, "food": user.food, "transport_walking": user.transport_walking, "transport_car": user.transport_car, "transport_train": user.transport_train,"transport_plane": user.transport_plane, "transport_bus": user.transport_bus, "household_heating": user.household_heating,"household_electricity": user.household_electricity,"household_furnishings": user.household_furnishings,"household_lighting": user.household_lighting,"clothing_fastfashion": user.clothing_fastfashion,"clothing_sustainable": user.clothing_sustainable,"health_meds": user.health_meds,"health_scans": user.health_scans, "food_meat": user.food_meat,"food_fish": user.food_fish,"food_dairy": user.food_dairy,"food_oils": user.food_oils]);
        print("reduction data pushed")
    }
    
    //Sets notification to true/false depending on what the user has chosen, on a specific pledge
    func turnNotificationsOn(pledge: Pledge, value: Bool){
        
        let db = Firestore.firestore()
        let auth = Auth.auth();
        let currentUser = (auth.currentUser?.uid)!
        if(pledge.description != "nil"){
            let id = pledge.id
            let userPledges = db.collection("UserPledges").document(currentUser).collection("Pledges").document(String(id)).updateData(["notficatons": value])

        }
        
    }
    
    //Sets the fake data for the user in firesore, for today
    func setFakeData(uid: String, selection: String){
        let db = Firestore.firestore()
        var count = 0
        let data = db.collection("UserData").document(uid).collection("Data").getDocuments { [self] (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                print("error")
                return
            }
            
            snapshot.documents.forEach({ (documentSnapshot) in
                let documentData = documentSnapshot.data()
                let ID = documentData["ID"] as? String
                let date = documentData["date"] as? Timestamp
                let dateConverted = Date(timeIntervalSince1970: TimeInterval(date!.seconds))
                if(Calendar.current.isDateInToday(dateConverted)){
                    count = count+1
                }
            }
            )
            if (count==0) {
                let fakeData =  UserData(ID: selection, date: Date(), average: 2626.49, transport: 1039.88, household: 551.62, clothing: 328.91, health: 308.91, food: 397.17, transport_walking: 159.97, transport_car: 63.99, transport_train: 121.58, transport_bus: 121.58, transport_plane: 70.39, household_heating: 126.87, household_electricity: 165.49, household_furnishings: 132.39, household_lighting: 126.87, clothing_fastfashion: 179.17, clothing_sustainable: 129.74, health_meds: 210.06, health_scans: 98.85, food_meat: 123.12, food_fish: 91.35, food_dairy: 99.29, food_oils: 83.41)
                
                addData(user: fakeData, userId: uid)
                
                print("set fake data in FB")
            }else{
                print("no need to set")
            }
        }
        
    }
    
    //Gets all of the pledges which the user has started and not finished yet (i.e. are in progress)
    func getPledgesInProgress(pledgePicked: Pledge, durationSelected: Int)-> [Pledge]{
        let db = Firestore.firestore()
        let auth = Auth.auth();
        pledgesInProgress = [Pledge]()
        let currentUser = (auth.currentUser?.uid)!
        if(pledgePicked.description != "nil"){
            let id = pledgePicked.id
            let userPledges = db.collection("UserPledges").document(currentUser).collection("Pledges").document(String(id)).updateData(["started":true, "durationInDays": durationSelected, "XP": (durationSelected*10), "startDate" : Date()])
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
    
    //Retrieves the user's streak count
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
    
    //Increase the user's XP by the value the pledge is worth
    func incrementUserXPPledge(pledge: Pledge, uid: String){
        let db = Firestore.firestore()
        db.collection("Users").document(uid).updateData(["XP": FieldValue.increment(Int64(pledge.XP))])
    }
    
    //Increase the user's XP by the value stated
    func incrementUserXP(amount: Int, uid: String){
        let db = Firestore.firestore()
        db.collection("Users").document(uid).updateData(["XP": FieldValue.increment(Int64(amount))])
    }
    
    //Increment the number of completed days for a partiular pledge (contains callback)
    func incrementPledgeCompletedDays(pledge: Pledge, uid: String, completion: @escaping (Bool) ->Void){
        let db = Firestore.firestore()
        var found = [Bool]()
        
        //if completed
        db.collection("UserPledges").document(uid).collection("Pledges").document(String(pledge.id)).collection("Records").getDocuments { [self] (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                //handle error
                return
            }
            if((snapshot.documents.count)==0){
                completion(true)
                return
            }
            snapshot.documents.forEach({ (documentSnapshot) in
                
                let documentData = documentSnapshot.data()
                let date = documentData["date"] as? Timestamp
                
                let dateConverted = Date(timeIntervalSince1970: TimeInterval(date!.seconds))
                if(Calendar.current.isDateInToday(dateConverted)){
                    
                    completion(false)
                    found.append(false)
                    return
                }
            })
            if(!(found.count > 0)){
                
                completion(true)
                return
            }
            
            
        }
        
    }
    
    //Increment the number of completed days for a partiular pledge directly (no callback)
    func incrementPledgeCompletedDays2(pledge: Pledge, uid: String){
        
        let db = Firestore.firestore()
        
        if(pledge.daysCompleted+1 == pledge.durationInDays){
            
            //if completed
            db.collection("UserPledges").document(uid).collection("Pledges").document(String(pledge.id)).updateData(["daysCompleted": FieldValue.increment(Int64(1)), "completed": true, "endDate": Date()])
            let date =  Date()
            db.collection("UserPledges").document(uid).collection("Pledges").document(String(pledge.id)).collection("Records").document(dateToString(date: date)).setData(["date": date])
            
            turnNotificationsOn(pledge: pledge, value: false)
            
        } else{
        
            db.collection("UserPledges").document(uid).collection("Pledges").document(String(pledge.id)).updateData(["daysCompleted": FieldValue.increment(Int64(1))])
            let date = Date()
            db.collection("UserPledges").document(uid).collection("Pledges").document(String(pledge.id)).collection("Records").document(dateToString(date:date)).setData(["date": date])
            
        }
        
    }
    //convert date to string
    public func dateToString(date: Date) -> String{
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // Convert Date to String
        return dateFormatter.string(from: date)
    }
    
    //Gets all of the data for a particular UID
    func getUserData(uid: String){
        let db = Firestore.firestore()
        self.userData = [UserData]()
        let auth = Auth.auth();
        let currentUser = (auth.currentUser?.uid)!
        
        let data = db.collection("UserData").document(currentUser).collection("Data")    .getDocuments { [self] (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                print("error")
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
                
                self.userData.append(UserData(ID: ID!, date: dateConverted, average: average!, transport: transport!, household: household!, clothing: clothing!, health: health!, food: food!, transport_walking: transport_walking!, transport_car: transport_car!, transport_train: transport_train!, transport_bus: transport_bus!, transport_plane: transport_plane!, household_heating: household_heating!, household_electricity: household_electricity!, household_furnishings: household_furnishings!, household_lighting: household_lighting!, clothing_fastfashion: clothing_fastfashion!, clothing_sustainable: clothing_sustainable!, health_meds: health_meds!, health_scans: health_scans!, food_meat: food_meat!, food_fish: food_fish!, food_dairy: food_dairy!, food_oils: food_oils!))
            })
            
            self.userData = userData
        }
    
    }
    
    //Gets all of a user's Pledge
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
                    let reductionPerDay = documentData["reductionPerDay"] as? Int
                    
                    let object = Pledge(id: ID!, description: description!, category: category!, imageName: imageName!, durationInDays: durationInDays!, startDate: startDate, started: started!, completed: completed!, daysCompleted: daysCompleted!, endDate: endDate ?? "", XP: XP!, notifications: notifications ?? false, reductionPerDay: reductionPerDay ?? 100)
                    
                    self.allPledges.append(object)
                    
                })
            }
        
        return pledgesToReturn;
        
    }
    
    //Check if any pledges have expired (i.e. user didn't complete them in time), and reset them
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
    
    //Actually resets a pledge by resetting it to not started, and they days completed to 0. Deletes the associated pledge check in records
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
        turnNotificationsOn(pledge: findPledgeWithThisID(ID: pledgeID), value: false)
        
    }
    
    //Fetches the Pledge with an associated ID
    func findPledgeWithThisID(ID: Int) -> Pledge{
        for pledge in allPledges{
            if pledge.id == ID{
                
                return pledge;
            }
        }
        return emptyPledge;
    }
    //Gets all of the pledges a user has successfully completed
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
    
    //Get pledges associated with a particular carbon footprint area (e.g. household, food, etc.)
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
    
    //Calculates the days between 2 dates
    public func daysBetween(start: Date, end: Date) -> Int {
        Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    
}
