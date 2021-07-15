//
//  ToggleView.swift
//  PIG
//
//  Created by ariane hine on 19/05/2021.
//

import SwiftUI

struct ToggleView: View {
    
    @Binding public var selected: String
    @State var show = false
    
    var body: some View {
        
        ZStack{
            
            VStack{
                if(self.selected != ""){
                Text("Currently showing \(self.selected) view" ).padding(.top)
                }
                
                Button(action: {
                    
                    self.show.toggle()
                    
                }) {
                    
                    Text("Open").padding(.vertical).padding(.horizontal,25).foregroundColor(.white)
                }
                .background(LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1")]), startPoint: .leading, endPoint: .trailing))
                .clipShape(Capsule())
                
                
            }
            
            VStack{
                
//                Spacer()
                
                RadioButtons(selected: self.$selected,show: self.$show)
                    .offset(y: self.show ? (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 0 : UIScreen.main.bounds.height)
                
            }.background(Color(UIColor.label.withAlphaComponent(self.show ? 0.2 : 0)).edgesIgnoringSafeArea(.all))
            
        }.frame(maxHeight: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .animation(.default)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    var statsController: StatsDataController
//    static var previews: some View {
//        ContentView(statsController: statsController)
//    }
//}

struct RadioButtons : View {
    
    @Binding var selected : String
    @Binding var show : Bool
    
    var body : some View{
        
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Filter By").font(.title).padding(.top)
            
            ForEach(data,id: \.self){i in
                
                Button(action: {
                    
                    self.selected = i
                    
                }) {
                    
                    HStack{
                        
                        Text(i)
                        
                        Spacer()
                        
                        ZStack{
                            
                            Circle().fill(self.selected == i ? Color("Color") : Color.black.opacity(0.2)).frame(width: 18, height: 18)
                            
                            if self.selected == i{
                                
                                Circle().stroke(Color("Color1"), lineWidth: 4).frame(width: 25, height: 25)
                            }
                        }
                        

                        
                    }.foregroundColor(.black)
                    
                }.padding(.top)
            }
            
            HStack{
                
                Spacer()
                
                 Button(action: {
                     
                    self.show.toggle();
                    
                    
                 }) {
                     
                     Text("Continue").padding(.vertical).padding(.horizontal,25).foregroundColor(.white)
                     
                 }
                 .background(
                    
                    self.selected != "" ?
                    
                    LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1")]), startPoint: .leading, endPoint: .trailing) :
                    
                        LinearGradient(gradient: .init(colors: [Color.black.opacity(0.2),Color.black.opacity(0.2)]), startPoint: .leading, endPoint: .trailing)
                 
                 )
                .clipShape(Capsule())
                .disabled(self.selected != "" ? false : true)
                
                
            }.padding(.top)
            
        }.padding(.vertical)
        .padding(.horizontal,25)
        .padding(.bottom,(UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 15)
        .background(Color.white)
        .cornerRadius(30)
    }
}

var data = ["Day","Week","Month","Year"]


struct ToggleView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleView(selected: .constant(""))
    }
}
