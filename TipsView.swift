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
        Text("Tips to improve \(worstArea) :) ");
        whatToImprove(worstArea: worstArea)
        
        
    }
}

@ViewBuilder func whatToImprove(worstArea: String)-> some View{
    switch worstArea {
    case "Transport":
        Text("Transport")
    case "Food":
        Text("Food")
    case "Home":
        Text("Home")
    case "Fashion":
        Text("Fashion")
    case "Health":
        Text("Health")
    default:
        Text("Else")
    }
}

//struct TipsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TipsView("Travel")
//    }
//}
