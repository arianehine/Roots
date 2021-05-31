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
    @State var worstTravel: String = "Driving" //calculate this
    @State var walkedAmount: Double = 0.0
    @State var drivenAmount: Double = 0.0
    @State var trainAmount: Double = 0.0
    @State var busAmount: Double = 0.0
    @State var taxiAmount: Double = 0.0
    @State var planeAmount: Double = 0.0
    var body: some View {
        VStack{
            
            getSpecifics(worstArea: worstArea, reports: reports, timePeriod: timePeriod, sample: sample);
            
            
            Spacer()
            Text("Your worst area is \(worstTravel)");
            
            
            
            
        }
        NavigationLink(destination: TipsView(worstArea: $worstArea)) {
            Text("How to improve \(worstArea)?").background(setTextColor(sample: sample, worstArea: worstArea)).foregroundColor(.white).cornerRadius(10).padding(.bottom)
        }.environmentObject(statsController).buttonStyle(PlainButtonStyle())
        
        //            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
        //                Text("How to improve?").background(setTextColor()).foregroundColor(.white).cornerRadius(10)
        //            }).padding(.bottom)
        //        }
        
        
        
    }
    

}
@ViewBuilder func getSpecifics(worstArea: String, reports: [Report], timePeriod: String, sample: [ChartCellModel]) -> some View{
    if (worstArea == "Transport") {
    
            var specifics = calculateTransport(reports: reports)
            let walkedAmount = specifics[0]
            let drivenAmount = specifics[1]
            let trainAmount = specifics[2]
            let busAmount = specifics[3]
            let taxiAmount = specifics[4]
            let planeAmount = specifics[5]
            
            
        Text("\(worstArea) is your worst area").foregroundColor(setTextColor(sample: sample, worstArea: worstArea) as! Color).shadow(color: .black, radius: 1)
            Text("Your travel statistics:")
            Text("In the last \(timePeriod) you have:").font(.callout).padding(.bottom, 25.0).frame(alignment: .center)
            Group{
                HStack{
                    Image(systemName: "figure.walk")
                    Text("Walked \(walkedAmount, specifier: "%.2f") km").padding(.bottom) // Update tab title
                }
                HStack{
                    Image(systemName: "car.fill")
                    Text("Driven \(drivenAmount, specifier: "%.2f") km").padding(.bottom) // Update tab title
                }
                HStack{
                    Image(systemName: "tram.fill")
                    Text("Travelled \(trainAmount, specifier: "%.2f") km by train").padding(.bottom) // Update tab title
                }
                HStack{
                    Image(systemName: "bus.fill")
                    Text("Travelled \(busAmount, specifier: "%.2f") km by bus").padding(.bottom) // Update tab title
                }
                HStack{
                    Image(systemName: "figure.wave")
                    Text("Travelled \(taxiAmount, specifier: "%.2f") km by taxi").padding(.bottom) // Update tab title
                }
                HStack{
                    Image(systemName: "airplane")
                    Text("Flown \(planeAmount, specifier: "%.2f") km").padding(.bottom) // Update tab title
                }
                Spacer()
            }
    }else{
        Text("other")
    }
}

func calculateTransport(reports: [Report]) -> [Double]{
    var localWalkedAmount = 0.0
    var localDrivenAmount = 0.0
    var localTrainAmount = 0.0
    var localBusAmount = 0.0
    var localTaxiAmount = 0.0
    var localPlaneAmount = 0.0
    for report in reports{
        localWalkedAmount = localWalkedAmount + Double(report.transport_walking)
        localDrivenAmount = localDrivenAmount + Double(report.transport_car)
        localTrainAmount = localTrainAmount + Double(report.transport_train)
        localBusAmount = localBusAmount +  Double(report.transport_train)
        localPlaneAmount = localPlaneAmount + Double(report.transport_plane)
    }
    
    return [localWalkedAmount, localDrivenAmount, localTrainAmount, localBusAmount, localTaxiAmount, localPlaneAmount]
    
}
func setTextColor(sample: [ChartCellModel], worstArea: String) -> Color{
    for sam in sample{
        if(sam.name == worstArea){
            return sam.color;
        }
    }
    return Color.black;
}
//struct ImproveView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImproveView(worstArea: "Preview")
//    }
//}
