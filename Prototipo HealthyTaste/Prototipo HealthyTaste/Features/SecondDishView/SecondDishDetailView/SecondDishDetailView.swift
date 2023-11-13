

import SwiftUI

struct SecondDishDetailView: View {
    let second: Second
    
    
    var body: some View {
        VStack {
            ScrollView{
                Text(second.name)
                    .font(.title)
                AsyncImage(url: URL(string: second.image)) { state in
                    switch state {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                    case .failure:
                        Text("Error al cargar la imagen")
                    @unknown default:
                        EmptyView()
                    }
                }
                Text("Ingredientes:")
                    .font(.title)
                Text(second.details.ingredients.description)
                Text("Elaboración:")
                    .font(.title)
                Text(second.details.elaboration)
                if let videoID = extractYouTubeID(from: second.details.urlVideo) {
                    VideoPlayer(ID: videoID)
                } else {
                    Text("Video no disponible")
                }
            }
        }
        .navigationBarTitle("Recipe Detail", displayMode: .inline)
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
