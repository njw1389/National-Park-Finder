//
//  MapPage.swift
//  NPF-4
//
//  Created by Nolan Wira on 11/5/24.
//


import SwiftUI
import CoreLocation

struct MapPage: View {
    @EnvironmentObject var parks: Parks
    @StateObject private var locationManager = LocationManager()
    let initialPark: Park?

    var body: some View {
        MapView(parks: .constant(parks.items), locationManager: locationManager, initialPark: initialPark)
            .alert("Location Permission Required", isPresented: $locationManager.permissionsError) {
                Button("Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Please enable location services to use this app")
            }
            .alert("Location Error", isPresented: $locationManager.locationError) {
                Button("OK", role: .cancel) {}
            } message: {
                if let error = locationManager.lastError {
                    Text(error.localizedDescription)
                } else {
                    Text("Unable to determine your location")
                }
            }
    }
}
