//
//  FirebaseService.swift
//  Backyard_Birds_Davide
//
//  Created by dmu mac 34 on 09/12/2024.
//

import Foundation
import FirebaseFirestore

struct FirebaseService {
    
    private let dbCollection = Firestore.firestore().collection("birds")
    private var listener: ListenerRegistration?

    mutating func setupListener(sortingMethod: @escaping (Bird, Bird) -> Bool, callback: @escaping ([Bird]) -> Void){
        listener = dbCollection.addSnapshotListener(includeMetadataChanges: true)
        {querySnapshot, error in
            guard let documents = querySnapshot?.documents
            else {
                print("No documents")
                return
            }
            let birds = documents.compactMap {
                queryDocumentSnapshot -> Bird? in
                return try? queryDocumentSnapshot.data(as: Bird.self)
            }
            callback(birds.sorted(by: sortingMethod))
        }
    }
    func fetchBirdsBySpecies(species: Bird.Species, callback: @escaping ([Bird])-> Void){
        dbCollection.whereField("species", isEqualTo: species.rawValue)
            .getDocuments { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("No documents for specie \(species.rawValue)")
                    return
                }
                let birds = documents.compactMap { queryDocumentSnapshot -> Bird? in
                    return try? queryDocumentSnapshot.data(as: Bird.self)
                }
                callback(birds.sorted { $0.species.rawValue < $1.species.rawValue })
            }
    }
    
    mutating func tearDownListener(){
        listener?.remove()
        listener = nil
    }
    
    func addBird(bird: Bird){
        do {
            let _ = try dbCollection.addDocument(from: bird.self)
        } catch {
            print(error)
        }
    }
    
    func deleteBird(bird: Bird) {
        guard let documentID = bird.id else { return }
        dbCollection.document(documentID).delete(){ error in
            if let error {
                print(error)
            }
        }
    }
    
}
