//
//  MapView.swift
//  SwiftUIMaps
//
//  Created by Ibrahim Gedami on 12/04/2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @StateObject private var locationManager = LocationManager()
    @State private var sourceLocation: IdentifiableLocation
    @State private var destinationLocation: IdentifiableLocation?
    @State private var trackingMode: MapUserTrackingMode = .followWithHeading
    @State private var route: MKRoute?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 31.2156, longitude: 31.2176),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var showSourceSearch = false
    @State private var showDestinationSearch = false
    
    var body: some View {
        VStack {
            Map(
                coordinateRegion: $region,
                showsUserLocation: true,
                userTrackingMode: $trackingMode,
                annotationItems: [sourceLocation]
            ) { location in
                Marker(location.coordinate, coordinate: .blue)
            }
            .onAppear {
                if let location = locationManager.currentLocation {
                    region.center = location.coordinate
                }
            }
            .onChange(of: locationManager.currentLocation) { newLocation in
                if let newLocation = newLocation {
                    region.center = newLocation.coordinate
                }
            }
            .overlay(
                VStack {
                    HStack {
                        // Source Button
                        Button(action: {
                            showSourceSearch.toggle()
                        }) {
                            Text("Select Source")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .sheet(isPresented: $showSourceSearch) {
                            // LocationSearchView(selectedLocation: $sourceLocation)
                        }
                        
                        Spacer()
                        
                        // Destination Button
                        Button(action: {
                            showDestinationSearch.toggle()
                        }) {
                            Text("Select Destination")
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .sheet(isPresented: $showDestinationSearch) {
                            LocationSearchView(selectedLocation: $destinationLocation)
                        }
                    }
                    .padding()
                    
                    // Button to draw the route
                    if sourceLocation != nil && destinationLocation != nil {
                        Button(action: {
                            drawRoute()
                        }) {
                            Text("Draw Route")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                    .padding(),
                alignment: .top
            )
            
            // Route display
            if let route = route {
                VStack {
                    Text("Route from Source to Destination")
                    Text("Distance: \(route.distance) meters")
                    Text("Time: \(route.expectedTravelTime / 60) minutes")
                }
                .padding()
            }
        }
        .onAppear {
            if let location = locationManager.currentLocation {
                region.center = location.coordinate
            }
        }
    }
    
    func drawRoute() {
        guard let destinationLocation = destinationLocation else { return }
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation.coordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation.coordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let route = response?.routes.first {
                self.route = route
            }
        }
    }
    
}
