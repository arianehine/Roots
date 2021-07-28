//
//  Places.swift
//  Places
//
//  Created by Ariane Hine on 28/07/2021.
//

import Foundation
import CoreLocation

struct PlaceWithDistance : Identifiable{
    var id = UUID()
    var placemark: CLPlacemark
    var distance: Float
    init(placemark: CLPlacemark, distance: Float){
        self.placemark = placemark
        self.distance = distance
    }
}
