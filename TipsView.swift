//
//  TipsView.swift
//  PIG
//
//  Created by ariane hine on 28/05/2021.
//

import SwiftUI

struct TipsView: View {
    @StateObject var statsController = StatsDataController();
    @Binding var worstArea: String
    var body: some View {
        Text("Tips to improve \(worstArea) :) ")
    }
}

//struct TipsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TipsView("Travel")
//    }
//}
