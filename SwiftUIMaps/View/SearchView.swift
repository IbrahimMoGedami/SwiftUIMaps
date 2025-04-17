//
//  SearchView.swift
//  SwiftUIMaps
//
//  Created by Ibrahim Gedami on 12/04/2025.
//

import SwiftUI
import MapKit

struct LocationSearchView: View {
    
    @Binding var selectedLocation: IdentifiableLocation?
    @State private var query: String = ""
    @State private var searchResults: [MKMapItem] = []
    
    var body: some View {
        VStack {
            TextField("Search for a location", text: $query, onCommit: {
                searchLocations(query: query)
            })
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            List(searchResults, id: \.self) { mapItem in
                Button(action: {
                    selectedLocation = IdentifiableLocation(coordinate: mapItem.placemark.coordinate)
                }) {
                    Text(mapItem.name ?? "Unknown")
                }
            }
        }
        .padding()
    }
    
    func searchLocations(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let response = response {
                searchResults = response.mapItems
            }
        }
    }

}
