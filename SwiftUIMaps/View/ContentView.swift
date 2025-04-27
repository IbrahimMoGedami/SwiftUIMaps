//
//  ContentView.swift
//  SwiftUIMaps
//
//  Created by Ibrahim Gedami on 12/04/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showLocationPicker: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Button("Pick a location") {
                    showLocationPicker.toggle()
                }
                .locationPicker(isPresented: $showLocationPicker) { coordinates in
                    if let coordinates {
                        print(coordinates.latitude)
                        print(coordinates.longitude)
                    }
                }
            }
            .navigationTitle("Location Picker")
        }
    }
    
}

#Preview {
    ContentView()
}
