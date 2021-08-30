//
//  PledgeConfirmation.swift
//  PIG
//
//  Created by ariane hine on 06/06/2021.
//

import SwiftUI

//View which allows a user to confirm they wish to commit to a pledge. Allows a user to change the duration of the pledge and see the amount of C02 they will save by doing so.
struct PledgeConfirmation: View {
    var pledgePicked: Pledge
    @State var statsController: StatsDataController
    @State private var durationSelected = 3
    @State var saveAmount = 0.3
    @State var carbonFootprintModel = CarbonFootprint()
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var fbLogic: FirebaseLogic
    var body: some View {
        VStack{
            Text("Commit to pledge: \(pledgePicked.description )").multilineTextAlignment(.center)
            Text(String(format: "\nThis pledge could save you %.2f Co2", saveAmount))
            Spacer()
            Text("Duration (minimum 3 days)")
            Picker("", selection: $durationSelected) {
                ForEach(3...14, id: \.self) {
                    Text("\($0)")
                }.onChange(of: durationSelected){ value in
                    saveAmount = Double(value) * carbonFootprintModel.getConstant(area: pledgePicked.category)
                    
                }
            }
        }
        Spacer()
        HStack{
            HStack{
                NavigationLink(destination: PledgesInProgress(
                    statsController: statsController, durationSelected: durationSelected, pledgePicked: pledgePicked).environmentObject(fbLogic)){
                        Text("Yes")
                        Image(systemName: "person.fill.checkmark").foregroundColor(Color(.green))
                    }
            }
            Spacer()
            HStack{
                
                Text("No")
                Image(systemName: "person.fill.xmark").foregroundColor(Color(.red))
                
            }.frame(height: 64)
                .onTapGesture {
                    self.presentationMode.wrappedValue.dismiss()
                }
        }
        
    }
}
