

import SwiftUI

struct SecondDishDetailView: View {
    let second: Second
    
    
    var body: some View {
        ScrollView {
            LazyVStack {
                Text(second.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                AsyncImage(url: URL(string: second.image)) { state in
                    switch state {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                    case .failure:
                        Text("Error al cargar la imagen")
                    @unknown default:
                        EmptyView()
                    }
                }

                Section(header: Text("Ingredientes").font(.headline)) {
                    ForEach(second.details.ingredients, id: \.self) { ingredient in
                        Text(ingredient)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 2)
                            
                    }
                }

                Section(header: Text("Elaboración").font(.headline)) {
                    Text(second.details.elaboration)
                }

                Section(header: Text("Alergias").font(.headline)) {
                    RemoteImage(url: second.details.imgAllergies)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                }

                if let videoID = extractYouTubeID(from: second.details.urlVideo) {
                    VideoPlayer(ID: videoID)
                } else {
                    Text("Video no disponible")
                }
            }
            .padding()
        }
        .navigationBarTitle("Detalle de la Receta", displayMode: .inline)
    }
    func extractYouTubeID(from url: String) -> String? {
            // Suponiendo que la URL es algo como "https://www.youtube.com/watch?v=VIDEOID" o "https://youtu.be/VIDEOID"
            if let urlComponents = URLComponents(string: url),
               let queryItems = urlComponents.queryItems {
                // Para URLs del tipo "https://www.youtube.com/watch?v=VIDEOID"
                return queryItems.first(where: { $0.name == "v" })?.value
            } else {
                // Para URLs del tipo "https://youtu.be/VIDEOID"
                return url.components(separatedBy: "/").last
            }
        }
    }