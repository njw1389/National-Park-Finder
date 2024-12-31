//
//  NPF_4App.swift
//  NPF-4
//
//  Created by Nolan Wira on 11/5/24.
//

import SwiftUI

@main
struct NPF_4App: App {
    @StateObject private var parks = Parks()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(parks)
        }
    }
}
