//
//  ContentView.swift
//  PaintItGreen3
//
//  Created by ariane hine on 13/05/2021.
//
//Log in inspired by this tutorial by iOS academy:
//https://www.youtube.com/watch?v=vPCEIPL0U_k
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Combine
import Keys



struct ContentView: View {
    
    let auth = Auth.auth();
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var statsController: StatsDataController
    @State var directory: URL
    @State var fbLogic: FirebaseLogic
    @State var selection = ""
    @State var name = ""
    @State var originalReports: [Report] = [Report]();
    @State var reports: [Report] = [Report]();
    @State var originalPeople =  [UserData]();
    @State var pledgesInProgress = [Pledge]()
    @State var XP = 0;
    @State var level = 0;
    @State var toastShow: Bool = false
    @State var message = ""
    @State var showingModal = false
    @State var completed = false
    var body: some View {
        NavigationView{
            
            
            
            if viewModel.signedIn{
                
                VStack{
                    
                    TabView(selection: $selection){
                        StatsView(ID: viewModel.footprint, originalPeople: statsController.fbLogic.userData, fbLogic: $fbLogic, selection: selection).environmentObject(statsController).environmentObject(viewModel)
                            .tabItem {
                                VStack {
                                    Image(systemName: "chart.bar")
                                    Text("Stats") // Update tab title
                                }
                            }
                            .tag(0)
                        
                        
                        DoughnutView(ID: $viewModel.footprint, selection: selection, reports: $reports, originalReports: $originalReports, originalPeople: originalPeople).environmentObject(statsController).environmentObject(viewModel)
                            .font(.title)
                            .tabItem {
                                VStack {
                                    Image(systemName: "chart.pie")
                                    Text("Detailed Stats") // Update tab title
                                }
                            }.tag(1)
                        
                        StreaksView(uid: auth.currentUser!.uid)
                            .tabItem {
                                VStack {
                                    Image(systemName: "star.fill")
                                    Text("Streaks") // Update tab title
                                }
                            }
                            .tag(2)
                        
                        
                        
                        PledgesInProgress(
                            statsController: statsController).environmentObject(fbLogic)
                            .tabItem {
                                VStack {
                                    Image(systemName: "hands.sparkles.fill")
                                    Text("Pledges") // Update tab title
                                }
                            }
                            .tag(3)
                        
                        
                    }
                }.toast(isPresenting: $toastShow, message: message).navigationBarTitle("Welcome back " +  name)
                    .navigationBarItems(leading:
                                            Text("XP: \(XP) Level: \(getLevel(XP: XP))"),
                                        trailing: Button(action: {
                        viewModel.signOut()
                    }, label: {
                        Text("Sign Out")
                    }))
                    .onAppear(){
                        getName()
                        logVisit(uid: auth.currentUser!.uid)
                        getXP(uid: auth.currentUser!.uid)
                        level = getLevel(XP: XP)
                        getFootprint()
                        fbLogic.setFakeData(uid: auth.currentUser!.uid, selection: viewModel.footprint);
                        fbLogic.getUserData(uid: auth.currentUser!.uid)
                    }
                
                
            }else{
                
                SignInView().environmentObject(viewModel)
                    .navigationBarHidden(true)
            }
            
        }.onAppear{
            
            viewModel.signedIn = viewModel.isSignedIn;
            viewModel.alert=false
          
          
        }
        
    }
    
    func getFootprint(){
        let auth = Auth.auth();
        let db = Firestore.firestore();
        var footprint = ""
        
        
        let uid = auth.currentUser!.uid
        let docRef = db.collection("Users").document(uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                footprint = document.data()?["footprint"] as? String ?? ""
                viewModel.footprint = footprint
               print("footprint: ", footprint)
                
                return
            } else {
                print("Document does not exist")
            }
            footprint = document?.data()?["footprint"] as! String
            viewModel.footprint = footprint
            return
        }
        

    }
    
    func logVisit(uid: String){
        let date = Date()
        let db = Firestore.firestore()
        var lastVisit: Date = Date()
        var streak: Int = 0
        
        let docRef = db.collection("Users").document(uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                streak = document.data()?["currentStreak"] as? Int ?? 0
                
                
            } else {
                print("Document does not exist")
            }
            
            streak = document!.data()?["currentStreak"] as? Int ?? 0
            
            
            
            if(streak == 0){
              
                db.collection("Users").document(uid).updateData(["currentStreak": 1])
                fbLogic.incrementUserXP(amount: 10, uid: uid)
                message = "No streak. Log in tomorrow to get one! +10XP"
                
                getXP(uid: auth.currentUser!.uid)
               
                toastShow = true;
                db.collection("Users").document(uid).collection("logins").document(date.dateToString(date: date)).setData(["date": date])
            }else if(streak != 0){
                var dates = [Date]()
                db.collection("Users").document(uid).collection("logins").getDocuments { (snapshot, error) in
                    guard let snapshot = snapshot, error == nil else {
                        //handle error
                        return
                    }
                    
                    snapshot.documents.forEach({ (documentSnapshot) in
                        
                        
                        let documentData = documentSnapshot.data()
                        let date = documentData["date"] as? Timestamp
                        dates.append(date!.dateValue())
                        
                        
                    })
                    
                    lastVisit = dates[dates.count-1]
                    
                    
                    let dateConverted = Date(timeIntervalSince1970: TimeInterval(lastVisit.timeIntervalSince1970))

                    if(!(Calendar.current.isDateInToday(dateConverted))){
                        if(Calendar.current.isDateInYesterday(dateConverted)){
                          
                            db.collection("Users").document(uid).updateData(["currentStreak": FieldValue.increment(Int64(1))])
                            fbLogic.incrementUserXP(amount: ((streak+1)*10), uid: uid)
                            message = "Congrats, you have a \(streak+1) day streak. + \((streak+1) * 10)XP"
                            getXP(uid: auth.currentUser!.uid)
                           
                            
                            toastShow = true;
                            db.collection("Users").document(uid).collection("logins").document(date.dateToString(date: date)).setData(["date": date])
                        }else{
                         
                            db.collection("Users").document(uid).updateData(["currentStreak": 1])
                            fbLogic.incrementUserXP(amount: 10, uid: uid)
                            message = "No streak. Log in tomorrow to get one! +10XP"
                          
                            getXP(uid: auth.currentUser!.uid)
                           
                            toastShow = true;
                            db.collection("Users").document(uid).collection("logins").document(date.dateToString(date: date)).setData(["date": date])
                        }
                        
                        
                        
                    }else{
                    
                        db.collection("Users").document(uid).collection("logins").document(date.dateToString(date: date)).setData(["date": date])
                    }
                }
                
                
                
            }
            
        }
        

    }
    
    

    
    func checkIfStreak(fbLogic: FirebaseLogic) -> Bool{
        
        
        if(fbLogic.streak>1){
            
            return true
        }else{
            return false
        }
        
    }
    
    
    
    
    func getXP(uid: String){
        let auth = Auth.auth();
        let db = Firestore.firestore();
        let docRef = db.collection("Users").document(uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                XP = document.data()?["XP"] as? Int ?? 0
                
                return
            } else {
                print("Document does not exist")
            }
            
            
            
        }
        
        
    }
    
    func getLevel(XP: Int) -> Int{
        
        return Int(XP / 100);
    }
    
    func getName(){
        let auth = Auth.auth();
        let db = Firestore.firestore();
        
        
        let uid = auth.currentUser!.uid
        let docRef = db.collection("Users").document(uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                name = document.data()?["firstName"] as? String ?? "waiting"
              
                
                return
            } else {
                print("Document does not exist")
            }
            name = document?.data()?["firstName"] as! String
            
            
        }
        

    }
    
    
    
   
    
    
}
