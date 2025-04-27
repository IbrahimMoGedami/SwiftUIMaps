//
//  LocationManager.swift
//  SwiftUIMaps
//
//  Created by Ibrahim Gedami on 11/04/2025.
//

import Foundation
import CoreLocation
import Combine
import _MapKit_SwiftUI

class LocationManager: NSObject, ObservableObject {
    
    private let locationManager: CLLocationManager = .init()
    
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var currentLocation: CLLocation?
    @Published var isPermissionDenied: Bool?
    @Published var searchLocationText = ""
    @Published var searchResult: [MKPlacemark] = []
    @Published var selectedResult: MKPlacemark?
    @Published var showSearchresult: Bool = false
    @Published var isSearching: Bool = false
    
    /// Map Propeities
    @Published var currentRegion: MKCoordinateRegion?
    @Published var position: MapCameraPosition = .automatic
    @Published var userCoordinates: CLLocationCoordinate2D?
    
    override init() {
        self.authorizationStatus = locationManager.authorizationStatus
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdating() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        locationManager.stopUpdatingLocation()
    }
    
    func requestUserLocation() {
        requestAuthorization()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        guard status != .notDetermined else { return }
        isPermissionDenied = status == .denied
        if status != .denied {
            /// Fetch Locations
            startUpdating()
        }
        authorizationStatus = manager.authorizationStatus
        
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            startUpdating()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinates = locations.first?.coordinate else { return }
        
        /// Updating  MapCamera Position and User Coordinates
        userCoordinates = coordinates
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        position = .region(region)
        /// Stop Updating
        stopUpdating()
        currentLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
    func searchForPlaces() {
        guard let currentRegion else { return }
        
        Task { @MainActor in
            isSearching = true
            
            let request = MKLocalSearch.Request()
            request.region = currentRegion
            request.naturalLanguageQuery = searchLocationText
            
            guard let response = try? await MKLocalSearch(request: request).start() else {
                isSearching = false
                return
            }
            searchResult = response.mapItems.compactMap({ $0.placemark })
            isSearching = false
        }
    }
    
    func updatingMapPosition(_ placemark: MKPlacemark)  {
        let coordinate = placemark.coordinate
        let region = MKCoordinateRegion(center: coordinate , latitudinalMeters: 1000, longitudinalMeters: 1000)
        position = .region(region)
        selectedResult = placemark
        showSearchresult = false
    }
    
    func clearSearch() {
        searchLocationText = ""
        searchResult = []
    }
    
}
