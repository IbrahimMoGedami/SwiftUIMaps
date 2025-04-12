//
//  LiveMapView.swift
//  SwiftUIMaps
//
//  Created by Ibrahim Gedami on 12/04/2025.
//

import MapKit
import SwiftUI

struct LiveMapView: View {
    
    @ObservedObject var locationManager: LocationManager
    @ObservedObject var trackingManager: TrackingManager
    
    @State private var cameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 30.0, longitude: 31.0),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(trackingManager.trackedUsers) { user in
                Annotation("User \(user.id)", coordinate: user.coordinate) {
                    TrackedUserAnnotationView()
                }
            }
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
        .onAppear {
            locationManager.requestAuthorization()
        }
        .onReceive(locationManager.$currentLocation) { location in
            if let location = location {
                withAnimation {
                    cameraPosition = .region(
                        MKCoordinateRegion(
                            center: location.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )
                    )
                }
            }
        }
    }

}
