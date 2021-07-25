//
//  PledgesView.swift
//  PIG
//
//  Created by ariane hine on 04/06/2021.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct PledgesView: View {
    let auth = Auth.auth();
    let worstArea: String
    @State var selection: String? = nil
    @State var pledgesInProgress =
    [Pledge]()
    @State var statsController: StatsDataController
    @EnvironmentObject var fbLogic: FirebaseLogic
    var body: some View {

                       Text("Select a pledge!")
                           .padding()
        let pledgeList = fbLogic.pledgesForArea
                    List(pledgeList) {
                        pledge in
                        Spacer()
                        NavigationLink(destination: PleadeConfirmation(
                                        pledgePicked: pledge, statsController: statsController).environmentObject(fbLogic)){
                            pledgeRow(pledge: pledge, worstArea: worstArea)

                    }
                    }.onAppear(perform: initVars)
                    
        
       
    }
    func initVars(){
      
        fbLogic.allPledges = fbLogic.getAllPledges()
        fbLogic.allPledges = fbLogic.getAllPledges()
        fbLogic.pledgesForArea = fbLogic.getPledgesToChooseFromArea(chosenArea: worstArea)
    }
//    func getListOfPledges(worstArea: String) -> [Pledge]{
//       // setPledgesInFirestore(pledges: pledges)
//        var returnPledges = [Pledge]()
//
//        returnPledges = fbLogic.getPledgesToChooseFromArea(chosenArea: worstArea);
//        return returnPledges;
//    }
//
//
//
//

//struct PledgesView_Previews: PreviewProvider {
//    static var previews: some View {
//        PledgesView(worstArea: "Household")
//    }
//}

}

//func setPledgesInFirestore(pledges: [Pledge]){
//    let db = Firestore.firestore();
//
//    var counter = 0;
//    for pledge in pledges {
//        counter += 1
//        db.collection("Pledges").document(String(pledge.id)).setData(["ID": pledge.id, "description": pledge.description, "category":pledge.category, "imageName": pledge.imageName, "durationInDays": pledge.durationInDays, "started": false, "startDate": pledge.startDate, "endDate": ""])
//
//    }
//    }
    
 



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
var startDate: Date
var started: Bool
var completed: Bool
var daysCompleted: Int
var endDate: String
var XP: Int
var notifications: Bool
var reductionPerDay: Int


}
