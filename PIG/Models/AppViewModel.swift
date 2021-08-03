//
//  AppViewModel.swift
//  AppViewModel
//
//  Created by Ariane Hine on 28/07/2021.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

class AppViewModel: ObservableObject{
    @State var statsController: StatsDataController
    @State var directory: URL
    let auth = Auth.auth();
    @State var fbLogic: FirebaseLogic
    
    
 
    func signIn(email: String, password: String){
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else{
                self?.error = error!.localizedDescription
                let db = Firestore.firestore();
                self?.alert.toggle()
                let uid = self!.auth.currentUser!.uid
                let date = Date()
                db.collection("Users").document(uid).collection("logins").document(date.dateToString(date: date)).setData(["date": date])
                return
            }
            
            //success
            //becuase it's a pushlished var we need to update on main thread
            DispatchQueue.main.async {
                self?.signedIn = true
            }
            
            
        }
        
    }
    
    public init(statsController: StatsDataController, fbLogic: FirebaseLogic, directory: URL){
        self.statsController = statsController
        self.fbLogic = fbLogic
        self.directory = directory
    }
    
    func displayError(error: Error?){
        print(error?.localizedDescription)
        
    }
    
    func signUp(email: String, password: String, firstName: String, lastName:String, selection: String){
        auth.createUser(withEmail: email, password: password) { [weak self] (result, error) in
            
            guard result != nil, error == nil else{
                self?.error = error!.localizedDescription
                self?.alert.toggle()
                print(error?.localizedDescription)
                print("an error occured")
                return
                
            }
            
           
            let db = Firestore.firestore()
            
            let uid = result!.user.uid
            
            
            //creates profile doc under uid with all the info
            db.collection("Users").document(result!.user.uid)
                .setData([ "firstName":firstName, "lastName":lastName, "uid":uid, "email":email, "currentStreak": 0, "longestStreak":0, "XP": 0]);
            
            
            let date = Date()
            db.collection("Users").document(uid).collection("logins").document(date.dateToString(date: date)).setData(["date": date])
            
            self!.setPledgesForUser(userId: result!.user.uid, db: db);
            self!.setDataForUser(userId: result!.user.uid, db: db, selection: selection, statsController: self!.statsController);
            
            //update published var on main thread
            DispatchQueue.main.async {
            
                self?.signedIn = true
                print("done")
            }
          
        }
        
    }
    
    func signOut(){
        try? auth.signOut()
        self.signedIn=false;
    }
    
    func setPledgesForUser(userId: String, db: Firestore){
        
        for pledge in pledges{
            db.collection("UserPledges").document(userId).collection("Pledges").document(String(pledge.id))
                .setData([ "ID":pledge.id, "description":pledge.description, "category":pledge.category, "imageName":pledge.imageName, "durationInDays":pledge.durationInDays, "startDate": pledge.startDate, "completed": false, "daysCompleted": 0,"started": pledge.started, "endDate": pledge.endDate, "XP": pledge.XP, "notifications": pledge.notifications]);
        }
        
    }

    func setDataForUser(userId: String, db: Firestore, selection: String, statsController: StatsDataController){
        let csvHandler = CSVHandler(fbLogic: fbLogic)
        let userData = statsController.convertCSVIntoArray(csvHandler: csvHandler, directory: directory)
        
        for user in userData{
            if(user.ID == selection){
                var stringDate = user.date.dateToString(date: user.date)
                db.collection("UserData").document(userId).collection("Data").document(stringDate)
                    .setData([ "ID": userId, "date": user.date, "average": user.average, "transport": user.transport, "household": user.household, "clothing": user.clothing, "health": user.health, "food": user.food, "transport_walking": user.transport_walking, "transport_car": user.transport_car, "transport_train": user.transport_train,"transport_plane": user.transport_plane, "transport_bus": user.transport_bus, "household_heating": user.household_heating,"household_electricity": user.household_electricity,"household_furnishings": user.household_furnishings,"household_lighting": user.household_lighting,"clothing_fastfashion": user.clothing_fastfashion,"clothing_sustainable": user.clothing_sustainable,"health_meds": user.health_meds,"health_scans": user.health_scans, "food_meat": user.food_meat,"food_fish": user.food_fish,"food_dairy": user.food_dairy,"food_oils": user.food_oils]);
            }
        }
        
        
    }
    
    
    let pledges = [
        Pledge(id: 1, description: "Walk to work", category: "Transport", imageName: "figure.walk", durationInDays: 7, startDate: Date(), started: false, completed: false, daysCompleted: 0, endDate: "", XP: 70, notifications: false, reductionPerDay: 100),
        Pledge(id: 2,description: "Swap the car for walking", category: "Transport", imageName: "car.fill", durationInDays: 7, startDate: Date(), started: false, completed: false, daysCompleted: 0,endDate: "", XP: 70, notifications: false, reductionPerDay: 100),
        Pledge(id: 3, description: "Swap the car for the train", category: "Transport", imageName: "tram.fill",durationInDays: 7, startDate: Date(), started: false, completed: false, daysCompleted: 0,endDate: "", XP: 70, notifications: false, reductionPerDay: 100),
        Pledge(id: 4, description: "Take 0 taxis", category: "Transport", imageName: "figure.wave",durationInDays: 7, startDate: Date(), started: false,completed: false, daysCompleted: 0, endDate: "", XP: 70, notifications: false, reductionPerDay: 100),
        Pledge(id: 5, description: "Cut out dairy", category: "Food", imageName: "m.circle.fill",durationInDays: 7, startDate: Date(), started: false, completed: false, daysCompleted: 0,endDate: "", XP: 70, notifications: false, reductionPerDay: 100),
        Pledge(id: 6, description: "Cut fish out of your dairy", category: "Food", imageName: "f.circle.fill",durationInDays: 7, startDate: Date(), started: false,completed: false, daysCompleted: 0, endDate: "", XP: 70, notifications: false, reductionPerDay: 100),
        Pledge(id: 7, description: "Swap cow's milk for a non-dairy alternative", category: "Food", imageName: "d.circle.fill",durationInDays: 7, startDate: Date(), started: false, completed: false, daysCompleted: 0,endDate: "", XP: 70, notifications: false, reductionPerDay: 100),
        Pledge(id: 8, description: "Eat vegetarian ", category: "Food", imageName: "d.circle.fill",durationInDays: 7, startDate: Date(), started: false, completed: false, daysCompleted: 0,endDate: "", XP: 70, notifications: false, reductionPerDay: 100),
        Pledge(id: 9,description: "Eat vegan", category: "Food", imageName: "leaf.fill",durationInDays: 7, startDate: Date(), started: false, completed: false, daysCompleted: 0,endDate: "", XP: 70, notifications: false, reductionPerDay: 100),
        Pledge(id: 10,description: "Put your heating on a set timer!", category: "Household", imageName: "flame.fill",durationInDays: 7, startDate: Date(), started: false, completed: false, daysCompleted: 0,endDate: "", XP: 70, notifications: false, reductionPerDay: 100),
        Pledge(id: 11, description: "Only fill the kettle for 1 cup when you boil it", category: "Household", imageName: "bolt.fill",durationInDays: 7, startDate: Date(), started: false, completed: false, daysCompleted: 0,endDate: "", XP: 70, notifications: false, reductionPerDay: 100),
        Pledge(id: 12, description: "Don't buy any furniature", category: "Household", imageName: "house.fill",durationInDays: 7, startDate: Date(), started: false,completed: false, daysCompleted: 0, endDate: "", XP: 70, notifications: false, reductionPerDay: 100),
        Pledge(id: 13,description: "Turn lights off when you leave the room!", category: "Household", imageName: "lightbulb.fill",durationInDays: 7, startDate: Date(), started: false,completed: false, daysCompleted: 0, endDate: "", XP: 70, notifications: false, reductionPerDay: 100),
        Pledge(id: 14,description: "Don't buy any fast fashion", category: "Fashion", imageName: "hourglass",durationInDays: 7, startDate: Date(), started: false,completed: false, daysCompleted: 0, endDate: "", XP: 70, notifications: false, reductionPerDay: 100),
        Pledge(id: 15, description: "Take a trip to the charity shop instead of buying new!", category: "Fashion", imageName: "arrow.3.trianglepath",durationInDays: 7, startDate: Date(), started: false, completed: false, daysCompleted: 0,endDate: "", XP: 70, notifications: false, reductionPerDay: 100),
        Pledge(id: 16,description: "Download Depop and sell some of your own clothes!", category: "Fashion", imageName: "bag.circle.fill",durationInDays: 7, startDate: Date(), started: false, completed: false, daysCompleted: 0,endDate: "", XP: 70, notifications: false, reductionPerDay: 100),
        Pledge(id: 17, description: "Sort thrugh your medidicnes at home, so you know how much you have!", category: "Health", imageName: "pills.fill",durationInDays: 7, startDate: Date(), started: false,completed: false, daysCompleted: 0, endDate: "", XP: 70, notifications: false, reductionPerDay: 100)
        
        
    ]
    
    //Whenever a published var chages we can update view automatically in real time, because it's a binding
    @Published var signedIn = false
    @Published var alert = false;
    @Published var error = ""
    
    var isSignedIn: Bool{
        return auth.currentUser != nil
        
    }
    
}
