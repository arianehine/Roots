//
//  PleadeConfirmation.swift
//  PIG
//
//  Created by ariane hine on 06/06/2021.
//

import SwiftUI

struct PleadeConfirmation: View {
    let pledgePicked: String
    var body: some View {
        Text("Commit to pledge: \(pledgePicked)").multilineTextAlignment(.center)
        Spacer()
        HStack{
            HStack{
                Text("Yes")
            Image(systemName: "person.fill.checkmark")
            }
            Spacer()
            HStack{
                Text("No")
            Image(systemName: "person.fill.xmark")
            }
        }
        
    }
}

struct PleadeConfirmation_Previews: PreviewProvider {
    static var previews: some View {
        PleadeConfirmation(pledgePicked: "Pledge")
    }
}
