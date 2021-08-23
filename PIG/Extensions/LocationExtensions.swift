//
//  LocationExtensions.swift
//  PIG
//
//  Created by ariane hine on 01/07/2021.
//

import Foundation
import MapKit
extension MKCoordinateRegion {
    
    //Extension to set default region if none provided so app doesn't crash
    static var defaultRegion: MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: 51.509865, longitude:  -0.118092), latitudinalMeters: 100, longitudinalMeters: 100)
    }
}

