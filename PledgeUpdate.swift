//
//  PledgeUpdate.swift
//  PIG
//
//  Created by ariane hine on 25/06/2021.
//

import SwiftUI

struct PledgeUpdate: View {
    @State var pledgeToUpdate: Pledge
    @State var fbLogic: FirebaseLogic = FirebaseLogic();
    var body: some View {
        Text("Update pledges here")
        
        //TODO: make sure this can only be done once every day
        Button(action: {
            
            updatePledge(pledgeToUpdate: pledgeToUpdate)
            
        }) {
            
        Text("+1 to pledge count").padding(.vertical).padding(.horizontal,25).foregroundColor(.white)
        }
        .background(LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1")]), startPoint: .leading, endPoint: .trailing))
        .clipShape(Capsule())
    }
    
    //TODO IMPLEMENT THIS
    func updatePledge(pledgeToUpdate: Pledge){
        self.fbLogic.incrementPledgeCompletedDays(pledge: pledgeToUpdate);
        
    }
}

//struct PledgeUpdate_Previews: PreviewProvider {
//    static var previews: some View {
//        PledgeUpdate()
//    }
//}
