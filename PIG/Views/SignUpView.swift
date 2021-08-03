//
//  SignUpView.swift
//  SignUpView
//
//  Created by Ariane Hine on 28/07/2021.
//

import Foundation
import SwiftUI


struct SignUpView: View {
    @State var email = ""
    @State var password = ""
    @State var firstName = ""
    @State var lastName = ""
    @State var personalDetailsEntered = false
    @State var transition = false;
    @State var selected = ""
    @State var footprint = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        
        VStack{
            
            if viewModel.alert{
                
                
                ErrorView(alert: $viewModel.alert, error: $viewModel.error)
                
            }
            if (personalDetailsEntered) {
                SelectFootprint(transition: $transition, selection: $selected)
                    .environmentObject(viewModel)
                .preferredColorScheme(.dark);            }else{
            
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
                    
                    
                    
                    self.personalDetailsEntered = true
                    
                    
                    
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
        }
        .navigationTitle("Create Account")
        .onAppear(){
            viewModel.alert=false
        }.onChange(of: transition){ value in
            if (value) {
                
                print("selection: ", selected)
                viewModel.signUp(email: email, password: password, firstName: firstName, lastName: lastName, selection: selected)
                viewModel.footprint = selected
        
                print("signed up")
                guard !email.isEmpty, !password.isEmpty else{
                    print("error")
                    return
                 
                    
                  
                    
                    
                }
              
                
            }
        }
    }
    
}
