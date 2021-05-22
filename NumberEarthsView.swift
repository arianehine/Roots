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
    @State var numEarths : Int = 4;
    var body: some View {
        VStack{
        
            Text("If everyone were to live like you, we would need \(numEarths) Earths").font(.title)
            HStack{
                ForEach(0 ..< numEarths){_ in
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
            }
            }
        }
       
    }
}

struct NumberEarthsView_Previews: PreviewProvider {
    static var previews: some View {
        NumberEarthsView(ID: "8")
    }
}
