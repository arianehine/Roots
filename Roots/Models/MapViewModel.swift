//
//  MapViewModel.swift
//  PIG
//
//  Created by ariane hine on 02/07/2021.
//

import SwiftUI
import MapKit
import CoreLocation
import UserNotifications

//Code inspired by tutorials from: https://www.raywenderlich.com/20690666-location-notifications-with-unlocationnotificationtrigger
//and
//https://kavsoft.dev/SwiftUI_2.0/Advance_MapKit


//This class holds the model which is used to store details about the Map View which will be shown
class MapViewModel: NSObject,ObservableObject,CLLocationManagerDelegate{
    let notificationCenter = UNUserNotificationCenter.current()
    @Published var mapView = MKMapView()
    @Published var didArriveAtDestination = false
    
    // Region...
    @Published var region : MKCoordinateRegion!
    @Published var circularRegions = [CLCircularRegion]()
    
    // Alert...
    @Published var permissionDenied = false
    
    // Map Type...
    @Published var mapType : MKMapType = .standard
    
    // SearchText...
    @Published var searchTxt = ""
    @Published var sourceCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 51.50074076097613, longitude: -0.178478644001959924)
    @Published var destinationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 51.50074076097613, longitude: -0.178478644001959924)
    
    //Places and directions which a user search/selection sets
    @Published var places : [Place] = []
    @Published var directions : MKDirections = MKDirections(request: MKDirections.Request())
    
    // Updating Map Type...
    func updateMapType(){
        
        if mapType == .standard{
            mapType = .hybrid
            mapView.mapType = mapType
        }
        else{
            mapType = .standard
            mapView.mapType = mapType
        }
    }
    
    // Focus Location in to user region...
    func focusLocation(){
        
        guard let _ = region else{return}
        
        mapView.setRegion(region, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
    
    // Search Places...
    func searchQuery(){
        
        places.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchTxt
        
        // Fetch...
        MKLocalSearch(request: request).start { (response, _) in
            
            guard let result = response else{return}
            
            self.places = result.mapItems.compactMap({ (item) -> Place? in
                return Place(placemark: item.placemark)
            })
        }
    }
    
    func setSearchText(query: String){
        self.searchTxt = query;
    }
    
    //Adds all of the places within the places array to the map
    //Each place gets a map pin annotation on the map view
    func appendAllPlaces(places: [Place], currentLocation: CLLocation, locatioManager: CLLocationManager){
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        let closestFive = getClosestPlaces(places: places, currentLocation: currentLocation)
        
        for place in closestFive {
            guard let coordinate = place.placemark.location?.coordinate else{return}
            let pointAnnotation = MyAnnotation()
            let targetLocationCL = CLLocation(latitude: place.placemark.location!.coordinate.latitude, longitude: place.placemark.location!.coordinate.longitude)
            var distanceInMeters = currentLocation.distance(from: targetLocationCL)
            pointAnnotation.coordinate = coordinate
            pointAnnotation.title = place.placemark.name ?? "No Name"
            pointAnnotation.identifier = "Recycling"
            let distanceFloat = Float(distanceInMeters)
            let distanceString = String(format: "%.1f", distanceFloat)
            
            pointAnnotation.subtitle = "Distance: \(distanceString) metres";
            
            let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                      latitudinalMeters: 10000, longitudinalMeters: 10000)
            
            mapView.setRegion(coordinateRegion, animated: true)
            mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
            mapView.addAnnotation(pointAnnotation)
            circularRegions.append(CLCircularRegion(center: coordinate, radius: 500, identifier: UUID().uuidString))
            locatioManager.startMonitoring(for: circularRegions[circularRegions.count-1])
            
        }
        mapView.setRegion(region, animated: true)
        searchTxt = ""
        
    }
    // Select the 5 closest recycling point locations from the places array
    func getClosestPlaces(places: [Place], currentLocation: CLLocation) -> [Place]{
        var placesWithDistance = [PlaceWithDistance]()
        var returnPlaces = [Place]()
        for place in places{
            let targetLocationCL = CLLocation(latitude: place.placemark.location!.coordinate.latitude, longitude: place.placemark.location!.coordinate.longitude)
            var distanceInMeters = currentLocation.distance(from: targetLocationCL)
            let distanceFloat = Float(distanceInMeters)
            placesWithDistance.append(PlaceWithDistance(placemark: place.placemark, distance: distanceFloat))
            
        }
        placesWithDistance.sort { $0.distance < $1.distance }
        
        let closestPlaces = Array(placesWithDistance[0...4])
        
        for place in closestPlaces{
            let obj = places.first(where: {$0.placemark.name == place.placemark.name})
            returnPlaces.append(obj!)
        }
        
        return returnPlaces
    }
    
    //Selecting a place from the search list will place a pin on the map, begin monitoring this region, and focus the map to this location's region. Following this, a polyline (path) from user location to selected location will be drawn
    func selectPlace(place: Place){
        
        
        searchTxt = ""
        
        guard let coordinate = place.placemark.location?.coordinate else{return}
        let circularRegion = CLCircularRegion(
            center: coordinate,
            radius: 500,
            identifier: UUID().uuidString)
        
        
        circularRegion.notifyOnEntry = true
        circularRegions.append(circularRegion)
        
        
        let pointAnnotation = MyAnnotation()
        pointAnnotation.identifier = "Location"
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = place.placemark.name ?? "No Name"
        
        
        // Moving Map To That Location...
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.removeAnnotations(mapView.annotations)
        
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
        self.destinationCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let req = MKDirections.Request()
        req.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceCoordinate))
        req.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        req.transportType =  .walking
        //remove existing overlays
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        
        directions = MKDirections(request: req)
        mapView.addAnnotation(pointAnnotation)
        directions.calculate{ [self] (direct, err) in
            if err != nil{
                //an error has occured
                print(err?.localizedDescription, "location: ", req.source?.name, req.destination!.name)
                
            }else{
                let polyline = direct?.routes.first?.polyline
                self.mapView.setRegion(MKCoordinateRegion(polyline!.boundingMapRect), animated: true)
                self.mapView.addOverlay(polyline!)
                
                
            }
        }
        
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        // Checking Permissions...
        switch manager.authorizationStatus {
        case .denied:
            // Alert...
            permissionDenied.toggle()
        case .notDetermined:
            // Requesting....
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            // If Permissin Given...
            manager.requestLocation()
        default:
            (print("default"))
        }
    }
    
    //If location manager fails print error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // Error....
        print(error.localizedDescription)
    }
    
    //If it succeeds without error, get the user's location, monitor the circular regions and if the user enters these then set variable to true to show pledge completion, change the region and redraw the polyline if the user's location changes.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        guard let location = locations.last else{return}
        
        
        
        for region in circularRegions {
            if(region.contains(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))){
                didArriveAtDestination = true
                print("did arrive")
                return
            }else{
                
            }
        }
        
        
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        self.sourceCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        self.mapView.setRegion(self.region, animated: true)
        
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
        
        
        let req = MKDirections.Request()
        req.source = MKMapItem(placemark: MKPlacemark(coordinate: self.sourceCoordinate))
        req.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        req.transportType =  .walking
        
        let overlays = mapView.overlays
        self.mapView.removeOverlays(overlays)
        
        directions = MKDirections(request: req)
        
        directions.calculate{ [self] (direct, err) in
            if err != nil{
                //an error has occured
                print(err?.localizedDescription, "location: ", req.source?.name, req.destination!.name)
                
            }else{
                let polyline = direct?.routes.first?.polyline
                self.mapView.addOverlay(polyline!)
            }
        }
        
    }
}



