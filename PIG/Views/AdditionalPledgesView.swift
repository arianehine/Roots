//
//  AdditionalPledgesView.swift
//  PIG
//
//  Created by ariane hine on 25/06/2021.
//

import SwiftUI

//Displays the additional pledges that a user can take
struct AdditionalPledgesView: View {
    let ID: String
    @State var selected: String = ""
    @State var fbLogic: FirebaseLogic
    @State var statsController: StatsDataController
    var body: some View {
        let categories = ["Transport", "Health", "Food", "Household", "Fashion"];
        Text("Select a category:")
        NavigationView {
            List {
                
                ForEach(categories, id: \.self) { category in
                    Spacer()
                    NavigationLink(destination: PledgesView(worstArea: category, statsController: statsController).environmentObject(fbLogic)){
                        CategoryRow(area: category)
                    }
                    
                }
            }
        }
    }
    //A struct to format each pledge nicely
    struct CategoryRow: View {
        var area: String
        
        var body: some View {
            HStack{
                Text(area).padding(.bottom)
            }.frame(maxWidth: .infinity, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(setTextColor(worstArea: area), lineWidth: 4)).padding(.bottom)
        }
        
    }
    
}
