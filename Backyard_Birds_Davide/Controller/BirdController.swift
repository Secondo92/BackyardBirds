//
//  BirdSpotController.swift
//  Backyard_Birds_Davide
//
//  Created by dmu mac 34 on 09/12/2024.
//

import SwiftUI
import FirebaseFirestore

@Observable
class BirdController {
    var birds = [Bird]()
    var selectedBirds = [Bird]()
    
    
    @ObservationIgnored
    private var firebaseService = FirebaseService()
    
    init(){
        firebaseService.setupListener(sortingMethod: {$0.date < $1.date}) { fetchBirds in
            self.birds = fetchBirds
        }
    }
    
    func add(bird: Bird){
        firebaseService.addBird(bird: bird)
    }
    
    func update(bird: Bird){
    }
    
    func delete(bird: Bird){
        firebaseService.deleteBird(bird: bird)
    }
    
    func imagePath(for bird: Bird) -> String? {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageName = "\(bird.id ?? UUID().uuidString).png"
        let imagePath = documentsURL.appendingPathComponent(imageName).path
        
        return fileManager.fileExists(atPath: imagePath) ? imagePath : nil
    }
    
    
    func fetchSpecies(species: Bird.Species) {
        firebaseService.fetchBirdsBySpecies(species: species) { birds in
            self.selectedBirds = birds
        }
    }
}
