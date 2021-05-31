//
//  NumberEarthsView.swift
//  PIG
//
//  Created by ariane hine on 22/05/2021.
//

import SwiftUI
import WrappingHStack

struct NumberEarthsView: View {
    let ID: String
    //    @Binding var reports: [Report]
    //    @Binding var originalReports: [Report]
    @EnvironmentObject var statsController: StatsDataController
    @State var numEarths : Double = 7.75;
    @State var numEarthsInt = 0;
    var body: some View {
        VStack{
            
            let numEarthsInt = Int(ceil(numEarths));
            Text("If everyone were to live like you, we would need \(numEarths, specifier: "%.2f") Earths").font(.title).frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).multilineTextAlignment(.center)
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
            
            
        }
       
    }
}

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

struct NumberEarthsView_Previews: PreviewProvider {
    static var previews: some View {
        NumberEarthsView(ID: "5")
    }
}
