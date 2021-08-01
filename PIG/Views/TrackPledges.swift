//
//  TrackPledges.swift
//  PIG
//
//  Created by ariane hine on 25/06/2021.
//

import SwiftUI

struct TrackPledges: View {
    @State var selectedForFurtherInfo: Pledge
    @State var trackPledge = false
    @State var statsController: StatsDataController
    var body: some View {
        
        VStack{
            if (trackPledge) {
                PledgeUpdate(pledgeToUpdate: selectedForFurtherInfo, statsController: statsController)
            }else{
        Text("Pledge: \(selectedForFurtherInfo.description)")
        Text("Goal: \(selectedForFurtherInfo.durationInDays) days")
        Text("Days completed: \(selectedForFurtherInfo.daysCompleted)")
        Spacer();
            
            Button(action: {
      
                self.trackPledge = true
                print("true")
                
                
            }) {
                
            Text("Track pledge activity?").padding(.vertical).padding(.horizontal,25).foregroundColor(.white)
            }
            .background(LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1")]), startPoint: .leading, endPoint: .trailing))
            .clipShape(Capsule())
            
            Spacer()
        }
        }
        
        
    }
}


//
//struct TrackPledges_Previews: PreviewProvider {
//    static var previews: some View {
//        TrackPledges()
//    }
//}
