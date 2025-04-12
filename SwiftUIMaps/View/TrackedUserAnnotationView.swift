//
//  TrackedUserAnnotationView.swift
//  SwiftUIMaps
//
//  Created by Ibrahim Gedami on 12/04/2025.
//

import SwiftUI

struct TrackedUserAnnotationView: View {
    
    var body: some View {
        Image(systemName: "person.circle.fill")
            .foregroundStyle(.blue)
            .font(.title)
            .background(Circle().fill(Color.white))
    }
    
}

