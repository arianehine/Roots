//
//  LocationExtensions.swift
//  PIG
//
//  Created by ariane hine on 01/07/2021.
//

import Foundation
import MapKit
extension MKCoordinateRegion {
    
    static var defaultRegion: MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: 51.509865, longitude:  -0.118092), latitudinalMeters: 100, longitudinalMeters: 100)
    }
}

