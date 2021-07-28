//
//  ErrorView.swift
//  ErrorView
//
//  Created by Ariane Hine on 28/07/2021.
//

import Foundation
import SwiftUI
struct ErrorView : View {
    
    @State var color = Color.black.opacity(0.7)
    @Binding var alert : Bool
    @Binding var error : String
    
    var body: some View{
        
        
        VStack{
            
            HStack{
                Text(self.error).foregroundColor(Color.red)
            }
        }
    }
}
