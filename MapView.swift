//
//  MapView.swift
//  PIG
//
//  Created by ariane hine on 01/07/2021.
//

import SwiftUI
import MapKit
import Combine
//track walk
//check steps on health to make sure user isn't faking it

struct MapView: View {
    @ObservedObject private var locationManager = LocationManager()
    @State private var region =  MKCoordinateRegion.defaultRegion
    @State private var cancellable: AnyCancellable?
    @State var searchText = ""

    var body: some View {
        ZStack{
        
       
       
                 if locationManager.location != nil {
                    Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: nil)
                
                    
                    
                    
                 } else {
                     Text("Locating user location...")
                 }
            VStack{
                
                VStack(spacing:0){
             
            HStack{
                Image(systemName: "magnifyingglass").foregroundColor(Color.gray)
                
                TextField("Search", text: $searchText).colorScheme(.light)
            }.padding(.vertical, 10)
            .padding(.horizontal, 10)
            .background(Color.white)
            .padding()
             
                    
                    if !locationManager.places.isEmpty && searchText != ""{
                        
                        ScrollView{
                            VStack( spacing: 15){
                                ForEach(locationManager.places){place in
                                    Text(place.placemark.name ?? "").foregroundColor(.black)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading).padding()
                                    
                                    Divider()
                                }
                            }
                        }
                        .background(Color.white)
                    }
                }.padding()
                Spacer()
            }
          
        }.onChange(of: searchText, perform: { value in
            
            
            let delay = 0.3
            
            DispatchQueue.main.asyncAfter(deadline: .now()+delay) {
                if value == searchText{
                    self.locationManager.searchQuery(searchText: searchText)
                    
                    
                }
            }
            
        })
             .onAppear {
                 setCurrentLocation()
             }    }
    
    private func setCurrentLocation(){
        cancellable = locationManager.$location.sink { location in
                    region = MKCoordinateRegion(center: location?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: 500, longitudinalMeters: 500)
                }
    
}
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
