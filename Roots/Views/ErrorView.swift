//
//  ErrorView.swift
//  ErrorView
//
//  Created by Ariane Hine on 28/07/2021.
//

import Foundation
import SwiftUI
//View which is used to display an error on the user's screen (i.e. at log in or sign up_
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
