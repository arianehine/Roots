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
    @State var worstTravel: String = "Driving"
    @State var walkedAmount: String = "x"
    @State var drivenAmount: String = "x"
    @State var trainAmount: String = "x"
    @State var busAmount: String = "x"
    @State var taxiAmount: String = "x"
    @State var planeAmount: String = "x"
    var body: some View {
        VStack{
            Text("\(worstArea) is your worst area").foregroundColor(setTextColor() as! Color).shadow(color: .black, radius: 1)
            Text("Your travel statistics:")
            Text("In the last \(timePeriod) you have:").font(.callout).padding(.bottom, 25.0).frame(alignment: .center)
            Group{
            HStack{
                Image(systemName: "figure.walk")
                Text("Walked \(walkedAmount) km").padding(.bottom) // Update tab title
            }
            HStack{
                Image(systemName: "car.fill")
                Text("Driven \(drivenAmount) km").padding(.bottom) // Update tab title
            }
            HStack{
                Image(systemName: "tram.fill")
                Text("Travelled \(trainAmount) km by train").padding(.bottom) // Update tab title
            }
            HStack{
                Image(systemName: "bus.fill")
                Text("Travelled \(busAmount) km by bus").padding(.bottom) // Update tab title
            }
            HStack{
                Image(systemName: "figure.wave")
                Text("Travelled \(taxiAmount) km by taxi").padding(.bottom) // Update tab title
            }
            HStack{
                Image(systemName: "airplane")
                Text("Flown \(planeAmount) km").padding(.bottom) // Update tab title
            }
            Spacer()
            }
            
            Spacer()
            Text("Your worst area is \(worstTravel)");
            
            
            

        }
        NavigationLink(destination: TipsView(worstArea: $worstArea)) {
            Text("How to improve \(worstArea)?").background(setTextColor()).foregroundColor(.white).cornerRadius(10).padding(.bottom)
        }.environmentObject(statsController).buttonStyle(PlainButtonStyle())
        
//            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
//                Text("How to improve?").background(setTextColor()).foregroundColor(.white).cornerRadius(10)
//            }).padding(.bottom)
//        }
        
        
        
    }
    
    func setTextColor() -> Color{
        for sam in sample{
            if(sam.name == worstArea){
                return sam.color;
            }
        }
        return Color.black;
    }
}

//struct ImproveView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImproveView(worstArea: "Preview")
//    }
//}
