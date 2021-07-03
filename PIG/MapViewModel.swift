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

// All Map Data Goes Here....
//notification tutorial from https://www.raywenderlich.com/20690666-location-notifications-with-unlocationnotificationtrigger

class MapViewModel: NSObject,ObservableObject,CLLocationManagerDelegate{
    let notificationCenter = UNUserNotificationCenter.current()
    @Published var mapView = MKMapView()
    @Published var didArriveAtDestination = false
    
    // Region...
    @Published var region : MKCoordinateRegion!
    @Published var circularRegion: CLCircularRegion = CLCircularRegion(
        center:CLLocationCoordinate2D(latitude:  51.50074076097613, longitude: -0.178478644001959924),
       radius: 1000,
       identifier: UUID().uuidString)
     // 3
    // Based On Location It Will Set Up....
    
    // Alert...
    @Published var permissionDenied = false
    
    // Map Type...
    @Published var mapType : MKMapType = .standard
    
    // SearchText...
    @Published var searchTxt = ""
    @Published var sourceCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 51.50074076097613, longitude: -0.178478644001959924)
    @Published var destinationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 51.50074076097613, longitude: -0.178478644001959924)

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
    
    // Focus Location...
    
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
    
    // Pick Search Result...
    
    func selectPlace(place: Place){
        
        // Showing Pin On Map....
        
        searchTxt = ""
        
        guard let coordinate = place.placemark.location?.coordinate else{return}
        self.circularRegion = CLCircularRegion(
            center: coordinate,
           radius: 500,
           identifier: UUID().uuidString)
         // 3
        
        circularRegion.notifyOnEntry = true
       
      
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = place.placemark.name ?? "No Name"
        
        // Removing All Old Ones...

        
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
        
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        
        directions = MKDirections(request: req)
        
        directions.calculate{ [self] (direct, err) in
            if err != nil{
                //an error has occured
                print(err?.localizedDescription, "location: ", req.source?.name, req.destination!.name)
                
            }else{
               let polyline = direct?.routes.first?.polyline
                self.mapView.setRegion(MKCoordinateRegion(polyline!.boundingMapRect), animated: true)
                self.mapView.addOverlay(polyline!)
            
                print("directions", direct?.routes.first)
                print("source:", sourceCoordinate, "dest", destinationCoordinate)
               
            }
        }
     
      
        mapView.addAnnotation(pointAnnotation)
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        // Checking Permissions...
        
        switch manager.authorizationStatus {
        case .denied:
            // Alert...
            print("denied")
            permissionDenied.toggle()
        case .notDetermined:
            print("not determined")
            // Requesting....
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            // If Permissin Given...
            print("auth")
            manager.requestLocation()
        default:
            (print("default"))
        }
    }
    func requestNotificationAuthorization() {
      // 2
      let options: UNAuthorizationOptions = [.sound, .alert]
      // 3
      notificationCenter
        .requestAuthorization(options: options) { [weak self] result, _ in
            if result {
              self?.registerNotification()
            }
          print("Notification Auth Request result: \(result)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // Error....
        print(error.localizedDescription)
    }
    
    // Getting user Region....
    private func registerNotification() {
      // 2
      let notificationContent = UNMutableNotificationContent()
      notificationContent.title = "Carbon Footprint App Tracking"
      notificationContent.body = "Congrats on walking to work! +1 on your pledge commitment"
      notificationContent.sound = .default

      // 3
      let trigger = UNLocationNotificationTrigger(
        region: circularRegion,
        repeats: false)

      // 4
      let request = UNNotificationRequest(
        identifier: UUID().uuidString,
        content: notificationContent,
        trigger: trigger)

      // 5
      notificationCenter
        .add(request) { error in
          if error != nil {
            print("Error: \(String(describing: error))")
          }
        }
    }
    override init() {
      super.init()
      // 2
      notificationCenter.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else{return}
        print("current location ", location)
         
        if(circularRegion.contains(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))){
            didArriveAtDestination = true
        
        }else{
            print("not contains")
        }
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        

        
        self.sourceCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        // Updating Map....
        
        self.mapView.setRegion(self.region, animated: true)
        
        // Smooth Animations...
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
}



extension MapViewModel: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      didReceive response: UNNotificationResponse,
      withCompletionHandler completionHandler: @escaping () -> Void
    ) {
      // 2
      print("Received Notification")
      // 3
        didArriveAtDestination = true
      completionHandler()
    }

    // 4
    func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      willPresent notification: UNNotification,
      withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {
      // 5
      print("Received Notification in Foreground")
      // 6
        didArriveAtDestination = true
      completionHandler(.sound)
    }
}
