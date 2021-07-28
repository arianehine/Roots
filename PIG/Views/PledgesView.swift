//
//  PledgesView.swift
//  PIG
//
//  Created by ariane hine on 04/06/2021.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct PledgesView: View {
    let auth = Auth.auth();
    let worstArea: String
    @State var selection: String? = nil
    @State var pledgesInProgress =
    [Pledge]()
    @State var statsController: StatsDataController
    @EnvironmentObject var fbLogic: FirebaseLogic
    var body: some View {
        
        Text("Select a pledge!")
            .padding()
        let pledgeList = fbLogic.pledgesForArea
        List(pledgeList) {
            pledge in
            Spacer()
            NavigationLink(destination: PleadeConfirmation(
                pledgePicked: pledge, statsController: statsController).environmentObject(fbLogic)){
                    pledgeRow(pledge: pledge, worstArea: worstArea)
                    
                }
        }.onAppear(perform: initVars)
        
        
        
    }
    func initVars(){
        
        fbLogic.allPledges = fbLogic.getAllPledges()
        fbLogic.pledgesForArea = fbLogic.getPledgesToChooseFromArea(chosenArea: worstArea)
    }
}

struct pledgeRow: View {
    var pledge: Pledge
    var worstArea: String
    
    
    var body: some View {
        
        HStack{
            Image(systemName: pledge.imageName)
            Text(pledge.description).padding(.bottom)
        }.frame(maxWidth: .infinity, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(setTextColor(worstArea: worstArea), lineWidth: 4)).padding(.bottom)

        
    }
    
}


