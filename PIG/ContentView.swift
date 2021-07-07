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


class AppViewModel: ObservableObject{
    @State var statsController: StatsDataController
    @State var directory: URL
    let auth = Auth.auth();
    @State var fbLogic: FirebaseLogic
   
    
    func addUserInfo(fName: String, lName: String, email: String){
        let db = Firestore.firestore();
        db.collection("Users").document().setData(["firstName": fName, "lastName":lName, "email": email, "XP": 0])
        
        let uid = auth.currentUser!.uid
        
        let date = Date()
        db.collection("Users").document(uid).collection("logins").document(dateToString(date: date)).setData(["date": date])
        
    
    }
    
    func signIn(email: String, password: String){
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else{
                self?.error = error!.localizedDescription
                let db = Firestore.firestore();
                self?.alert.toggle()
                let uid = self!.auth.currentUser!.uid
                let date = Date()
                db.collection("Users").document(uid).collection("logins").document(self!.dateToString(date: date)).setData(["date": date])
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
    
    func signUp(email: String, password: String, firstName: String, lastName:String){
        auth.createUser(withEmail: email, password: password) { [weak self] (result, error) in
            
            guard result != nil, error == nil else{
                self?.error = error!.localizedDescription
                self?.alert.toggle()
                return
               
            }
            
            //success
            //becuase it's a pushlished var we need to update on main thread
            let db = Firestore.firestore()

                           let uid = result!.user.uid


                           //creates profile doc under uid with all the info
            db.collection("Users").document(result!.user.uid)
                .setData([ "firstName":firstName, "lastName":lastName, "uid":uid, "email":email, "currentStreak": 0, "longestStreak":0]);
            
  
            let date = Date()
            db.collection("Users").document(uid).collection("logins").document(self!.dateToString(date: date)).setData(["date": date])
            
            self!.setPledgesForUser(userId: result!.user.uid, db: db);
            self!.setDataForUser(userId: result!.user.uid, db: db, statsController: self!.statsController);
          
            
            DispatchQueue.main.async {
                self?.signedIn = true
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
                .setData([ "ID":pledge.id, "description":pledge.description, "category":pledge.category, "imageName":pledge.imageName, "durationInDays":pledge.durationInDays, "startDate": pledge.startDate, "completed": false, "daysCompleted": 0,"started": pledge.started, "endDate": pledge.endDate, "XP": pledge.XP]);
        }
        
    }
 
    func setDataForUser(userId: String, db: Firestore, statsController: StatsDataController){
        
        let userData = statsController.convertCSVIntoArray(directory: directory)

        for user in userData{
            if(user.ID == "8"){
            var stringDate = dateToString(date: user.date)
            db.collection("UserData").document(userId).collection("Data").document(stringDate)
                .setData([ "ID": userId, "date": user.date, "average": user.average, "transport": user.transport, "household": user.household, "clothing": user.clothing, "health": user.health, "food": user.food, "transport_walking": user.transport_walking, "transport_car": user.transport_car, "transport_train": user.transport_train,"transport_plane": user.transport_plane, "transport_bus": user.transport_bus, "household_heating": user.household_heating,"household_electricity": user.household_electricity,"household_furnishings": user.household_furnishings,"household_lighting": user.household_lighting,"clothing_fastfashion": user.clothing_fastfashion,"clothing_sustainable": user.clothing_sustainable,"health_meds": user.health_meds,"health_scans": user.health_scans, "food_meat": user.food_meat,"food_fish": user.food_fish,"food_dairy": user.food_dairy,"food_oils": user.food_oils]);
        }
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


    
    let pledges = [
        Pledge(id: 1, description: "Walk to work", category: "Transport", imageName: "figure.walk", durationInDays: 7, startDate: Date(), started: false, completed: false, daysCompleted: 0, endDate: "", XP: 70),
        Pledge(id: 2,description: "Swap the car for walking", category: "Transport", imageName: "car.fill", durationInDays: 7, startDate: Date(), started: false, completed: false, daysCompleted: 0,endDate: "", XP: 70),
        Pledge(id: 3, description: "Swap the car for the train", category: "Transport", imageName: "tram.fill",durationInDays: 7, startDate: Date(), started: false, completed: false, daysCompleted: 0,endDate: "", XP: 70),
        Pledge(id: 4, description: "Take 0 taxis", category: "Transport", imageName: "figure.wave",durationInDays: 7, startDate: Date(), started: false,completed: false, daysCompleted: 0, endDate: "", XP: 70),
        Pledge(id: 5, description: "Cut out dairy", category: "Food", imageName: "m.circle.fill",durationInDays: 7, startDate: Date(), started: false, completed: false, daysCompleted: 0,endDate: "", XP: 70),
        Pledge(id: 6, description: "Cut fish out of your dairy", category: "Food", imageName: "f.circle.fill",durationInDays: 7, startDate: Date(), started: false,completed: false, daysCompleted: 0, endDate: "", XP: 70),
        Pledge(id: 7, description: "Swap cow's milk for a non-dairy alternative", category: "Food", imageName: "d.circle.fill",durationInDays: 7, startDate: Date(), started: false, completed: false, daysCompleted: 0,endDate: "", XP: 70),
        Pledge(id: 8, description: "Eat vegetarian ", category: "Food", imageName: "d.circle.fill",durationInDays: 7, startDate: Date(), started: false, completed: false, daysCompleted: 0,endDate: "", XP: 70),
        Pledge(id: 9,description: "Eat vegan", category: "Food", imageName: "leaf.fill",durationInDays: 7, startDate: Date(), started: false, completed: false, daysCompleted: 0,endDate: "", XP: 70),
        Pledge(id: 10,description: "Put your heating on a set timer!", category: "Household", imageName: "flame.fill",durationInDays: 7, startDate: Date(), started: false, completed: false, daysCompleted: 0,endDate: "", XP: 70),
        Pledge(id: 11, description: "Only fill the kettle for 1 cup when you boil it", category: "Household", imageName: "bolt.fill",durationInDays: 7, startDate: Date(), started: false, completed: false, daysCompleted: 0,endDate: "", XP: 70),
        Pledge(id: 12, description: "Don't buy any furniature", category: "Household", imageName: "house.fill",durationInDays: 7, startDate: Date(), started: false,completed: false, daysCompleted: 0, endDate: "", XP: 70),
        Pledge(id: 13,description: "Turn lights off when you leave the room!", category: "Household", imageName: "lightbulb.fill",durationInDays: 7, startDate: Date(), started: false,completed: false, daysCompleted: 0, endDate: "", XP: 70),
        Pledge(id: 14,description: "Don't buy any fast fashion", category: "Fashion", imageName: "hourglass",durationInDays: 7, startDate: Date(), started: false,completed: false, daysCompleted: 0, endDate: "", XP: 70),
        Pledge(id: 15, description: "Take a trip to the charity shop instead of buying new!", category: "Fashion", imageName: "arrow.3.trianglepath",durationInDays: 7, startDate: Date(), started: false, completed: false, daysCompleted: 0,endDate: "", XP: 70),
        Pledge(id: 16,description: "Download Depop and sell some of your own clothes!", category: "Fashion", imageName: "bag.circle.fill",durationInDays: 7, startDate: Date(), started: false, completed: false, daysCompleted: 0,endDate: "", XP: 70),
        Pledge(id: 17, description: "Sort thrugh your medidicnes at home, so you know how much you have!", category: "Health", imageName: "pills.fill",durationInDays: 7, startDate: Date(), started: false,completed: false, daysCompleted: 0, endDate: "", XP: 70)
        
       

       ]
    
    //Whenever a published var chages we can update view automatically in real time, because it's a binding
    @Published var signedIn = false
    @Published var alert = false;
    @Published var error = ""
    
    var isSignedIn: Bool{
        return auth.currentUser != nil
        
    }
    
    
    
}


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
    var body: some View {
        NavigationView{


            
            if viewModel.signedIn{
             
               

                VStack{
//
//                Text("You are signed in")
//                    .padding()
//                Button(action: {
//                    viewModel.signOut()
//                }, label: {
//                    Text("Sign Out")
//                        .frame(width: 200, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                        .background(Color.green)
//                        .foregroundColor(Color.blue)
//                        .padding()
//                })
                    TabView(selection: $selection){
                        StatsView(ID: "6", originalPeople: originalPeople, fbLogic: $fbLogic, selection: selection).environmentObject(statsController)
                            .tabItem {
                                VStack {
                                    Image(systemName: "chart.bar")
                                    Text("Stats") // Update tab title
                                }
                            }
                        .tag(0)
                        
                       
                        DoughnutView(ID: "6", selection: selection, reports: $reports, originalReports: $originalReports, originalPeople: originalPeople).environmentObject(statsController)
                            .font(.title)
                            .tabItem {
                                VStack {
                                    Image(systemName: "chart.pie")
                                    Text("Detailed Stats") // Update tab title
                                }
                        }
                        .tag(1)
                        
                        StreaksView(uid: auth.currentUser!.uid)
                            .tabItem {
                                VStack {
                                    Image(systemName: "star.fill")
                                    Text("Streaks") // Update tab title
                                }
                            }
                        .tag(2)

                    
                    
                        PledgesInProgress(
                        ).environmentObject(fbLogic)
                        .tabItem {
                            VStack {
                                Image(systemName: "hands.sparkles.fill")
                                Text("Pledges") // Update tab title
                            }
                        }
                    .tag(3)

                    
                    
//                    MapView()
//                    .tabItem {
//                        VStack {
//                            Image(systemName: "network")
//                            Text("Map") // Update tab title
//                        }
//                    }
//                .tag(4)

                
                }
                
//                    getName()
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
                }
              
                //replace with app logic
            }else{
                
                SignInView()
                    .navigationBarHidden(true)
            }

        }.onAppear{
    
            viewModel.signedIn = viewModel.isSignedIn;
            viewModel.alert=false
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
                
                    streak = document.data()?["currentStreak"] as! Int
        
                 
                } else {
                    print("Document does not exist")
                }
                
                streak = document!.data()?["currentStreak"] as! Int

            
        
        if(streak == 0){
            print("SET IT TO 1")
            db.collection("Users").document(uid).updateData(["currentStreak": 1])
            fbLogic.incrementUserXP(amount: 10, uid: uid)
            message = "No streak. Log in tomorrow to get one! +10XP"
            print("increment by 10")
            toastShow = true;
            db.collection("Users").document(uid).collection("logins").document(dateToString(date: date)).setData(["date": date])
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
                print(dateConverted)
                  if(!(Calendar.current.isDateInToday(dateConverted))){
                    if(Calendar.current.isDateInYesterday(dateConverted)){
                        print("continue streak")
                        db.collection("Users").document(uid).updateData(["currentStreak": FieldValue.increment(Int64(1))])
                        fbLogic.incrementUserXP(amount: ((streak+1)*10), uid: uid)
                        message = "Congrats, you have a \(streak) day streak. + \((streak) * 10)XP"
                        print("increment by streak")
                        toastShow = true;
                        db.collection("Users").document(uid).collection("logins").document(dateToString(date: date)).setData(["date": date])
                    }else{
                        print("start new streak")
                        db.collection("Users").document(uid).updateData(["currentStreak": 1])
                        fbLogic.incrementUserXP(amount: 10, uid: uid)
                        message = "No streak. Log in tomorrow to get one! +10XP"
                        print("increment by 10")
                        toastShow = true;
                        db.collection("Users").document(uid).collection("logins").document(dateToString(date: date)).setData(["date": date])
                    }
                    
                 
                   
                  }else{
                    print("logged in today, so no increase");
                    db.collection("Users").document(uid).collection("logins").document(dateToString(date: date)).setData(["date": date])
                  }
            }
            
            
            
        }

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
                    print(document.data())
           
                       return
                   } else {
                       print("Document does not exist")
                   }
                   name = document?.data()?["firstName"] as! String
                   
                 
               }
          
       
           
         
           }
       
       
    
    struct SignInView: View {
        @State var email = ""
        @State var password = ""
        @EnvironmentObject var viewModel: AppViewModel
       
        var body: some View {
          
            VStack{
                if viewModel.alert{
                 
                    
                    ErrorView(alert: $viewModel.alert, error: $viewModel.error)
              
                    
                }else{
                  //no errors
                    
                }
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                VStack{
                    TextField("Email Address", text: $email)
                        .disableAutocorrection(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    
                    
                    SecureField("Password", text: $password)
                        .disableAutocorrection(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    
                    Button(action:{
                    
                        
                        viewModel.signIn(email: email, password: password)
                        guard !email.isEmpty, !password.isEmpty else{
                            return
                        }
                    }, label: {
                        Text("Sign In")
                            .foregroundColor(Color.white)
                            .frame(width: 200, height: 50, alignment: .center)
                            .cornerRadius(20)
                            .background(Color.blue)
                        
                    })
                    
                    NavigationLink("Create Account", destination: SignUpView())
                        .padding()
                    
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Sign In")
            .onAppear(){
                viewModel.alert=false
            }
        }
        
    }
    
    struct SignUpView: View {
        @State var email = ""
        @State var password = ""
        @State var firstName = ""
        @State var lastName = ""
        @EnvironmentObject var viewModel: AppViewModel
        
        var body: some View {
            
            VStack{
                
                if viewModel.alert{
                 
                    
                    ErrorView(alert: $viewModel.alert, error: $viewModel.error)
              
                }
            
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150, alignment: .center)
                
                VStack{
                 
                    TextField("First Name", text: $firstName)
                        .disableAutocorrection(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    TextField("Last Name", text: $lastName)
                        .disableAutocorrection(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    TextField("Email Address", text: $email)
                        .disableAutocorrection(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    SecureField("Password", text: $password)
                        .disableAutocorrection(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    
                    Button(action:{
                        
//                        viewModel.addUserInfo(fName: self.firstName, lName: self.lastName, email: self.email)
//                        guard !email.isEmpty, !password.isEmpty else{
//                            return}
                    
//
                        viewModel.signUp(email: email, password: password, firstName: firstName, lastName: lastName)
                        guard !email.isEmpty, !password.isEmpty else{
                            return
                        
                        }
                        
                        
                       
                    }, label: {
                        Text("Create Account")
                            .foregroundColor(Color.white)
                            .frame(width: 200, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .cornerRadius(20)
                            .background(Color.blue)
                        
                    })
                    
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Create Account")
            .onAppear(){
                viewModel.alert=false
            }
        }
        
    }
//    struct ContentView_Previews: PreviewProvider {
//        static var previews: some View {
//            ContentView(statsController: statsController)
//        }
//    }
//
    struct ErrorView : View {
        
        @State var color = Color.black.opacity(0.7)
        @Binding var alert : Bool
        @Binding var error : String
        
        var body: some View{
            
                
                VStack{
                    
                    HStack{
                        Text(self.error).foregroundColor(Color.red)
                    }
                }
            }
    }

}
