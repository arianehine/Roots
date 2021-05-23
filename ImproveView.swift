//
//  ImproveView.swift
//  PIG
//
//  Created by ariane hine on 23/05/2021.
//

import SwiftUI

struct ImproveView: View {
    @Binding var worstArea: String
    var body: some View {
        Text("\(worstArea) is your worst area")
    }
}

//struct ImproveView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImproveView(worstArea: "Preview")
//    }
//}
