//
//  NumberEarthsView.swift
//  PIG
//
//  Created by ariane hine on 22/05/2021.
//

import SwiftUI
import WrappingHStack

//The view which displays the number of earths which would be needed according to the user's average CO2 output
struct NumberEarthsView: View {
    let ID: String
    @Binding var report: Report
    @EnvironmentObject var statsController: StatsDataController
    @State var numEarths : Double = 0;
    @State var numEarthsInt = 0;
    @State var difference = 0.0
    @State var moreOrless = "more"
    var body: some View {
        VStack{
            
            let numEarthsInt = Int(ceil(numEarths));
            Text("Your daily average is \((report.average / 100), specifier: "%.2f")kg CO2. \n\nIf everyone were to live like you, we would need \(numEarths, specifier: "%.2f") Earths. \n\nYou use \(difference, specifier: "%.2f")kg \(moreOrless) CO2 than the UK daily average").font(.title).frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).multilineTextAlignment(.center)
            
            //Displays an image for each earth the user uses, and a partial image if they use a decimal amount too e.g 4.6 will show 4 earths + 0.6 of another earth
            WrappingHStack(0..<numEarthsInt, id:\.self, alignment: .center) { index in
                Group{
                    
                    if ( index == numEarthsInt-1){
                        checkIfPartial(numEarths: numEarths, numEarthsInt: numEarthsInt)
                    }else{
                        
                        Image("logo")
                            .resizable()
                            .frame(width: 100, height: 89, alignment: .center);
                                           }
                    
                }
            }
            
            
        }.onAppear(){
            numEarths = getNumEarths(report: report);
            difference = (report.average / Double(report.numReportsComposingReport) - 2200) / 1000
            if difference>0 {
                moreOrless = "more"
            }else{
                moreOrless = "less"
                difference = abs(difference)
            }
            
        }
        
    }
}

//Calculates the number of earths needed
func getNumEarths(report: Report) ->Double{
    let returnVal = ((report.average / 100) / Double(report.numReportsComposingReport)) / 5;
    
    return (round(returnVal*100)) / 100.0;
    
}
//Check if there is a decimal in the number and if so mask the excess of the image
@ViewBuilder func checkIfPartial(numEarths: Double, numEarthsInt: Int)-> some View{
    
    if Double(numEarthsInt) > numEarths {
        let remainder1 = numEarths.truncatingRemainder(dividingBy: 1)
        
        Image("logo")
            .resizable()
            .frame(width: 100, height: 89)
            .mask(Rectangle().padding(.trailing, 100 * CGFloat(1 - remainder1))) //<-- Here
    }else{
        Text("no")
    }
    
}
