//
//  ParkRow.swift
//  NPF-4
//
//  Created by Nolan Wira on 11/9/24.
//

import SwiftUI
import CoreLocation

struct ParkRow: View {
    let park: Park
    let userLocation: CLLocation?
    
    var distanceString: String {
        guard let userLocation = userLocation,
              let parkLocation = park.getLocation() else {
            return "Distance unavailable"
        }
        let distance = userLocation.distance(from: parkLocation) / 1609.34 // Convert to miles
        return String(format: "%.1f miles", distance)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hidden text here")
//  Did this as .padding(.leading, 20) applied to all the Text() will add padding to the separator line even though I have the following in ListPage.swift:
//      NavigationLink(destination: ParkDetailView(park: park)) {
//          ParkRow(park: park, userLocation: locationManager.location)
//      }
//      .padding(EdgeInsets(top: 0, leading: -20, bottom: 0, trailing: 0))
//  But I wanted to keep leading padding on the Text()s but remove it from the separator line so I did this workaround
                .frame(height: 0)
                .opacity(0)
                .clipped()
            
            Text(park.getParkName())
                .font(.headline)
                .padding(.leading, 20)
            Text(park.getParkLocation())
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.leading, 20)
            if userLocation != nil {
                Text(distanceString)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.leading, 20)
            }
            
            Text("Hidden text here")
                .frame(height: 0)
                .opacity(0)
                .clipped()
        }
    }
}

