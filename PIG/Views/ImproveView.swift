//
//  ImproveView.swift
//  PIG
//
//  Created by ariane hine on 23/05/2021.
//

import SwiftUI

struct ImproveView: View {
    @StateObject var statsController: StatsDataController
    @Binding var worstArea: String
    @Binding var reports: [Report]
    @Binding var sample: [ChartCellModel]
    @Binding var timePeriod: String
    @State var worstTravel: String = ""
    @State var walkedAmount: Double = 0.0
    @State var drivenAmount: Double = 0.0
    @State var trainAmount: Double = 0.0
    @State var busAmount: Double = 0.0
    @State var taxiAmount: Double = 0.0
    @State var planeAmount: Double = 0.0
    var body: some View {
        VStack{
            
            getSpecifics(worstArea: worstArea, reports: reports, timePeriod: timePeriod, sample: sample, worstTravel: worstTravel);

            
            
        }
        NavigationLink(destination: TipsView(statsController: statsController, worstArea: $worstArea)) {
            Text("How to improve \(worstArea)?").background(setTextColor(sample: sample, worstArea: worstArea)).foregroundColor(.white).cornerRadius(10).padding(.bottom)
        }.environmentObject(statsController).buttonStyle(PlainButtonStyle())
        
        //            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
        //                Text("How to improve?").background(setTextColor()).foregroundColor(.white).cornerRadius(10)
        //            }).padding(.bottom)
        //        }
        
        
        
    }
    

}
@ViewBuilder func getSpecifics(worstArea: String, reports: [Report], timePeriod: String, sample: [ChartCellModel], worstTravel:String) -> some View{
    if (worstArea == "Transport") {
    
            var specifics = calculateTransport(reports: reports)
            var worstTravel = getWorstTravelArea(sample: specifics);
            let walkedAmount = specifics[0]
            let drivenAmount = specifics[1]
            let trainAmount = specifics[2]
            let busAmount = specifics[3]
            let taxiAmount = specifics[4]
            let planeAmount = specifics[5]
            
            
        Text("\(worstArea) is your worst area").foregroundColor(setTextColor(sample: sample, worstArea: worstArea) as! Color).shadow(color: .black, radius: 1)
            Text("Your \(worstArea) statistics:")
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
                Text("Your worst \(worstArea) area is \(worstTravel)").font(.subheadline);
            }
    }else if(worstArea == "Clothing") {
        
        var specifics = calculateClothing(reports: reports)
        var worstClothing = getWorstClothingArea(sample: specifics);
        let ffAmount = specifics[0]
        let susAmount = specifics[1]
        
        
    Text("\(worstArea) is your worst area").foregroundColor(setTextColor(sample: sample, worstArea: worstArea) as! Color).shadow(color: .black, radius: 1)
        Text("Your \(worstArea) statistics:")
        Text("In the last \(timePeriod) you have:").font(.callout).padding(.bottom, 25.0).frame(alignment: .center)
        Group{
            HStack{
                Image(systemName: "hourglass")
                Text("Fast fashion: \(ffAmount, specifier: "%.2f") km").padding(.bottom) // Update tab title
            }
            HStack{
                Image(systemName: "arrow.3.trianglepath")
                Text("Sustainable fashion: \(susAmount, specifier: "%.2f") km").padding(.bottom) // Update tab title
            }
        
            Spacer()
            Text("Your worst \(worstArea) area is \(worstClothing)").font(.subheadline);
        }
    
    }else if(worstArea == "Household") {
       
        
                var specifics = calculateHouseHold(reports: reports)
                var worstHouseHold = getWorstHouseHoldArea(sample: specifics);
                let heatingAmount = specifics[0]
                let electricAmount = specifics[1]
                let furnishingsAmount = specifics[2]
                let lightingAmount = specifics[3]
                
                
            Text("\(worstArea) is your worst area").foregroundColor(setTextColor(sample: sample, worstArea: worstArea) as! Color).shadow(color: .black, radius: 1)
                Text("Your \(worstArea) statistics:")
                Text("In the last \(timePeriod) you have:").font(.callout).padding(.bottom, 25.0).frame(alignment: .center)
                Group{
                    HStack{
                        Image(systemName: "flame.fill")
                        Text("Heating \(heatingAmount, specifier: "%.2f")").padding(.bottom) // Update tab title
                    }
                    HStack{
                        Image(systemName: "bolt.fill")
                        Text("Electric \(electricAmount, specifier: "%.2f")").padding(.bottom) // Update tab title
                    }
                    HStack{
                        Image(systemName: "house.fill")
                        Text("Furnishing \(furnishingsAmount, specifier: "%.2f")").padding(.bottom) // Update tab title
                    }
                    HStack{
                        Image(systemName: "lightbulb.fill")
                        Text("Lighting \(lightingAmount, specifier: "%.2f")").padding(.bottom) // Update tab title
                    }
                   
                    Spacer()
                    Text("Your worst \(worstArea) area is \(worstHouseHold)").font(.subheadline);
                }
        

    }else if(worstArea == "Food") {
       
        
        var specifics = calculateFood(reports: reports)
        var worstFood = getWorstFoodArea(sample: specifics);
        let meatAmount = specifics[0]
        let fishAmount = specifics[1]
        let dairyAmount = specifics[2]
        let oilsAmount = specifics[3]
        
        
    Text("\(worstArea) is your worst area").foregroundColor(setTextColor(sample: sample, worstArea: worstArea) as! Color).shadow(color: .black, radius: 1)
        Text("Your \(worstArea) statistics:")
        Text("In the last \(timePeriod) you have:").font(.callout).padding(.bottom, 25.0).frame(alignment: .center)
        Group{
            HStack{
                Image(systemName: "m.circle.fill")
                Text("Meat: \(meatAmount, specifier: "%.2f") km").padding(.bottom) // Update tab title
            }
            HStack{
                Image(systemName: "f.circle.fill")
                Text("Fish: \(fishAmount, specifier: "%.2f") km").padding(.bottom) // Update tab title
            }
            HStack{
                Image(systemName: "d.circle.fill")
                Text("Dairy: \(dairyAmount, specifier: "%.2f") km").padding(.bottom) // Update tab title
            }
            HStack{
                Image(systemName: "o.circle.fill")
                Text("Oils: \(oilsAmount, specifier: "%.2f") km").padding(.bottom) // Update tab title
            }
            Spacer()
            Text("Your worst \(worstArea) area is \(worstFood)").font(.subheadline);
        }
        
        
    }
    else if(worstArea == "Health") {
        var specifics = calculateHealth(reports: reports)
        var worstHealth = getWorstHealthArea(sample: specifics);
        let medsAmount = specifics[0]
        let scansAmount = specifics[1]
        
        
    Text("\(worstArea) is your worst area").foregroundColor(setTextColor(sample: sample, worstArea: worstArea) as! Color).shadow(color: .black, radius: 1)
        Text("Your \(worstArea) statistics:")
        Text("In the last \(timePeriod) you have:").font(.callout).padding(.bottom, 25.0).frame(alignment: .center)
        Group{
            HStack{
                Image(systemName: "pills.fill")
                Text("Medicines: \(medsAmount, specifier: "%.2f") km").padding(.bottom) // Update tab title
            }
            HStack{
                Image(systemName: "waveform.path.ecg.rectangle")
                Text("Scans: \(scansAmount, specifier: "%.2f") km").padding(.bottom) // Update tab title
            }
        
            Spacer()
            Text("Your worst \(worstArea) area is \(worstHealth)").font(.subheadline);
        }
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


func calculateFood(reports: [Report]) -> [Double]{
    var localMeat = 0.0
    var localFish = 0.0
    var localDairy = 0.0
    var localOils = 0.0
    for report in reports{
        localMeat = localMeat + Double(report.food_meat)
        localFish = localFish + Double(report.food_fish)
        localDairy = localDairy + Double(report.food_dairy)
        localOils = localOils +  Double(report.food_oils)
    }
    
    return [localMeat, localFish, localDairy, localOils]
    
}

func calculateHouseHold(reports: [Report]) -> [Double]{
    var localHeating = 0.0
    var localElectric = 0.0
    var localFurnishings = 0.0
    var localLighting = 0.0
    for report in reports{
        localHeating = localHeating + Double(report.household_heating)
        localElectric = localElectric + Double(report.household_electricity)
        localFurnishings = localFurnishings + Double(report.household_furnishings)
        localLighting = localLighting +  Double(report.household_lighting)
    }
    
    return [localHeating, localElectric, localFurnishings, localLighting]
    
}

func calculateClothing(reports: [Report]) -> [Double]{
    var localFF = 0.0
    var localSustainable = 0.0
    for report in reports{
        localFF = localFF + Double(report.clothing_fastfashion)
        localSustainable = localSustainable + Double(report.clothing_sustainable)
    }
    
    return [localFF, localSustainable]
    
}


func calculateHealth(reports: [Report]) -> [Double]{
    var localMeds = 0.0
    var localScans = 0.0
    for report in reports{
        localMeds = localMeds + Double(report.health_meds)
        localScans = localScans + Double(report.health_scans)
    }
    
    return [localMeds, localScans]
    
}

func setTextColor(sample: [ChartCellModel], worstArea: String) -> Color{
    for sam in sample{
        if(sam.name == worstArea){
            return sam.color;
        }
    }
    return Color.black;
}

public func setTextColor(worstArea: String) -> Color{
        if(worstArea == "Transport"){
            return Color.red;
        } else if(worstArea == "Household"){
            return Color.yellow;
    }else if(worstArea == "Health"){
        return Color.blue;
}else if(worstArea == "Fashion"){
    return Color.purple;
}
else if(worstArea == "Food"){
    return Color.green;
}
    print(worstArea)
    return Color.white;
}


func getWorstTravelArea(sample: [Double]) -> String{
    var max = 0.0
    var counter = 0
    var index = 0
    for sam in sample{
        if(sam > max){
            max = sam;
            index = counter;
        }
        counter += 1;
    }
    
    if(index == 0){
        return "Walking"
    }else if(index == 1){
        return "Driving"
    }else if(index == 2){
        return "Train"
    }else if(index == 3){
        return "Bus"
    }else if(index == 4){
        return "Taxi"
    }else if(index == 5){
        return "Plane"
    }
    return "undefined"
}

func getWorstHouseHoldArea(sample: [Double]) -> String{
    var max = 0.0
    var counter = 0
    var index = 0
    for sam in sample{
        if(sam > max){
            max = sam;
            index = counter;
        }
        counter += 1;
    }
    
    if(index == 0){
        return "Heating"
    }else if(index == 1){
        return "Electric"
    }else if(index == 2){
        return "Furnishings"
    }else if(index == 3){
        return "Lighting"
    }
    return "undefined"
}

func getWorstFoodArea(sample: [Double]) -> String{
    var max = 0.0
    var counter = 0
    var index = 0
    for sam in sample{
        if(sam > max){
            max = sam;
            index = counter;
        }
        counter += 1;
    }
    
    if(index == 0){
        return "Meat"
    }else if(index == 1){
        return "Fish"
    }else if(index == 2){
        return "Dairy"
    }else if(index == 3){
        return "Oils"
    }
    return "undefined"
}

func getWorstClothingArea(sample: [Double]) -> String{
    var max = 0.0
    var counter = 0
    var index = 0
    for sam in sample{
        if(sam > max){
            max = sam;
            index = counter;
        }
        counter += 1;
    }
    
    if(index == 0){
        return "Fast Fashion"
    }else if(index == 1){
        return "Sustainable Fashion"
    }
    return "undefined"
}

func getWorstHealthArea(sample: [Double]) -> String{
    var max = 0.0
    var counter = 0
    var index = 0
    for sam in sample{
        if(sam > max){
            max = sam;
            index = counter;
        }
        counter += 1;
    }
    
    if(index == 0){
        return "Medicines"
    }else if(index == 1){
        return "Scans"
    }
    return "undefined"
}
//struct ImproveView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImproveView(worstArea: "Preview")
//    }
//}
