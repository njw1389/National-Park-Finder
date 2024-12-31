//
//  FavoritesPage.swift
//  NPF-4
//
//  Created by Nolan Wira on 11/5/24.
//

import SwiftUI

struct FavoritesPage: View {
    @EnvironmentObject var parks: Parks
    @State private var editMode: EditMode = .inactive
    @Binding var selectedTab: Int
    @Binding var mapInitialPark: Park?
    
    var body: some View {
        NavigationView {
            Group {
                if parks.favorites.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "star.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No Favorites Yet")
                            .font(.title2)
                            .foregroundColor(.primary)
                        
                        Text("Add parks to your favorites by tapping the star button in the park details.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    List {
                        ForEach(parks.favorites, id: \.self) { parkName in
                            if let park = parks.getFavoritePark(name: parkName) {
                                NavigationLink(destination: ParkDetailView(park: park, selectedTab: $selectedTab, mapInitialPark: $mapInitialPark)) {
                                    Text(parkName)
                                }
                            }
                        }
                        .onDelete(perform: deleteFavorites)
                        .onMove(perform: moveFavorites)
                    }
                }
            }
            .navigationTitle("Favorites")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !parks.favorites.isEmpty {
                        EditButton()
                    }
                }
            }
            .environment(\.editMode, $editMode)
        }
    }
    
    private func deleteFavorites(at offsets: IndexSet) {
        parks.favorites.remove(atOffsets: offsets)
        UserDefaults.standard.set(parks.favorites, forKey: "favorites")
    }
    
    private func moveFavorites(from source: IndexSet, to destination: Int) {
        parks.favorites.move(fromOffsets: source, toOffset: destination)
        UserDefaults.standard.set(parks.favorites, forKey: "favorites")
    }
}
