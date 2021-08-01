//
//  SelectFootprint.swift
//  SelectFootprint
//
//  Created by Ariane Hine on 01/08/2021.
//

import SwiftUI
import Firebase

struct SelectFootprint: View {
    
    @State var transition = false;
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
        VStack{
            if (transition) {
                ContentView(directory: directory, fbLogic: fbLogic, originalPeople: originalPeople)
                    .environmentObject(viewModel)
                    .environmentObject(statsController)
                    .environmentObject(fbLogic)
                    .preferredColorScheme(.dark)
            }else{
                
            
            
        Text("Select one of the following").font(.title)
        Text("I am a:")
        Button(action: {
            selection = "low"
            
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                transition = true;
            }
           
           
        }) {
            
            Text("Low carbon user").padding(.vertical).padding(.horizontal,25).foregroundColor(.white)
            
        }.padding()
        .background(
           
           
            Color.green
        
        )
       .clipShape(Capsule())
            Text("e.g no long haul flights, vegetarian, do not drive").padding()
            Spacer()
            Button(action: {
                
           
            selection = "average"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    transition = true;
                }
            }) {
                
                Text("Medium carbon user").padding(.vertical).padding(.horizontal,25).foregroundColor(.white)
                
            }.padding()
            .background(
               
               
                Color.orange
            
            )
           .clipShape(Capsule()).padding()
            Text("e.g meat sometimes, drive short distances, recycle ")
            Spacer()
            Button(action: {
                
           
               selection = "high"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    transition = true;
                }
            }) {
                
                Text("High carbon user").padding(.vertical).padding(.horizontal,25).foregroundColor(.white)
                
            }.padding()
            .background(
               
               
                Color.red
            
            )
           .clipShape(Capsule()).padding()
            
            Text("e.g meat often, travel often, heats a large home")
                    }
        }
    }
    }




//struct SelectFootprint_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectFootprint()
//    }
//}
