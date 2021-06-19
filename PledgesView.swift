//
//  PledgesView.swift
//  PIG
//
//  Created by ariane hine on 04/06/2021.
//

import SwiftUI
import FirebaseFirestore

struct PledgesView: View {
    
    let worstArea: String
    @State var selection: String? = nil
    @State var pledgesInProgress = [Pledge]()
    var body: some View {

                       Text("Select a pledge!")
                           .padding()
        let pledgeList = getListOfPledges(worstArea: worstArea)

                    List(pledgeList) {
                        pledge in
                        Spacer()
                        NavigationLink(destination: PledgesInProgress(
                                        pledgePicked: pledge)){
                            pledgeRow(pledge: pledge, worstArea: worstArea)

                    }
                    }
                    
        
    
        
    }
    
    func getListOfPledges(worstArea: String) -> [Pledge]{
       // setPledgesInFirestore(pledges: pledges)
        var returnPledges = [Pledge]()
        
        for pledge in pledges{
            if (pledge.category == worstArea){
                returnPledges.append(pledge)
        }
           
            
    }
        return returnPledges
    }
        

    
    

struct PledgesView_Previews: PreviewProvider {
    static var previews: some View {
        PledgesView(worstArea: "Household")
    }
}

}

func setPledgesInFirestore(pledges: [Pledge]){
    let db = Firestore.firestore();
    
    var counter = 0;
    for pledge in pledges {
        counter += 1
        db.collection("Pledges").document(String(pledge.id)).setData(["ID": pledge.id, "description": pledge.description, "category":pledge.category, "imageName": pledge.imageName, "durationInDays": pledge.durationInDays, "started": false, "startDate": pledge.startDate, "endDate": ""])
      
    }
    }
    
 
let pledges = [
    Pledge(id: 1, description: "Walk to work 2 days a week", category: "Transport", imageName: "figure.walk", durationInDays: 7),
    Pledge(id: 2,description: "Drive only 3 days this week", category: "Transport", imageName: "car.fill", durationInDays: 7),
    Pledge(id: 3, description: "Swap the car for the train", category: "Transport", imageName: "tram.fill",durationInDays: 7),
    Pledge(id: 4, description: "Take 0 taxis this week", category: "Transport", imageName: "figure.wave",durationInDays: 7),
    Pledge(id: 5, description: "Eat meat only once a week", category: "Food", imageName: "m.circle.fill",durationInDays: 7),
    Pledge(id: 6, description: "Cut fish out of your diet for 2 weeks", category: "Food", imageName: "f.circle.fill",durationInDays: 7),
    Pledge(id: 7, description: "Swap cow's milk for a non-dairy alternative for a week", category: "Food", imageName: "d.circle.fill",durationInDays: 7),
    Pledge(id: 8, description: "leaf.fill", category: "Food", imageName: "d.circle.fill",durationInDays: 7),
    Pledge(id: 9,description: "Eat vegan for a week", category: "Food", imageName: "leaf.fill",durationInDays: 7),
    Pledge(id: 10,description: "Put your heating on a set timer!", category: "Household", imageName: "flame.fill",durationInDays: 7),
    Pledge(id: 11, description: "Only fill the kettle for 1 cup when you boil it", category: "Household", imageName: "bolt.fill",durationInDays: 7),
    Pledge(id: 12, description: "Don't buy any furniature for 4 month", category: "Household", imageName: "house.fill",durationInDays: 7),
    Pledge(id: 13,description: "Turn lights off when you leave the room!", category: "Household", imageName: "lightbulb.fill",durationInDays: 7),
    Pledge(id: 14,description: "Don't buy any fast fashion for 2 weeks", category: "Fashion", imageName: "hourglass",durationInDays: 7),
    Pledge(id: 15, description: "Take a trip to the charity shop instead of buying new!", category: "Fashion", imageName: "arrow.3.trianglepath",durationInDays: 7),
    Pledge(id: 16,description: "Download Depop and sell some of your own clothes!", category: "Fashion", imageName: "bag.circle.fill",durationInDays: 7),
    Pledge(id: 17, description: "Sort thrugh your medidicnes at home, so you know how much you have!", category: "Health", imageName: "pills.fill",durationInDays: 7)
    
   

   ]


        struct pledgeRow: View {
            var pledge: Pledge
            var worstArea: String
            
            var body: some View {
                HStack{
                    Image(systemName: pledge.imageName)
                    Text(pledge.description).padding(.bottom)
                }.frame(maxWidth: .infinity, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(setTextColor(worstArea: worstArea), lineWidth: 4)).padding(.bottom)
                                }
                    
                }
    

public struct Pledge : Identifiable{
public var id: Int
var description: String
var category: String
var imageName: String
var durationInDays: Int
var startDate = Date()
var started: Bool = false;
var endDate: String = ""


}
