//
//  View+Extensions.swift
//  SwiftUIMaps
//
//  Created by Ibrahim Gedami on 27/04/2025.
//

import SwiftUI
import CoreLocation
import MapKit

extension View {
    
    func locationPicker(isPresented: Binding<Bool>, coordinates: @escaping (CLLocationCoordinate2D?) -> Void) -> some View  {
        self.fullScreenCover(isPresented: isPresented) {
            LocationPickerView(isPresented: isPresented, coordinates: coordinates)
        }
    }
    
}
