//
//  Place.swift
//  PIG
//
//  Created by ariane hine on 01/07/2021.
//
import MapKit
import Foundation
struct Place : Identifiable{
    var id = UUID()
    var placemark: CLPlacemark
    
    init(placemark: CLPlacemark){
        self.placemark = placemark
    }
}
