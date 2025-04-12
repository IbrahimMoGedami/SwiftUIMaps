//
//  SwiftUIMapsApp.swift
//  SwiftUIMaps
//
//  Created by Ibrahim Gedami on 11/04/2025.
//

import SwiftUI

@main
struct SwiftUIMapsApp: App {
    var body: some Scene {
        WindowGroup {
            LiveMapView(locationManager: LocationManager(), trackingManager: TrackingManager())
        }
    }
}
