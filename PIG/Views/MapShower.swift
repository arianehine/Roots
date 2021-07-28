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
        return Coordinator()
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
