//
//  TrackedUser.swift
//  SwiftUIMaps
//
//  Created by Ibrahim Gedami on 12/04/2025.
//

import Foundation
import CoreLocation

struct TrackedUser: Identifiable {
    
    let id: String
    var coordinate: CLLocationCoordinate2D
    
}

struct IdentifiableLocation: Identifiable {
    
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
    
}
