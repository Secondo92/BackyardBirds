//
//  LocationManager.swift
//  iMapTM
//
//  Created by dmu mac 34 on 27/09/2024.
//
import CoreLocation

@Observable
@MainActor
class LocationManager {
    private let manager: CLLocationManager
    var lastLocation: CLLocation? = nil
    
    // Det er først når jeg kalder init at jeg ved at klassen kører på mainactor.
    // Uden init kalder den superklassen.
    init(){
        self.manager = CLLocationManager()
        self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.manager.requestWhenInUseAuthorization()
        //self.manager.startUpdatingLocation()
    }
    
    func startLocationUpdates() {
        Task {
            do {
                let updates = CLLocationUpdate.liveUpdates() // Når denne linje er færdige får jeg alle
                // updates i en array, og først der kan nedenstående kode fortsætte
                for try await update in updates {
                    if let loc = update.location {
                        self.lastLocation = loc
                    }
                }
            } catch {
                return
            }
        }
    }
    
}

