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
        Spacer()
        whatToImprove(worstArea: worstArea)

        NavigationLink(destination: PledgesView(worstArea: worstArea)) {
            ButtonView(worstArea: worstArea)
                  }
        
    
        
        
        
    }

struct ButtonView: View {
    let worstArea: String
    var body: some View {
        
       
        Text("Ready to improve \(worstArea)?").padding(.vertical).padding(.horizontal,25).foregroundColor(.white).font(.body)
        .background(LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1")]), startPoint: .leading, endPoint: .trailing).frame(width: 300, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/))
    .clipShape(Capsule())
}
}


@ViewBuilder func whatToImprove(worstArea: String)-> some View{
    switch worstArea {
    case "Transport":
        VStack{
            Text("Swap the car for a bike ride every Monday!")
            Spacer()
            Text("If the journey will take less than 20 minutes to walk it, walk it")
        
            Spacer()
            Text("Carpool with friends")
        }
    case "Food":
        VStack{
            Text("Try eating veggie for a week!")
            Spacer()
            Text("Try swapping dairy for dairys alternative")
            Spacer()
            Text("Ear organic")
        }

    case "Household":
        VStack{
            Text("Turn off lights when you leave the room!")
            Spacer()
            Text("Swapping energy providers may help, explore your options")
            Spacer()
            Text("Only wash clothes with a full machine!")
        }
    case "Fashion":
        VStack{
            Text("Get rid of 'premier delivery', it is too temping")
            Spacer()
            Text("Shop your wardrobe instead of buying new things")
            Spacer()
            Text("Choose charity shops over the high street")
        }
    case "Health":
        VStack{
            Text("Use the medicines you have at home before buying more!")
            Spacer()
        }
    default:
        VStack{
        Text("Else")
        }
    }
}
}

//struct TipsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TipsView("Travel")
//    }
//}
