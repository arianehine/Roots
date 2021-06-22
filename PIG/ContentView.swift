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


class AppViewModel: ObservableObject{
    
    let auth = Auth.auth();
    
    
    func addUserInfo(fName: String, lName: String, email: String){
        let db = Firestore.firestore();
        db.collection("Users").document().setData(["firstName": fName, "lastName":lName, "email": email])
    
    }
    
    func signIn(email: String, password: String){
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else{
                self?.error = error!.localizedDescription
                print(error!.localizedDescription)
                self?.alert.toggle()
                return
            }
            
            //success
            //becuase it's a pushlished var we need to update on main thread
            DispatchQueue.main.async {
                self?.signedIn = true
            }
           
           
        }
        
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
                .setData([ "firstName":firstName, "lastName":lastName, "uid":uid, "email":email]);
            
            self!.setPledgesForUser(userId: result!.user.uid, db: db);
          
            
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
            .setData([ "ID":pledge.id, "description":pledge.description, "category":pledge.category, "imageName":pledge.imageName, "durationInDays":pledge.durationInDays, "startDate": pledge.startDate, "started": pledge.started, "endDate": pledge.endDate]);
        }
        
    }
    
    let pledges = [
        Pledge(id: 1, description: "Walk to work 2 days a week", category: "Transport", imageName: "figure.walk", durationInDays: 7, startDate: Date(), started: false, endDate: ""),
        Pledge(id: 2,description: "Drive only 3 days this week", category: "Transport", imageName: "car.fill", durationInDays: 7, startDate: Date(), started: false, endDate: ""),
        Pledge(id: 3, description: "Swap the car for the train", category: "Transport", imageName: "tram.fill",durationInDays: 7, startDate: Date(), started: false, endDate: ""),
        Pledge(id: 4, description: "Take 0 taxis this week", category: "Transport", imageName: "figure.wave",durationInDays: 7, startDate: Date(), started: false, endDate: ""),
        Pledge(id: 5, description: "Eat meat only once a week", category: "Food", imageName: "m.circle.fill",durationInDays: 7, startDate: Date(), started: false, endDate: ""),
        Pledge(id: 6, description: "Cut fish out of your diet for 2 weeks", category: "Food", imageName: "f.circle.fill",durationInDays: 7, startDate: Date(), started: false, endDate: ""),
        Pledge(id: 7, description: "Swap cow's milk for a non-dairy alternative for a week", category: "Food", imageName: "d.circle.fill",durationInDays: 7, startDate: Date(), started: false, endDate: ""),
        Pledge(id: 8, description: "leaf.fill", category: "Food", imageName: "d.circle.fill",durationInDays: 7, startDate: Date(), started: false, endDate: ""),
        Pledge(id: 9,description: "Eat vegan for a week", category: "Food", imageName: "leaf.fill",durationInDays: 7, startDate: Date(), started: false, endDate: ""),
        Pledge(id: 10,description: "Put your heating on a set timer!", category: "Household", imageName: "flame.fill",durationInDays: 7, startDate: Date(), started: false, endDate: ""),
        Pledge(id: 11, description: "Only fill the kettle for 1 cup when you boil it", category: "Household", imageName: "bolt.fill",durationInDays: 7, startDate: Date(), started: false, endDate: ""),
        Pledge(id: 12, description: "Don't buy any furniature for 4 month", category: "Household", imageName: "house.fill",durationInDays: 7, startDate: Date(), started: false, endDate: ""),
        Pledge(id: 13,description: "Turn lights off when you leave the room!", category: "Household", imageName: "lightbulb.fill",durationInDays: 7, startDate: Date(), started: false, endDate: ""),
        Pledge(id: 14,description: "Don't buy any fast fashion for 2 weeks", category: "Fashion", imageName: "hourglass",durationInDays: 7, startDate: Date(), started: false, endDate: ""),
        Pledge(id: 15, description: "Take a trip to the charity shop instead of buying new!", category: "Fashion", imageName: "arrow.3.trianglepath",durationInDays: 7, startDate: Date(), started: false, endDate: ""),
        Pledge(id: 16,description: "Download Depop and sell some of your own clothes!", category: "Fashion", imageName: "bag.circle.fill",durationInDays: 7, startDate: Date(), started: false, endDate: ""),
        Pledge(id: 17, description: "Sort thrugh your medidicnes at home, so you know how much you have!", category: "Health", imageName: "pills.fill",durationInDays: 7, startDate: Date(), started: false, endDate: "")
        
       

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
    @State var firebaseLogic = FirebaseLogic();
    @State var selection = ""
    @State var name = ""
    @State var originalReports: [Report] = [Report]();
    @State var reports: [Report] = [Report]();
    @State var originalPeople =  [UserData]();
    @State var pledgesInProgress = [Pledge]()
    
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
                        StatsView(ID: "6", originalPeople: originalPeople).environmentObject(statsController)
                            .tabItem {
                                VStack {
                                    Image(systemName: "chart.bar")
                                    Text("Stats") // Update tab title
                                }
                            }
                        .tag(0)
                        
                       
                        DoughnutView(ID: "6", reports: $reports, originalReports: $originalReports, originalPeople: originalPeople).environmentObject(statsController)
                            .font(.title)
                            .tabItem {
                                VStack {
                                    Image(systemName: "chart.pie")
                                    Text("Detailed Stats") // Update tab title
                                }
                        }
                        .tag(1)
                        
                        NumberEarthsView(ID: "6").environmentObject(statsController)
                            .tabItem {
                                VStack {
                                    Image(systemName: "person")
                                    Text("Info") // Update tab title
                                }
                            }
                        .tag(2)
                    
                    
                    
                        PledgesInProgress(
                        ).environmentObject(firebaseLogic)
                        .tabItem {
                            VStack {
                                Image(systemName: "hands.sparkles.fill")
                                Text("Pledges") // Update tab title
                            }
                        }
                    .tag(3)

                    
                    }
                
//                    getName()
                }.navigationBarTitle("Welcome back " +  name)
                .navigationBarItems(trailing:
                
                                        Button(action: {
                                            viewModel.signOut()
                                        }, label: {
                                            Text("Sign Out")
                                        }))
                .onAppear(){
                    getName()
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
    
    func getName(){
        let auth = Auth.auth();
        let db = Firestore.firestore();
        
        
        let uid = auth.currentUser!.uid
            let docRef = db.collection("Users").document(uid)

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    name = document.data()?["firstName"] as! String
                    print(name)
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
