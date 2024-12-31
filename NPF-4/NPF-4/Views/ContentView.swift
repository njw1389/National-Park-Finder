//
//  ContentView.swift
//  NPF-4
//
//  Created by Nolan Wira on 11/5/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var mapInitialPark: Park?
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MapPage(initialPark: mapInitialPark)
                .tag(0)
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
                .onChange(of: selectedTab) { oldValue, newValue in
                    if newValue != 0 {
                        // Add a 0.05-second delay before clearing the initial park so the user doesn't see a glimpse of the map zooming out.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            mapInitialPark = nil
                        }
                    }
                }
            
            ListPage(selectedTab: $selectedTab, mapInitialPark: $mapInitialPark)
                .tag(1)
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
            
            FavoritesPage(selectedTab: $selectedTab, mapInitialPark: $mapInitialPark)
                .tag(2)
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
            
            AboutPage()
                .tag(3)
                .tabItem {
                    Label("About", systemImage: "info.circle.fill")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Parks())
//        .preferredColorScheme(.dark)
}
