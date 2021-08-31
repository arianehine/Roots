//
//  SignInView.swift
//  SignInView
//
//  Created by Ariane Hine on 28/07/2021.
//

import Foundation
import SwiftUI
//View used to sign in to an exisiting account
struct SignInView: View {
    @State var email = ""
    @State var password = ""
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        
        VStack{
            if viewModel.alert{
                //Show an error if there is an issue with the credentials
                ErrorView(alert: $viewModel.alert, error: $viewModel.error)
                
            }
            Text("Roots \n").font(.title).fontWeight(.bold)
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
                
                NavigationLink("Create Account", destination: SignUpView().environmentObject(viewModel))
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


