//
//  Parks.swift
//  NPF-4
//
//  Created by Nolan Wira on 11/6/24.
//

import SwiftUI
import CoreLocation

class Parks: ObservableObject {
    @Published var items: [Park] = []
    @Published var favorites: [String] = []
    
    init() {
        loadParks()
        loadFavorites()
    }
    
    private func loadParks() {
        if let path = Bundle.main.path(forResource: "data", ofType: "plist") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let tempDict = try PropertyListSerialization.propertyList(from: data, format: nil) as! [String: Any]
                let tempArray = tempDict["parks"] as! Array<[String: Any]>
                
                for dict in tempArray {
                    let parkName = dict["parkName"]! as! String
                    let parkLocation = dict["parkLocation"]! as! String
                    let latitude = Double(dict["latitude"]! as! String)!
                    let longitude = Double(dict["longitude"]! as! String)!
                    let location = CLLocation(latitude: latitude, longitude: longitude)
                    let area = dict["area"] as? String ?? "Unknown Area"
                    let link = dict["link"] as? String ?? "Unknown Link"
                    let imageLink = dict["imageLink"] as? String ?? ""
                    let parkDescription = dict["description"] as? String ?? "No description available"
                    let dateFormed = dict["dateFormed"] as? String ?? "Unknown Date"
                    let imageName = dict["imageName"] as? String ?? "Unknown Image Name"
                    let imageSize = dict["imageSize"] as? String ?? "Unknown Size"
                    let imageType = dict["imageType"] as? String ?? "Unknown Type"
                    
                    let park = Park(parkName: parkName,
                                  parkLocation: parkLocation,
                                  dateFormed: dateFormed,
                                  area: area,
                                  link: link,
                                  location: location,
                                  imageLink: imageLink,
                                  parkDescription: parkDescription,
                                  imageName: imageName,
                                  imageSize: imageSize,
                                  imageType: imageType)
                    items.append(park)
                }
            } catch {
                print(error)
            }
        }
    }
    
    private func loadFavorites() {
        favorites = UserDefaults.standard.stringArray(forKey: "favorites") ?? []
    }
    
    func toggleFavorite(parkName: String) {
        if favorites.contains(parkName) {
            favorites.removeAll { $0 == parkName }
        } else {
            favorites.append(parkName)
        }
        UserDefaults.standard.set(favorites, forKey: "favorites")
    }
    
    func isFavorite(parkName: String) -> Bool {
        return favorites.contains(parkName)
    }
    
    func getFavoritePark(name: String) -> Park? {
        return items.first { $0.getParkName() == name }
    }
}
