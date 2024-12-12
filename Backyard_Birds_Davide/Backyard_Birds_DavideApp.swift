//
//  Backyard_Birds_DavideApp.swift
//  Backyard_Birds_Davide
//
//  Created by dmu mac 34 on 09/12/2024.
//

import SwiftUI
import FirebaseCore

@main
struct Backyard_Birds_DavideApp: App {

    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        @State var locationManager = LocationManager()
        @State var birdController = BirdController()

        WindowGroup {
            ContentView()
                .environment(locationManager)
                .environment(birdController)
        }
    }
}
