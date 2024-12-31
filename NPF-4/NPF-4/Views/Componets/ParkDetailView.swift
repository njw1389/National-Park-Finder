//
//  ParkDetailView.swift
//  NPF-4
//
//  Created by Nolan Wira on 11/6/24.
//

import SwiftUI
import CoreLocation
import MapKit

struct ParkDetailView: View {
    let park: Park
    @EnvironmentObject var parks: Parks
    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) var dismiss
    @Binding var selectedTab: Int
    @Binding var mapInitialPark: Park?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageUrl = URL(string: park.getImageLink()) {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxHeight: 200)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(park.getParkName())
                        .font(.title)
                        .bold()
                    
                    Text(park.getParkLocation())
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text("Description")
                        .font(.headline)
                    Text(park.getParkDescription())
                    
                    Divider()
                    
                    Group {
                        InfoRow(title: "Date Formed", value: park.getDateFormed())
                        InfoRow(title: "Area", value: park.getArea())
                    }
                    
                    Divider()
                    
                    HStack {
                        Button(action: {
                            if let url = URL(string: park.getLink()) {
                                openURL(url)
                            }
                        }) {
                            Label("View Wiki", systemImage: "safari")
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Spacer()
                        
                        Button(action: {
                            parks.toggleFavorite(parkName: park.getParkName())
                        }) {
                            Label(
                                parks.isFavorite(parkName: park.getParkName()) ? "Remove from Favorites" : "Add to Favorites",
                                systemImage: parks.isFavorite(parkName: park.getParkName()) ? "star.fill" : "star"
                            )
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    Button(action: {
                        mapInitialPark = park
                        dismiss()
                        selectedTab = 0
                    }) {
                        Label("View On Map", systemImage: "map")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}
