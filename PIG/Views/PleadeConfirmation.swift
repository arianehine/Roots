//
//  PleadeConfirmation.swift
//  PIG
//
//  Created by ariane hine on 06/06/2021.
//

import SwiftUI

struct PleadeConfirmation: View {
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
                // set item.code & success flag to some view model and then
                // just call dismiss to return to ViewA
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        
    }
}
