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
        db.collection("Users").document(uid).collection("logins").getDocuments { (snapshot, error) in
              guard let snapshot = snapshot, error == nil else {
               //handle error
               return
             }
           
             snapshot.documents.forEach({ (documentSnapshot) in
                 
                 
              let documentData = documentSnapshot.data()
              let date = documentData["date"] as? Timestamp
                dates.append(date!.dateValue())
              let dateConverted = Date(timeIntervalSince1970: TimeInterval(date!.seconds))
                if(Calendar.current.isDateInToday(dateConverted)){
               
                 
                }
                countStreak(dateArray: dates)
             })
         


           }

        
    }
    
    //inspiration from https://stackoverflow.com/questions/39334697/core-data-how-to-check-if-data-is-in-consecutive-dates
    func countStreak(dateArray: [Date]) {

        // The incoming parameter dateArray is immutable, so first make it mutable
        var mutableArray = dateArray

        // Next, sort the incoming array
        mutableArray.sort()

        var x = 0
        var numberOfConsecutiveDays = 1
        var streakArray = [Int]()

        // Cycle through the array, comparing the x and x + 1 elements
        while x + 1 < mutableArray.count {

            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: mutableArray[x], to: mutableArray[x + 1])

            // If the difference between the dates is greater than 1, append the streak to streakArray and reset the counter
            if abs(components.day!) > 1 {
                streakArray.append(numberOfConsecutiveDays)
                numberOfConsecutiveDays = 1
            }

            // If the difference between the days is exactly 1, add one to the current streak
            else if abs(components.day!) == 1 {
                numberOfConsecutiveDays += 1
            }

            x += 1
        }

        // Append the final streak to streakArray
        streakArray.append(numberOfConsecutiveDays)
        print(streakArray)

        // Return the user's longest streak
       streak = streakArray.max()!
    }
    
}




//struct StreaksView_Previews: PreviewProvider {
//    static var previews: some View {
//        StreaksView()
//    }
//}
