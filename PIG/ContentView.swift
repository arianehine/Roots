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
import FirebaseAuth

class AppViewModel: ObservableObject{
    
    let auth = Auth.auth();
    
    func signIn(email: String, password: String){
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else{
                return
            }
            
            //success
            //becuase it's a pushlished var we need to update on main thread
            DispatchQueue.main.async {
                self?.signedIn = true
            }
           
        }
        
    }
    
    func signUp(email: String, password: String){
        auth.createUser(withEmail: email, password: password) { [weak self] (result, error) in
            guard result != nil, error == nil else{
                return
            }
            
            //success
            //becuase it's a pushlished var we need to update on main thread
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
        
    }
    
    func signOut(){
        try? auth.signOut()
        self.signedIn=false;
    }
    //Whenever a published var chages we can update view automatically in real time, because it's a binding
    @Published var signedIn = false
    
    var isSignedIn: Bool{
        return auth.currentUser != nil
        
    }
    
    
}

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State var selection = ""
    
    var body: some View {
        NavigationView{
            if viewModel.signedIn{
                VStack{
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
                        Text("First View")
                            .font(.title)
                            .tabItem {
                                VStack {
                                    Image(systemName: "globe")
                                    Text("Categories") // Update tab title
                                }
                        }
                        .tag(0)
                        Text("Second View")
                            .font(.title)
                            .tabItem {
                                VStack {
                                    Image(systemName: "person")
                                    Text("Profile") // Update tab title
                                }
                        }
                        .tag(1)
                    }
                }
                
            
                //replace with app logic
            }else{
                SignInView()
            }
        }.onAppear{
    
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
    
    
    struct SignInView: View {
        @State var email = ""
        @State var password = ""
        @EnvironmentObject var viewModel: AppViewModel
        
        var body: some View {
            
            VStack{
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
                            .frame(width: 200, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
        }
        
    }
    
    struct SignUpView: View {
        @State var email = ""
        @State var password = ""
        @EnvironmentObject var viewModel: AppViewModel
        
        var body: some View {
            
            VStack{
                Image("logo-1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150, alignment: .center)
                
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
                        
                        viewModel.signUp(email: email, password: password)
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
        }
        
    }
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
