//
//  ImproveView.swift
//  PIG
//
//  Created by ariane hine on 23/05/2021.
//

import SwiftUI

struct ImproveView: View {
    @StateObject var statsController = StatsDataController();
    @Binding var worstArea: String
    @Binding var reports: [Report]
    @Binding var sample: [ChartCellModel]
    @Binding var timePeriod: String 
    var body: some View {
        Text("\(worstArea) is your worst area").frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).navigationBarHidden(true)
    }
}

//struct ImproveView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImproveView(worstArea: "Preview")
//    }
//}
