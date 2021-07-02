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
            
            

            
            // Custom Pins....
            
            // Excluding User Blue Circle...
            
            if annotation.isKind(of: MKUserLocation.self){return nil}
            else{
                let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PIN_VIEW")
                pinAnnotation.tintColor = .red
                pinAnnotation.animatesDrop = true
                pinAnnotation.canShowCallout = true
                
                return pinAnnotation
            }
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

            if let routePolyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: routePolyline)
                renderer.strokeColor = .orange
                renderer.lineWidth = 7
                return renderer
            }

            return MKOverlayRenderer()
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
}
