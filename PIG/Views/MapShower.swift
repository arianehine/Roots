//
//  MapShower.swift
//  PIG
//
//  Created by ariane hine on 02/07/2021.
//
import SwiftUI
import MapKit

struct MapShower: UIViewRepresentable {
    
    @EnvironmentObject var mapData: MapViewModel
  
    
    
    func makeCoordinator() -> Coordinator {
        return MapShower.Coordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        
        let view = mapData.mapView
        
        view.showsUserLocation = true
        view.delegate = context.coordinator
        
        return view
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.delegate = context.coordinator
        
    }
    
    class Coordinator: NSObject,MKMapViewDelegate{
        
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
            
            if(annotation.identifier == "Recycling"){
                let image = UIImage(named: "mappin")
                
                let size = CGSize(width: 25, height: 25)
                UIGraphicsBeginImageContext(size)
                image!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                annotationView?.image = resizedImage
            }else{
                let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PIN_VIEW")
                pinAnnotation.tintColor = .red
                pinAnnotation.animatesDrop = true
                pinAnnotation.canShowCallout = true
                return pinAnnotation;
            }
            annotationView?.canShowCallout = true
            annotationView?.calloutOffset = CGPoint(x: -5, y: 5)
            //if dequeued cache it and hangnto it for performance
            
            return annotationView
            
            
            
            // Custom Pins....
            
            // Excluding User Blue Circle...
            
            //            if annotation.isKind(of: MKUserLocation.self){return nil}
            //            else{
            //                let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PIN_VIEW")
            //                pinAnnotation.tintColor = .red
            //                pinAnnotation.animatesDrop = true
            //                pinAnnotation.canShowCallout = true
            //
            //
            //                return pinAnnotation
            //            }
        }
        
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
    //        private func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKPolylineRenderer{
    //
    //
    //
    //            let render = MKPolylineRenderer(overlay: overlay)
    //            render.strokeColor = .orange
    //            render.lineWidth = 4
    //
    //            // Custom Pins....
    //
    //            // Excluding User Blue Circle...
    //
    //            return render;
    //
    //        }
    
}

//}
