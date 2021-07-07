//
//  StreaksView.swift
//  PIG
//
//  Created by ariane hine on 01/07/2021.
//

import SwiftUI
import Firebase
import FirebaseAuth
import WrappingHStack
import FirebaseFirestore


struct StreaksView: View {
    let uid: String;
    @State var streak = 0;
    var body: some View {
        VStack{
        Text("Daily Login Tracker:").font(.title)
            Spacer()
        Text("You have a streak of: \(streak) days")
            
            WrappingHStack(0..<streak, id:\.self, alignment: .center) { index in
                Group{
                    
                    Image(systemName: "star.fill").resizable().foregroundColor(.yellow)
                           .frame(width: 50, height: 50, alignment: .center);
                       
                      
                    }
               
                }
            Spacer()
            
            
            
        }.onAppear(){
            getStreak(uid: uid);
        }
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
                
                    self.streak = document.data()?["currentStreak"] as! Int
                    print(self.streak)
        return
                   
                } else {
                    print("Document does not exist")
                }
                
                self.streak = document!.data()?["currentStreak"] as! Int

            }
        
    }
    
    //inspiration from https://stackoverflow.com/questions/39334697/core-data-how-to-check-if-data-is-in-consecutive-dates
 


}


//struct StreaksView_Previews: PreviewProvider {
//    static var previews: some View {
//        StreaksView()
//    }
//}

