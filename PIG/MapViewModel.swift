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
    @Published var circularRegions = [CLCircularRegion]()
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
    
    func setSearchText(query: String){
        self.searchTxt = query;
    }
    
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
//            mapView.removeAnnotations(mapView.annotations)

            mapView.setRegion(coordinateRegion, animated: true)
            mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
            mapView.addAnnotation(pointAnnotation)
            circularRegions.append(CLCircularRegion(center: coordinate, radius: 500, identifier: UUID().uuidString))
            locatioManager.startMonitoring(for: circularRegions[circularRegions.count-1])
           
        }
        mapView.setRegion(region, animated: true)
        searchTxt = ""
        
    }
    // Pick Search Result...
    
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
        print(placesWithDistance)
        let closestPlaces = Array(placesWithDistance[0...4])
        
        for place in closestPlaces{
            let obj = places.first(where: {$0.placemark.name == place.placemark.name})
            returnPlaces.append(obj!)
        }
    
        return returnPlaces
    }

    func selectPlace(place: Place){
        print("selected place")
        
        // Showing Pin On Map....
        
        searchTxt = ""
        
        guard let coordinate = place.placemark.location?.coordinate else{return}
        let circularRegion = CLCircularRegion(
            center: coordinate,
           radius: 500,
           identifier: UUID().uuidString)
         // 3
        
        circularRegion.notifyOnEntry = true
        circularRegions.append(circularRegion)
       
      
        
        let pointAnnotation = MyAnnotation()
        pointAnnotation.identifier = "Location"
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
//              self?.registerNotification()
            }
          print("Notification Auth Request result: \(result)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // Error....
        print(error.localizedDescription)
    }
    
    // Getting user Region....
//    private func registerNotification() {
//      // 2
//      let notificationContent = UNMutableNotificationContent()
//      notificationContent.title = "Carbon Footprint App Tracking"
//      notificationContent.body = "Congrats on walking to work! +1 on your pledge commitment"
//      notificationContent.sound = .default
//
//      // 3
//      let trigger = UNLocationNotificationTrigger(
//        region: circularRegions[0],
//        repeats: false)
//
//      // 4
//      let request = UNNotificationRequest(
//        identifier: UUID().uuidString,
//        content: notificationContent,
//        trigger: trigger)
//
//      // 5
//      notificationCenter
//        .add(request) { error in
//          if error != nil {
//            print("Error: \(String(describing: error))")
//          }
//        }
//    }
//    override init() {
//      super.init()
//      // 2
//      notificationCenter.delegate = self
//    }
//
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("moved")
        
        guard let location = locations.last else{return}
       
         
        print("not returned circ regions count = ", circularRegions.count)
            for region in circularRegions {
                if(region.contains(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))){
                    didArriveAtDestination = true
                    print("did arrive")
                    return
                }else{
                    print("didn't arrive")
                }
            }
        
        
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        

        
        self.sourceCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        // Updating Map....
        
        self.mapView.setRegion(self.region, animated: true)
        
        // Smooth Animations...
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
        
        // Create and add your MKPolyline here based on locations
                    // passed (the last element of the array is the most recent
                    // position).
        
        
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
struct PlaceWithDistance : Identifiable{
    var id = UUID()
    var placemark: CLPlacemark
    var distance: Float
    init(placemark: CLPlacemark, distance: Float){
        self.placemark = placemark
        self.distance = distance
    }
}
