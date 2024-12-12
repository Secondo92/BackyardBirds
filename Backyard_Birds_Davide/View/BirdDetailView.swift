import SwiftUI
import MapKit

struct BirdDetailView: View {
    @Environment(BirdController.self) private var birdController
    @State private var cameraPosition: MapCameraPosition
    @State private var birdImage: UIImage?

    let bird: Bird

    init(bird: Bird) {
        self.bird = bird
        _cameraPosition = State(initialValue: .camera(
            MapCamera(
                centerCoordinate: bird.coordinate,
                distance: 1000,
                heading: 0,
                pitch: 0
            )
        ))
    }

    var body: some View {
        VStack {
            HStack {
                
                Text(bird.species.rawValue.capitalized)
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                Spacer()
                
                Text("Seen: \(bird.date.formatted(date: .numeric, time: .shortened))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
              
            MapReader { mapProxy in
                Map(position: $cameraPosition, interactionModes: [.all]) {
                    Marker(bird.species.rawValue, coordinate: bird.coordinate)
                }
                .frame(height: 250)
                .cornerRadius(15)
                .shadow(radius: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            }
            
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.blue)
                Text("\(bird.coordinate.latitude), \(bird.coordinate.longitude)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }.padding(10)

            if let imageData = bird.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            } else {
                Image("404birdnotfound")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }

            Text(bird.note)
                .font(.body)
        }
        .padding()
        .navigationTitle(bird.species.rawValue.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadBirdImage()
        }
    }

    private func loadBirdImage() {
        if let imagePath = birdController.imagePath(for: bird),
           let uiImage = UIImage(contentsOfFile: imagePath) {
            birdImage = uiImage
        } else {
            birdImage = nil
        }
    }
}

#Preview {
    BirdDetailView(
        bird: Bird(
            species: .robin,
            date: Date(),
            note: "A dumbass robin near the park.",
            location: Bird.Location(
                coordinates: Bird.Coordinates(latitude: "56.162939", longitude: "10.203921"))
            )).environment(BirdController())
}
