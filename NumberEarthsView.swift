//
//  NumberEarthsView.swift
//  PIG
//
//  Created by ariane hine on 22/05/2021.
//

import SwiftUI
import WrappingHStack

struct NumberEarthsView: View {
    let ID: String
    //    @Binding var reports: [Report]
    //    @Binding var originalReports: [Report]
    @EnvironmentObject var statsController: StatsDataController
    @State var numEarths : Int = 7;
    var body: some View {
        VStack{
            Text("If everyone were to live like you, we would need \(numEarths) Earths").font(.title).frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).multilineTextAlignment(.center)
            WrappingHStack(0..<numEarths, id:\.self, alignment: .center) { _ in
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 89, alignment: .center)
            }
            
            
        }
       
    }
}

struct NumberEarthsView_Previews: PreviewProvider {
    static var previews: some View {
        NumberEarthsView(ID: "8")
    }
}
