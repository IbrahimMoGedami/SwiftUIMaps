//
//  MainViewModel.swift
//  SwiftUIMaps
//
//  Created by Ibrahim Gedami on 11/04/2025.
//

import Foundation
import MapKit
import _MapKit_SwiftUI

class MainViewModel: ObservableObject {
    
    @Published var mapCameraPosition: MapCameraPosition = .region(
        .init(center: .init(latitude: 31.0364, longitude: 31.3807),
              latitudinalMeters: 1300, longitudinalMeters: 1300)
    )
    
}
