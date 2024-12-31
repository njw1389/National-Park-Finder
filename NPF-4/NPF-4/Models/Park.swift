//
//  Park.swift
//  NPF-3
//
//  Created by Nolan Wira on 11/1/24.
//

import CoreLocation
import MapKit

class Park: NSObject, Identifiable {
    let id = UUID()
    private var parkName: String = ""
    private var parkLocation: String = ""
    private var dateFormed: String = ""
    private var area: String = ""
    private var link: String = ""
    private var location: CLLocation?
    private var imageLink: String = ""
    private var parkDescription: String = ""
    private var imageName: String = ""
    private var imageSize: String = ""
    private var imageType: String = ""
    
    override var description: String {
        return """
        {
            id: \(id)
            parkName: \(parkName)
            parkLocation: \(parkLocation)
            dateFormed: \(dateFormed)
            area: \(area)
            link: \(link)
            location: \(location == nil ? "nil" : String(describing: location!))
            imageLink: \(imageLink)
            parkDescription: \(parkDescription)
            imageName: \(imageName)
            imageSize: \(imageSize)
            imageType: \(imageType)
        }
        """
    }
    
    func getParkName() -> String { return parkName }
    func getParkLocation() -> String { return parkLocation }
    func getDateFormed() -> String { return dateFormed }
    func getArea() -> String { return area }
    func getLink() -> String { return link }
    func getLocation() -> CLLocation? { return location }
    func getImageLink() -> String { return imageLink }
    func getParkDescription() -> String { return parkDescription }
    func getImageName() -> String { return imageName }
    func getImageSize() -> String { return imageSize }
    func getImageType() -> String { return imageType }
    
    func set(parkName: String) {
        let trimmedName = parkName.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedName.count >= 3 && trimmedName.count <= 75 && !trimmedName.isEmpty {
            self.parkName = trimmedName
        } else {
            print("Bad value of \(parkName) in set(parkName): setting to TBD")
            self.parkName = "TBD"
        }
    }
    
    func set(parkLocation: String) {
        let trimmedLocation = parkLocation.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedLocation.count >= 3 && trimmedLocation.count <= 75 && !trimmedLocation.isEmpty {
            self.parkLocation = trimmedLocation
        } else {
            print("Bad value of \(parkLocation) in set(parkLocation): setting to TBD")
            self.parkLocation = "TBD"
        }
    }
    
    func set(dateFormed: String) { self.dateFormed = dateFormed }
    func set(area: String) { self.area = area }
    func set(link: String) { self.link = link }
    func set(location: CLLocation?) { self.location = location }
    func set(imageLink: String) { self.imageLink = imageLink }
    func set(parkDescription: String) { self.parkDescription = parkDescription }
    func set(imageName: String) { self.imageName = imageName }
    func set(imageSize: String) { self.imageSize = imageSize }
    func set(imageType: String) { self.imageType = imageType }
    
    override convenience init() {
        self.init(parkName: "Unknown", parkLocation: "Unknown", dateFormed: "Unknown",
                 area: "Unknown", link: "Unknown", location: nil, imageLink: "Unknown",
                 parkDescription: "Unknown", imageName: "Unknown", imageSize: "Unknown",
                 imageType: "Unknown")
    }
    
    init(parkName: String, parkLocation: String, dateFormed: String, area: String,
         link: String, location: CLLocation?, imageLink: String, parkDescription: String,
         imageName: String, imageSize: String, imageType: String) {
        super.init()
        set(parkName: parkName)
        set(parkLocation: parkLocation)
        set(dateFormed: dateFormed)
        set(area: area)
        set(link: link)
        set(location: location)
        set(imageLink: imageLink)
        set(parkDescription: parkDescription)
        set(imageName: imageName)
        set(imageSize: imageSize)
        set(imageType: imageType)
    }
}

extension Park: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
    var title: String? {
        return parkName
    }
    
    var subtitle: String? {
        return parkLocation
    }
}
