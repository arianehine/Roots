//
//  LocationManager.swift
//  PIG
//
//  Created by ariane hine on 01/07/2021.
//
//inspired by https://www.youtube.com/watch?v=q_srswdKouk
import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject{
    
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var searchText = ""
    @Published var places = [Place]()
    @Published var mapView: MKMapView = MKMapView()
    override init(){
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    
    }
    func setMapView(map: MKMapView) -> Bool{
        DispatchQueue.main.async {
            self.mapView = map
           
        }
        return true;
    }
    func searchQuery(searchText: String){
        
        places.removeAll()
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        MKLocalSearch(request: request).start { (response, _) in
            guard let result = response else { return}
            
            self.places = result.mapItems.compactMap({ (item) -> Place? in
                return Place(placemark: item.placemark)
            })
        }
    }
    
    //pick search result from list
    func selectPlace(place: Place){
        //show pin on map
        searchText = ""
        guard let coordinate = place.placemark.location?.coordinate else { return }
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = place.placemark.name ?? "No Name"
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(pointAnnotation)
    
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

