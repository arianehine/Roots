//
//  PleadeConfirmation.swift
//  PIG
//
//  Created by ariane hine on 06/06/2021.
//

import SwiftUI

struct PleadeConfirmation: View {
    var pledgePicked:String?
    @Environment(\.presentationMode) var presentationMode
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
          
            }.frame(height: 64)
            .onTapGesture {
                // set item.code & success flag to some view model and then
                // just call dismiss to return to ViewA
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        
    }
}

//struct PleadeConfirmation_Previews: PreviewProvider {
//    static var previews: some View {
//        PleadeConfirmation(pledgePicked: "Pledge")
//    }
//}
