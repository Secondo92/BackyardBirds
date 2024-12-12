//
//  ContentView.swift
//  Backyard_Birds_Davide
//
//  Created by dmu mac 34 on 09/12/2024.
//

import SwiftUI
import CoreLocation
import Firebase

struct ContentView: View {
    @State private var showingAddBirdView = false
    @State private var showingQuoteSheet = false
    @State private var isSortedAscending = false
    @State private var searchText: String = ""
    @Environment(BirdController.self) private var birdController
    
    var displayedBirds: [Bird] {
        var birds: [Bird]

        if !searchText.isEmpty {
            if let matchingSpecies = Bird.Species.allCases.first(where: { $0.rawValue.contains(searchText.lowercased()) }) {
                birdController.fetchSpecies(species: matchingSpecies)
                birds = birdController.selectedBirds
            } else {
                birds = []
            }
        } else {
            birds = birdController.birds
        }
        
        if isSortedAscending {
            birds.sort { $0.species.rawValue < $1.species.rawValue }
        } else {
            birds.sort { $0.species.rawValue > $1.species.rawValue }
        }
        
        return birds
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {	
                    ForEach(displayedBirds) { bird in
                        NavigationLink(destination:
                                        BirdDetailView(bird: bird))
                        {
                            HStack {
                                if let imageData = bird.imageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .overlay(Circle()
                                            .stroke(Color.white, lineWidth: 4))
                                        .shadow(radius: 10)
                                        .padding(10)
                                } else {
                                    Image("404birdnotfound")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .overlay(Circle()
                                            .stroke(Color.white, lineWidth: 4))
                                        .shadow(radius: 10)
                                        .padding(10)
                                }
                                Spacer()
                                VStack{
                                    HStack{
                                        Text(bird.species.rawValue.capitalized)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                        Spacer()
                                    }
                                    Text("Seen: \(bird.date.formatted(date: .numeric, time: .shortened))")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }}
                        }
                    }
                    .onDelete { indexSet in
                        let bird = birdController.birds[indexSet.first!]
                        birdController.delete(bird: bird)
                    }
                }
                .navigationBarTitle("Birds")
                .navigationBarItems(trailing: EditButton())
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isSortedAscending.toggle()
                        }) {
                            Image(systemName: "arrow.up.arrow.down")
                                .accessibilityLabel("Toggle Sort Order")
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Search species")
                
                HStack{
                    Button {
                        showingQuoteSheet = true
                    } label: {
                        Label("Show Quote", systemImage: "text.bubble")
                    }
                    .padding()
                    .sheet(isPresented: $showingQuoteSheet) {
                        QuoteView()
                        
                    }
                    Button {
                        showingAddBirdView = true
                    } label: {
                        Label("Add bird", systemImage: "plus.app")
                            .padding()
                    }
                    .padding()
                    .sheet(isPresented: $showingAddBirdView) {
                        AddNewBirdView().environment(birdController)
                    }
                }
            }
        }
    }
}
#Preview {
    ContentView().environment(BirdController())
}
