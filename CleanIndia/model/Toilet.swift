//
/*
Toilet.swift
Created on: 7/19/18

Abstract:
 this represents single toilet model

*/

import Foundation
import MapKit

final class Toilet: NSObject, Codable, MKAnnotation {
    var address: String?
    var geometry: Geometry? = nil
    var name: String?
    var rating: Int? = nil
    
    enum CodingKeys: String, CodingKey {
        case address = "formatted_address"
        case name
        case geometry
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(geometry!.location.latitude, geometry!.location.longitude)
    }
    
    
    // Title and subtitle for use by selection UI.
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return address
    }
}

struct Geometry: Codable {
    var location: Location
}

struct Location: Codable {
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
}
