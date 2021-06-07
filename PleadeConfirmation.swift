//
//  PleadeConfirmation.swift
//  PIG
//
//  Created by ariane hine on 06/06/2021.
//

import SwiftUI

struct PleadeConfirmation: View {
    @Binding var pledgePicked:String?
    var body: some View {
        Text("Commit to pledge: \(pledgePicked ?? "none selected")").multilineTextAlignment(.center)
        Spacer()
        HStack{
            HStack{
                NavigationLink(destination: NumberEarthsView(ID: "8")) {
                Text("Yes")
            Image(systemName: "person.fill.checkmark").foregroundColor(Color(.green))
                }
            }
            Spacer()
            HStack{
             
                Text("No")
                Image(systemName: "person.fill.xmark").foregroundColor(Color(.red))
          
            }
        }
        
    }
}

//struct PleadeConfirmation_Previews: PreviewProvider {
//    static var previews: some View {
//        PleadeConfirmation(pledgePicked: "Pledge")
//    }
//}
