//
//  ContentView.swift
//  SwiftUIMaps
//
//  Created by Ibrahim Gedami on 12/04/2025.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            SearchView()
                .navigationBarHidden(true)
        }
    }
    
}

#Preview {
    ContentView()
}
