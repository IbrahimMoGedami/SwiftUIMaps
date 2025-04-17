//
//  MapView.swift
//  SwiftUIMaps
//
//  Created by Ibrahim Gedami on 17/04/2025.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator
        
        let source = CLLocationCoordinate2D.mansouraUniversity
        let destination = CLLocationCoordinate2D.geziretElWard
        let region = MKCoordinateRegion(center: source, latitudinalMeters: 10000, longitudinalMeters: 10000)
        map.setRegion(region, animated: false)
        
        // Annotations
        let sourcePin = MKPointAnnotation()
        sourcePin.coordinate = source
        sourcePin.title = "Mansoura University"
        map.addAnnotation(sourcePin)
        
        let destinationPin = MKPointAnnotation()
        destinationPin.coordinate = destination
        destinationPin.title = "Geziret El Ward"
        map.addAnnotation(destinationPin)
        
        // Request route
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile
        
        MKDirections(request: request).calculate { response, error in
            if let error = error {
                debugPrint("Directions error:", error.localizedDescription)
                return
            }
            
            if let route = response?.routes.first {
                map.addOverlay(route.polyline)
                map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            } else {
                debugPrint("No route found.")
            }
        }
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .magenta
            renderer.lineWidth = 2
            return renderer
        }
    }
    
}
