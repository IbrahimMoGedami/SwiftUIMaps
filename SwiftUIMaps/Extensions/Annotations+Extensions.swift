//
//  Annotations+Extensions.swift
//  SwiftUIMaps
//
//  Created by Ibrahim Gedami on 11/04/2025.
//

import SwiftUI
import MapKit

@MainActor
struct MansouraAnnotations {
    
    static func mansouraUniversity<Content: View>(@ViewBuilder content: @escaping () -> Content) -> Annotation<Text, Content> {
        Annotation("Mansoura University", coordinate: .mansouraUniversity, anchor: .center, content: content)
    }
    
    static func mansouraUniversityHospitals<Content: View>(@ViewBuilder content: @escaping () -> Content) -> Annotation<Text, Content> {
        Annotation("University Hospitals", coordinate: .mansouraUniversityHospitals, anchor: .center, content: content)
    }
    
    static func alShohadaaSquare<Content: View>(@ViewBuilder content: @escaping () -> Content) -> Annotation<Text, Content> {
        Annotation("Al-Shohadaa Square", coordinate: .alShohadaaSquare, anchor: .center, content: content)
    }
    
    static func elGomhoriaStreet<Content: View>(@ViewBuilder content: @escaping () -> Content) -> Annotation<Text, Content> {
        Annotation("El Gomhoria Street", coordinate: .elGomhoriaStreet, anchor: .center, content: content)
    }
    
    static func geziretElWard<Content: View>(@ViewBuilder content: @escaping () -> Content) -> Annotation<Text, Content> {
        Annotation("Geziret El Ward", coordinate: .geziretElWard, anchor: .center, content: content)
    }
    
}
