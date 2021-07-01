//
//  MapView.swift
//  PIG
//
//  Created by ariane hine on 01/07/2021.
//

import SwiftUI
import MapKit
import Combine

struct MapView: View {
    @ObservedObject private var locationManager = LocationManager()
    @State private var region =  MKCoordinateRegion.defaultRegion
    @State private var cancellable: AnyCancellable?
    var body: some View {
        VStack {
                 if locationManager.location != nil {
                     Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: nil)
                 } else {
                     Text("Locating user location...")
                 }
             }
             
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
