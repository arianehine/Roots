//
//  PledgesView.swift
//  PIG
//
//  Created by ariane hine on 04/06/2021.
//

import SwiftUI

struct PledgesView: View {
    let worstArea: String
    var body: some View {
        Text("So you want to improve \(worstArea)? \n Choose a pledge!").multilineTextAlignment(.center)
        Spacer()
        pledgeselector(worstArea: worstArea)
        Spacer()
    }
}

@ViewBuilder func pledgeselector(worstArea: String)-> some View{
    switch worstArea {
    case "Transport":
        Group{
            HStack{
                Image(systemName: "figure.walk")
                Text("Walk to work 2 days a week").padding(.bottom)
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(setTextColor(worstArea: worstArea), lineWidth: 4))
                
            HStack{
                Image(systemName: "car.fill")
                Text("Drive only 3 days this week").padding(.bottom) // Update tab title
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(setTextColor(worstArea: worstArea), lineWidth: 4))
            HStack{
                Image(systemName: "tram.fill")
                Text("Swap the car for the train").padding(.bottom) // Update tab title
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(setTextColor(worstArea: worstArea), lineWidth: 4))
            HStack{
                Image(systemName: "figure.wave")
                Text("Take 0 Taxis this week").padding(.bottom) // Update tab title
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(setTextColor(worstArea: worstArea), lineWidth: 4))
        }
    case "Food":
        Group{
            HStack{
                Image(systemName: "m.circle.fill")
                Text("Eat meat only once a day").padding(.bottom) // Update tab title
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(setTextColor(worstArea: worstArea), lineWidth: 4))
            HStack{
                Image(systemName: "f.circle.fill")
                Text("Cut fish out of your diet for 2 weeks").padding(.bottom) // Update tab title
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(setTextColor(worstArea: worstArea), lineWidth: 4))
            HStack{
                Image(systemName: "d.circle.fill")
                Text("Swap cow's milk for an alternative").padding(.bottom) // Update tab title
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(setTextColor(worstArea: worstArea), lineWidth: 4))
            HStack{
                Image(systemName: "leaf.fill")
                Text("Go vegan for a week").padding(.bottom) // Update tab title
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(setTextColor(worstArea: worstArea), lineWidth: 4))
        }

    case "Household":
        Group{
            HStack{
                Image(systemName: "flame.fill")
                Text("Put your heating on a set timer!").padding(.bottom) // Update tab title
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(setTextColor(worstArea: worstArea), lineWidth: 4))
            
            HStack{
                Image(systemName: "bolt.fill")
                Text("Turn lights off when you leave the room").padding(.bottom)// Update tab title
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(setTextColor(worstArea: worstArea), lineWidth: 4))
            HStack{
                Image(systemName: "house.fill")
                Text("Don't buy any furniature for 4 months").padding(.bottom) // Update tab title
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(setTextColor(worstArea: worstArea), lineWidth: 4))
            HStack{
                Image(systemName: "lightbulb.fill")
                Text("Turn lights off when you leave the room!").padding(.bottom) // Update tab title
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(setTextColor(worstArea: worstArea), lineWidth: 4))
           
        
        }
    case "Fashion":
        VStack{
            Group{
                HStack{
                    Image(systemName: "hourglass")
                    Text("Don't buy any fast fashion for 2 weeks").padding(.bottom) // Update tab title
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(setTextColor(worstArea: worstArea), lineWidth: 4))
                HStack{
                    Image(systemName: "arrow.3.trianglepath")
                    Text("Take a trip t the charity shop instead of buying new!").padding(.bottom) // Update tab title
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(setTextColor(worstArea: worstArea), lineWidth: 4))
                HStack{
                    Image(systemName: "bag.circle.fill")
                    Text("Download Depop and sell some of your own clothes!").padding(.bottom) // Update tab title
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(setTextColor(worstArea: worstArea), lineWidth: 4))
        
            }
        }
    case "Health":
        Group{
            HStack{
                Image(systemName: "pills.fill")
                Text("Sort thrugh your medidicnes at home, so you know how much you have!").padding(.bottom) // Update tab title
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(setTextColor(worstArea: worstArea), lineWidth: 4))
        
        }
    default:
        VStack{
        Text("Else")
        }
    }
}


struct PledgesView_Previews: PreviewProvider {
    static var previews: some View {
        PledgesView(worstArea: "Household")
    }
}
