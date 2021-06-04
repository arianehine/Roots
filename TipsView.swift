//
//  TipsView.swift
//  PIG
//
//  Created by ariane hine on 28/05/2021.
//

import SwiftUI

struct TipsView: View {
    @State var statsController: StatsDataController
    @Binding var worstArea: String
    var body: some View {
        Text("Tips to improve \(worstArea) :) ");
        whatToImprove(worstArea: worstArea)

        NavigationLink(destination: PledgesView()) {
            ButtonView(worstArea: worstArea)
                  }
        
    
        
        
        
    }

struct ButtonView: View {
    let worstArea: String
    var body: some View {
        
       
    Text("Ready to improve \(worstArea)?").padding(.vertical).padding(.horizontal,25).foregroundColor(.white)
    .background(LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1")]), startPoint: .leading, endPoint: .trailing))
    .clipShape(Capsule())
}
}


@ViewBuilder func whatToImprove(worstArea: String)-> some View{
    switch worstArea {
    case "Transport":
        VStack{
        Text("Transport")
        }
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
}

//struct TipsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TipsView("Travel")
//    }
//}
