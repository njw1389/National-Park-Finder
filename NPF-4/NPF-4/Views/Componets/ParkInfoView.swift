//
//  ParkInfoView.swift
//  NPF-3
//
//  Created by Nolan Wira on 11/1/24.
//

import SwiftUI
import CoreLocation
import MapKit

struct ParkInfoView: View {
    let park: Park
    let userLocation: CLLocation?
    
    private var distanceString: String {
        guard let userLocation = userLocation,
              let parkLocation = park.getLocation() else {
            return "Distance unavailable"
        }
        
        let distance = userLocation.distance(from: parkLocation) / 1609.34 // Convert meters to miles
        return String(format: "%.1f miles away", distance)
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text(park.getParkName())
                .font(.title)
                .bold()
            
            Text(distanceString)
                .font(.subheadline)
            
            HStack(spacing: 20) {
                Button("View Wiki", systemImage: "info.square") {
                    if let url = URL(string: park.getLink()) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Button("Get Directions", systemImage: "map") {
                    if let location = park.getLocation() {
                        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
                        mapItem.name = park.getParkName()
                        let options = [
                            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
                        ]
                        mapItem.openInMaps(launchOptions: options)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
