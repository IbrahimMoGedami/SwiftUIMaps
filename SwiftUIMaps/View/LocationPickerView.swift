//
//  LocationPickerView.swift
//  SwiftUIMaps
//
//  Created by Ibrahim Gedami on 27/04/2025.
//

import SwiftUI
import CoreLocation
import MapKit

struct LocationPickerView: View {
    
    @Binding var isPresented: Bool
    var coordinates: (CLLocationCoordinate2D?) -> Void
    @StateObject var manager: LocationManager = .init()
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @Environment(\.openURL) private var openURL
    @FocusState private var isKeyboardActive: Bool
    @Namespace private var mapNamespace
    
    var body: some View {
        ZStack {
            if let isPermissionDenied = manager.isPermissionDenied {
                if isPermissionDenied {
                    noPermissionView()
                } else {
                    ZStack {
                        mapSearchResults()
                        
                        mapView()
                            .safeAreaInset(edge: .bottom , spacing: 0) {
                                mapSelectionLocationButton()
                            }
                            .opacity(manager.showSearchresult ? 0 : 1)
                            .ignoresSafeArea(.keyboard, edges: .all) // so important
                    }
                    
                    .safeAreaInset(edge: .top, spacing: 0) {
                        mapSearchBar()
                    }
                }
            } else {
                Group {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                    
                    ProgressView()
                }
            }
        }
        .onAppear { manager.requestUserLocation() }
        .animation(.easeInOut(duration: 0.25), value: manager.showSearchresult )
    }
    
    /// User permoission denied
    @ViewBuilder
    func noPermissionView() -> some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            
            Text("Please allow location permission\nin the app settings.")
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            /// Close Button
            Button {
                isPresented = false
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .padding(15)
                    .contentShape(.rect)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            /// Try again and Go To settings button
            VStack(spacing: 12) {
                Button("Try again", action: { manager.requestUserLocation() })
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Button {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        openURL(settingsURL)
                    }
                } label: {
                    Text("Go To Settings")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .foregroundStyle(.background)
                        .background(.primary, in: .rect(cornerRadius: 12))
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 10)
            }
        }
    }
    
    ///Map View
    @ViewBuilder
    func mapView() -> some View {
        Map(position: $manager.position) { 
            UserAnnotation()
        }
        .mapControls {
            MapUserLocationButton(scope: mapNamespace)
            MapCompass(scope: mapNamespace)
            MapPitchToggle(scope: mapNamespace)
        }
        .overlay  {
            Image(systemName: "pin.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35, height: 35)
                .foregroundStyle(.red.gradient)
            
            /// Centering the pin
                .offset(y: -17)
                .allowsHitTesting(false)
         }
        .mapScope(mapNamespace)
        .onMapCameraChange { ctx in
            manager.currentRegion = ctx.region
            selectedCoordinate = ctx.region.center
        }
    }
    
    ///Map Search
    @ViewBuilder
    func mapSearchBar() -> some View {
        VStack(spacing: 15) {
            Text("Select Location")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button {
                        if manager.showSearchresult {
                            isKeyboardActive = false
                            manager.clearSearch()
                            manager.showSearchresult = false
                        } else {
                            isPresented = false
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                            .contentShape(.rect)
                    }
                }
            
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                
                TextField("Search", text: $manager.searchLocationText)
                    .padding(.vertical, 10)
                    .focused($isKeyboardActive)
                    .submitLabel(.search)
                    .onSubmit {
                        if manager.searchLocationText.isEmpty {
                            manager.clearSearch()
                        } else {
                            manager.searchForPlaces()
                        }
                    }
                    .onChange(of: isKeyboardActive) { _, newValue in
                        if newValue {
                            manager.showSearchresult = true
                        }
                    }
                    .contentShape(.rect)
                
                if manager.showSearchresult {
                    Button {
                        // isKeyboardActive = false
                        /// Clearing search
                        manager.clearSearch()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.gray)
                    }
                    .opacity(manager.isSearching ? 0 : 1)
                    .overlay {
                        ProgressView()
                            .opacity(manager.isSearching ? 1 : 0)
                    }
                }
            }
            .padding(.horizontal, 15)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
        }
        .padding(15)
        .background(.background)
    }
    
    /// Map Search
    @ViewBuilder
    func mapSelectionLocationButton() -> some View {
        Button {
            isPresented = false
            coordinates(selectedCoordinate)
        } label: {
            Text("Select Location")
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
        }
        .padding(15)
        .background(.background)
    }
    
    ///Map Search results
    @ViewBuilder
    func mapSearchResults() -> some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                ForEach(manager.searchResult, id: \.self) { placeMark in
                    searchResultCardView(placeMark)
                }
            }
            .padding(15)
        }
        .frame(maxWidth: .infinity)
        .background(.background)
    }
    
    /// Search result card view     @ViewBuilder
    func searchResultCardView(_ placeMark: MKPlacemark ) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(placeMark.name ?? "")
                    
                    Text(placeMark.title ?? placeMark.subtitle ?? "")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                Spacer(minLength: 0)
                
                Image(systemName: "checkmark")
                    .font(.callout)
                    .foregroundStyle(.gray)
                    .opacity(manager.selectedResult == placeMark ? 1: 0 )
            }
            Divider()
        }
        .contentShape(.rect)
        .onTapGesture {
            isKeyboardActive = false
            /// Updating Map position
            manager.updatingMapPosition(placeMark)
        }
    }
    
}
