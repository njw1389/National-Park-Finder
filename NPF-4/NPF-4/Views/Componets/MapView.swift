//
//  MapView.swift
//  NPF-3
//
//  Created by Nolan Wira on 11/1/24.
//

import SwiftUI
import MapKit

struct MapTypeSelect {
    var title: String
    var map: MapStyle
}

struct MapView: View {
    @Binding var parks: [Park]
    @StateObject var locationManager: LocationManager
    @State private var selectedPark: Park?
    @State private var showingParkInfo = false
    @State private var mapType: MapStyle = .standard
    @State private var selectedSegment = 0
    @State private var mapSelect = [
        MapTypeSelect(title: "Standard", map: .standard),
        MapTypeSelect(title: "Satellite", map: .imagery),
        MapTypeSelect(title: "Hybrid", map: .hybrid)
    ]
    @State private var camera: MapCameraPosition = .automatic
    let initialPark: Park?
    
    init(parks: Binding<[Park]>, locationManager: LocationManager, initialPark: Park? = nil) {
        self._parks = parks
        self._locationManager = StateObject(wrappedValue: locationManager)
        self.initialPark = initialPark
            
        // Set initial camera position based on initialPark
        if let park = initialPark, let location = park.getLocation() {
            self._camera = State(initialValue: .region(MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )))
        } else {
            self._camera = State(initialValue: .automatic)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Map(position: $camera, selection: $selectedPark) {
                // User location
                if locationManager.location != nil {
                    UserAnnotation()
                }
                
                // Park markers
                ForEach(parks) { park in
                    if let location = park.getLocation() {
                        Marker(park.getParkName(), systemImage: "tree.circle", coordinate: location.coordinate)
                            .tint(.purple)
                            .tag(park)
                    }
                }
            }
            .mapStyle(mapType)
            .mapControls {
                MapUserLocationButton()
            }
            .onAppear {
                if let park = initialPark {
                    selectedPark = park
                    showingParkInfo = true
                }
                
                // Ensure camera position is set to zoom in on the park
                if let park = selectedPark, let location = park.getLocation() {
                    camera = .region(MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    ))
                }
            }
            .onChange(of: selectedSegment) {
                mapType = mapSelect[selectedSegment].map
            }
            .onChange(of: initialPark) { oldValue, newValue in
                if newValue == nil {
                    // Reset the map when initialPark is cleared
                    selectedPark = nil
                    showingParkInfo = false
                    withAnimation {
                        camera = .automatic
                    }
                }
            }
            .onChange(of: selectedPark) {
                let wasShowingInfo = showingParkInfo
                showingParkInfo = selectedPark != nil
                
                // When a park is selected, zoom in on it
                if let park = selectedPark, let location = park.getLocation() {
                    withAnimation {
                        camera = .region(MKCoordinateRegion(
                            center: location.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        ))
                    }
                } else if wasShowingInfo { // Park was deselected
                    // Zoom out to show all parks
                    withAnimation {
                        camera = .automatic
                    }
                }
            }
            
            VStack {
                // Info view container
                if showingParkInfo, let selectedPark = selectedPark {
                    ParkInfoView(park: selectedPark, userLocation: locationManager.location)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: showingParkInfo)
                        .padding()
                }
                
                // Controls
                HStack {
                    Button(action: {
                        camera = .automatic
                    }) {
                        Image(systemName: "minus.magnifyingglass")
                            .foregroundColor(.white)
                            .frame(width: 34, height: 32)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    
                    Spacer()
                        .frame(width: 8)
                    
                    Picker(selection: $selectedSegment, label: EmptyView()) {
                        ForEach(Array(mapSelect.enumerated()), id: \.element.title) { index, mapType in
                            Text(mapType.title).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
        }
    }
}
