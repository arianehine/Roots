//
//  PledgeUpdate.swift
//  PIG
//
//  Created by ariane hine on 25/06/2021.
//

import SwiftUI
import FirebaseAuth

struct PledgeUpdate: View {
    @State var pledgeToUpdate: Pledge
    @State var fbLogic: FirebaseLogic = FirebaseLogic();
    @State var toastShow: Bool = false
    @State var goBack = false
    @State var auth = Auth.auth();
    @State var message = ""
    var body: some View {
        VStack{
        Text("Track activity for pledge").font(.title2)
        Text("Pledge: \(pledgeToUpdate.description)")
        Text("Days until finished: \(pledgeToUpdate.durationInDays - pledgeToUpdate.daysCompleted)")
        //TODO: make sure this can only be done once every day
    
        Button(action: {
            
            updatePledge(pledgeToUpdate: pledgeToUpdate, daysCompleted: pledgeToUpdate.daysCompleted, durationInDays: pledgeToUpdate.durationInDays)

            toastShow = true
            
          
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    goBack = true
                       }
           
            
        }) {
            
        Text("+1 to pledge count").padding(.vertical).padding(.horizontal,25).foregroundColor(.white)
        }.toast(isPresenting: $toastShow, message: getMessage(pledgeToUpdate: pledgeToUpdate, daysCompleted: pledgeToUpdate.daysCompleted, durationInDays: pledgeToUpdate.durationInDays))
        .background(LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1")]), startPoint: .leading, endPoint: .trailing))
        .clipShape(Capsule())

    
    }
        .background(
            VStack{
                NavigationLink(destination: PledgesInProgress(), isActive: $goBack) {
                            
                        }
            .hidden()
            }
    )
    }
    func getMessage(pledgeToUpdate: Pledge, daysCompleted: Int, durationInDays: Int) -> String{
       return message
        }
    
    //TODO IMPLEMENT THIS
    func updatePledge(pledgeToUpdate: Pledge, daysCompleted: Int, durationInDays: Int){
        auth = Auth.auth()
        
       self.fbLogic.incrementPledgeCompletedDays(pledge: pledgeToUpdate, uid: auth.currentUser!.uid){ (isSucceeded) in
            if !isSucceeded {
  
                message = "Oops, come back tomorrow to track progress for this pledge"
            } else {

                if((daysCompleted+1) == durationInDays){
                    self.fbLogic.incrementPledgeCompletedDays2(pledge: pledgeToUpdate, uid: auth.currentUser!.uid)
                    self.fbLogic.incrementUserXP(pledge: pledgeToUpdate, uid: auth.currentUser!.uid);
                    
               message =  "Yay, you've completed this pledge. + \(pledgeToUpdate.XP) XP "
                }else{
                    self.fbLogic.incrementPledgeCompletedDays2(pledge: pledgeToUpdate, uid: auth.currentUser!.uid)
                  message = "Well done! Only \(durationInDays - (daysCompleted+1)) days until you are finished"
                }
                
             
            }
     
        
    }
}
}


//struct PledgeUpdate_Previews: PreviewProvider {
//    static var previews: some View {
//        PledgeUpdate()
//    }
//

