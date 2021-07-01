//
//  LocationManager.swift
//  PIG
//
//  Created by ariane hine on 01/07/2021.
//
//inspired by https://www.youtube.com/watch?v=q_srswdKouk
import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject{
    
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init(){
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
   
}
extension LocationManager: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async {
            self.location = location
        }
    }
}
