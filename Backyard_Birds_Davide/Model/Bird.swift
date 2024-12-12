//
//  Bird.swift
//  Backyard_Birds_Davide
//
//  Created by dmu mac 34 on 09/12/2024.
//

import Foundation
import FirebaseFirestore
import CoreLocation

struct Bird: Identifiable, Codable {
    @DocumentID var id: String?
    let species: Species
    let date: Date
    let note: String
    let location: Location
    var imageData: Data?


    struct Location: Codable {
        let coordinates: Coordinates
    }
        
        struct Coordinates: Codable {
            let latitude: String
            let longitude: String
        }
    
    var coordinate: CLLocationCoordinate2D {
        if let latitude = Double(location.coordinates.latitude),
           let longitude = Double(location.coordinates.longitude) {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            return CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        }
    }
    

    enum Species: String, CaseIterable, Codable {
        case robin, bluejay, cardinal, sparrow, blackbird
    }
}
