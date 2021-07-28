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
    @State var fbLogic = FirebaseLogic()
    var body: some View {
        Text("Tips to improve \(worstArea) :) ");
        Spacer()
        whatToImprove(worstArea: worstArea)
        Spacer()
        NavigationLink(destination: PledgesView(worstArea: worstArea, statsController: statsController).environmentObject(fbLogic)) {
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
                HStack{
                    Spacer()
                    Text("Swap the car for a bike ride every Monday!")
                    Spacer()
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(setTextColor(worstArea: worstArea), lineWidth: 4)).padding(.bottom)
            
                HStack{
                    HStack{
                        Spacer()
                        Text("Take no taxis this week")
                        Spacer()
                    }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(setTextColor(worstArea: worstArea), lineWidth: 4)).padding(.bottom)
                }
                
                HStack{
                    HStack{
                        Spacer()
                        Text("Carpool with friends once this week")
                        Spacer()
                    }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(setTextColor(worstArea: worstArea), lineWidth: 4)).padding(.bottom)
                
                }
            }
        case "Food":
            VStack{
                HStack{
                Text("Try eating veggie for a week!")
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(setTextColor(worstArea: worstArea), lineWidth: 4)).padding(.bottom)
            
                HStack{
                Text("Try swapping dairy for dairys alternative")
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(setTextColor(worstArea: worstArea), lineWidth: 4)).padding(.bottom)
                HStack{
                Text("Eat organic")
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(setTextColor(worstArea: worstArea), lineWidth: 4)).padding(.bottom)
            
            }
            
        case "Household":
            VStack{
                HStack{
                    Text("Turn off lights when you leave the room!")
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(setTextColor(worstArea: worstArea), lineWidth: 4)).padding(.bottom)
                
                HStack{
                    Text("Swapping energy providers may help, explore your options")
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(setTextColor(worstArea: worstArea), lineWidth: 4)).padding(.bottom)
                
                HStack{
                    Text("Only wash clothes with a full machine!")
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(setTextColor(worstArea: worstArea), lineWidth: 4)).padding(.bottom)
            }
        case "Fashion":
            VStack{
                HStack{
                    Text("Get rid of 'premier delivery', it is too temping")
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(setTextColor(worstArea: worstArea), lineWidth: 4)).padding(.bottom)
                
                HStack{
                    Text("Shop your wardrobe instead of buying new things")
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(setTextColor(worstArea: worstArea), lineWidth: 4)).padding(.bottom)
                
                HStack{
                    Text("Choose charity shops over the high street")
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(setTextColor(worstArea: worstArea), lineWidth: 4)).padding(.bottom)
                
            }
        case "Health":
            VStack{
                HStack{
                Text("Use the medicines you have at home before buying more!")
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(setTextColor(worstArea: worstArea), lineWidth: 4)).padding(.bottom)
            
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
