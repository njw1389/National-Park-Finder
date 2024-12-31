//
//  LocationManager.swift
//  NPF-3
//
//  Created by Nolan Wira on 11/1/24.
//

import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var region = MKCoordinateRegion()
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var lastError: Error?
    @Published var permissionsError = false
    @Published var locationError = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func startCurrentLocationUpdates() async throws {
        // Check current authorization status
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            permissionsError = false
            locationManager.startUpdatingLocation()
            
        case .denied, .restricted:
            permissionsError = true
            throw NSError(domain: "LocationManager",
                         code: 1,
                         userInfo: [NSLocalizedDescriptionKey: "Location permissions denied"])
            
        case .notDetermined:
            // Wait for user response to permission request
            locationManager.requestWhenInUseAuthorization()
            
        @unknown default:
            permissionsError = true
            throw NSError(domain: "LocationManager",
                         code: 2,
                         userInfo: [NSLocalizedDescriptionKey: "Unknown authorization status"])
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        self.region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
        locationError = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.lastError = error
        self.locationError = true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            permissionsError = false
            locationManager.startUpdatingLocation()
            
        case .denied, .restricted:
            permissionsError = true
            locationManager.stopUpdatingLocation()
            
        case .notDetermined:
            // Wait for user response
            break
            
        @unknown default:
            permissionsError = true
        }
    }
}
