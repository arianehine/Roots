//
//  PledgesView.swift
//  PIG
//
//  Created by ariane hine on 04/06/2021.
//

import SwiftUI

struct PledgesView: View {
    
    let worstArea: String
    @State var selection: String? = nil
    var body: some View {

                       Text("Select a pledge!")
                           .padding().zIndex(1.0)
        let pledgeList = getListOfPledges(worstArea: worstArea)
                    List(pledgeList) {
                        pledge in
                        Spacer()
                        NavigationLink(destination: PleadeConfirmation(pledgePicked: $selection)) {
                            pledgeRow(pledge: pledge, worstArea: worstArea).onTapGesture {
                                selection = pledge.description
                            }
//                            }.onAppear {
//                                self.selection = nil
//                            }
                    }
                    }
    
        
    }
    
    func getListOfPledges(worstArea: String) -> [Pledge]{
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


    struct Pledge : Identifiable{
    var id = UUID()
    var description: String
    var category: String
    var imageName: String

}
let pledges = [
       Pledge(description: "Walk to work 2 days a week", category: "Transport", imageName: "figure.walk"),
    Pledge(description: "Drive only 3 days this week", category: "Transport", imageName: "car.fill"),
    Pledge(description: "Swap the car for the train", category: "Transport", imageName: "tram.fill"),
    Pledge(description: "Take 0 taxis this week", category: "Transport", imageName: "figure.wave"),
    Pledge(description: "Eat meat only once a week", category: "Food", imageName: "m.circle.fill"),
    Pledge(description: "Cut fish out of your diet for 2 weeks", category: "Food", imageName: "f.circle.fill"),
    Pledge(description: "Swap cow's milk for a non-dairy alternative for a week", category: "Food", imageName: "d.circle.fill"),
    Pledge(description: "leaf.fill", category: "Food", imageName: "d.circle.fill"),
    Pledge(description: "Eat vegan for a week", category: "Food", imageName: "leaf.fill"),
    Pledge(description: "Put your heating on a set timer!", category: "Household", imageName: "flame.fill"),
    Pledge( description: "Turn lights off when you leave the room", category: "Household", imageName: "bolt.fill"),
    Pledge(description: "Don't buy any furniature for 4 month", category: "Household", imageName: "house.fill"),
    Pledge(description: "Turn lights off when you leave the room!", category: "Household", imageName: "lightbulb.fill"),
    Pledge(description: "Don't buy any fast fashion for 2 weeks", category: "Fashion", imageName: "hourglass"),
    Pledge(description: "Take a trip to the charity shop instead of buying new!", category: "Fashion", imageName: "arrow.3.trianglepath"),
    Pledge(description: "Download Depop and sell some of your own clothes!", category: "Fashion", imageName: "bag.circle.fill"),
    Pledge(description: "Sort thrugh your medidicnes at home, so you know how much you have!", category: "Health", imageName: "pills.fill"),
    
   

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
    
}
