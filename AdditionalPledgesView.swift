//
//  AdditionalPledgesView.swift
//  PIG
//
//  Created by ariane hine on 25/06/2021.
//

import SwiftUI

struct AdditionalPledgesView: View {
    let ID: String
    @State var selected: String = ""
    @State var fbLogic: FirebaseLogic
    var body: some View {
        let categories = ["Transport", "Health", "Food", "Household", "Fashion"];
        Text("Select a category:")
        List {
            ForEach(categories, id: \.self) { category in
            Spacer()
            NavigationLink(destination: PledgesView(worstArea: category).environmentObject(fbLogic)){
                CategoryRow(area: category)

        }
        }
    }
}
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

//struct AdditionalPledgesView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdditionalPledgesView()
//    }
//}
}
