//
//  ListPage.swift
//  NPF-4
//
//  Created by Nolan Wira on 11/5/24.
//

import SwiftUI
import CoreLocation

struct ListPage: View {
    @EnvironmentObject var parks: Parks
    @StateObject private var locationManager = LocationManager()
    @State private var sortOrder = 0 // 0: A-Z, 1: Z-A, 2: Distance
    @Binding var selectedTab: Int
    @Binding var mapInitialPark: Park?
    
    var sortedParks: [Park] {
        switch sortOrder {
        case 0:
            return parks.items.sorted { $0.getParkName() < $1.getParkName() }
        case 1:
            return parks.items.sorted { $0.getParkName() > $1.getParkName() }
        case 2:
            return parks.items.sorted { park1, park2 in
                guard let userLocation = locationManager.location,
                      let location1 = park1.getLocation(),
                      let location2 = park2.getLocation() else {
                    return false
                }
                return location1.distance(from: userLocation) < location2.distance(from: userLocation)
            }
        default:
            return parks.items
        }
    }
    
    var body: some View {
        NavigationView {
            List(sortedParks) { park in
                NavigationLink(destination: ParkDetailView(park: park, selectedTab: $selectedTab, mapInitialPark: $mapInitialPark)) {
                    ParkRow(park: park, userLocation: locationManager.location)
                }
                .padding(EdgeInsets(top: 0, leading: -20, bottom: 0, trailing: 0))
            }
            .navigationTitle("National Parks")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("Sort", selection: $sortOrder) {
                        Text("A-Z").tag(0)
                        Text("Z-A").tag(1)
                        Text("Distance").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
        }
    }
}
