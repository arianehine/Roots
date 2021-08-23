//
//  CoordinatorModel.swift
//  CoordinatorModel
//
//  Created by Ariane Hine on 28/07/2021.
//

import Foundation
import MapKit
import SwiftUI

//Class which contains the coordinator for the map view
class Coordinator: NSObject,MKMapViewDelegate{
    
    //Instantiate the map and annotation views within the map, for MKAnnotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else{
            print("nil")
            return nil
        }
        guard let annotation = annotation as? MyAnnotation else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")

        if annotationView == nil{
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true

        }else{
            
            annotationView?.annotation = annotation
        }
        
        //If the annotation ID is for a recycling centre then show the custom map pin
        if(annotation.identifier == "Recycling"){
            let image = UIImage(named: "mappin")
            
            let size = CGSize(width: 25, height: 25)
            UIGraphicsBeginImageContext(size)
            image!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            annotationView?.image = resizedImage
        }else{
            //Else just show the regular map pin
            let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PIN_VIEW")
            pinAnnotation.tintColor = .red
            pinAnnotation.animatesDrop = true
            pinAnnotation.canShowCallout = true
            return pinAnnotation;
        }
        annotationView?.canShowCallout = true
        annotationView?.calloutOffset = CGPoint(x: -5, y: 5)

        return annotationView
        
        
        
    }
    //Instantiate the map and overlay views within the map, for MKOverlays. This is what displays the polylines
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        //check there is a pin on the map to draw a line to
        var renderer = MKPolylineRenderer()
        if !(mapView.annotations.count <= 1){
            if let routePolyline = overlay as? MKPolyline {
                renderer = MKPolylineRenderer(polyline: routePolyline)
                renderer.strokeColor = .orange
                renderer.lineWidth = 7
                return renderer
            }
            
        }else{
            return MKPolylineRenderer()
        }
        return MKPolylineRenderer()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        var selectedAnnotation = view.annotation
    }
    
    
}
