//
//  TrackingManager.swift
//  SwiftUIMaps
//
//  Created by Ibrahim Gedami on 12/04/2025.
//

import Foundation
import CoreLocation

final class TrackingManager: ObservableObject {
    
    @Published var trackedUsers: [TrackedUser] = []
    
    func updateUserLocation(id: String, coordinate: CLLocationCoordinate2D) {
        if let index = trackedUsers.firstIndex(where: { $0.id == id }) {
            trackedUsers[index].coordinate = coordinate
        } else {
            trackedUsers.append(TrackedUser(id: id, coordinate: coordinate))
        }
    }
    
}
