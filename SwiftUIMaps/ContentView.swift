//
//  ContentView.swift
//  SwiftUIMaps
//
//  Created by Ibrahim Gedami on 11/04/2025.
//

import SwiftUI
import MapKit

struct MainMapView: View {
    
    @StateObject private var viewModel = MainViewModel()
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        Map(position: $viewModel.mapCameraPosition) {
            Marker("Geziret ElWard",
                   systemImage: "tree.fill",
                   coordinate: .geziretElWard)
            .tint(.green)
            Marker("ElGomhoria Street",
                   systemImage: "marker",
                   coordinate: .elGomhoriaStreet)
            .tint(.purple)
            
            MansouraAnnotations.alShohadaaSquare {
                Image(systemName: "tree.fill")
                    .foregroundStyle(.blue)
            }
            
            UserAnnotation()
        }
        .onAppear {
            locationManager.requestAuthorization()
        }
    }
    
}

#Preview { MainMapView() }
