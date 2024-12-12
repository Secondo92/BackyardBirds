import SwiftUI
import PhotosUI
import CoreLocation

struct AddNewBirdView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Environment(BirdController.self) var birdController
    
    @State private var locationManager = LocationManager()
    
    @State private var selectedSpecies: Bird.Species = .blackbird
    @State private var note: String = ""
    
    @State private var selectedImage: UIImage?
    @State private var selectedPhotoItem: PhotosPickerItem?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Species")) {
                    Picker("Select Species", selection: $selectedSpecies) {
                        ForEach(Bird.Species.allCases, id: \.self) { species in
                            Text(species.rawValue.capitalized).tag(species)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Note")) {
                    TextField("Note", text: $note)
                }

                Section(header: Text("Picture")) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    } else {
                        Text("No picture selected")
                            .foregroundColor(.secondary)
                    }

                    PhotosPicker(selection: $selectedPhotoItem,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        Label("Select Picture from Library", systemImage: "photo.on.rectangle")
                            .padding()
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .onChange(of: selectedPhotoItem) { oldValue, newValue in
                        Task {
                            if let data = try? await newValue?.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                self.selectedImage = image
                            }
                        }
                    }

                }
            }
            .navigationTitle("Add New Bird")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Add") {
                    let imageData = selectedImage

                    let newBird = Bird(
                        species: selectedSpecies,
                        date: Date(),
                        note: note,
                        location: Bird.Location(
                            coordinates: Bird.Coordinates(
                                latitude: String(locationManager.lastLocation?.coordinate.latitude ?? 0.0),
                                longitude: String(locationManager.lastLocation?.coordinate.longitude ?? 0.0)
                            )
                        ),
                        imageData: imageData?.jpegData(compressionQuality: 0.25)
                    )
                    birdController.add(bird: newBird)
                    dismiss()
                }
            )
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                locationManager.startLocationUpdates()
            }
        }
    }
}

#Preview {
    AddNewBirdView().environment(BirdController())
}
