
//
//  AlbumView.swift
//  SimpleMusic
//
//  Created by Enrique Garcia Illera on 12/8/25.
//

import SwiftUI
import MediaPlayer

struct Album: Identifiable {
    let id = UUID()
    let title: String
    let artwork: MPMediaItemArtwork?
}

struct AlbumView: View {
    let artist: Artist
    @State private var albums: [Album] = []

    var body: some View {
        VStack {
            Text("Albums for \(artist.name)")
                .font(.largeTitle)
                .padding()
            List(albums) { album in
                HStack {
                    if let image = album.artwork?.image(at: CGSize(width: 50, height: 50)) {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                    } else {
                        Image(systemName: "music.note")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                    }
                    Text(album.title)
                }
            }
        }
        .onAppear(perform: loadAlbums)
        .navigationTitle(artist.name)
    }

    private func loadAlbums() {
        let albumsQuery = MPMediaQuery.albums()
        albumsQuery.addFilterPredicate(MPMediaPropertyPredicate(value: artist.name, forProperty: MPMediaItemPropertyArtist))

        if let mediaAlbums = albumsQuery.collections {
            self.albums = mediaAlbums.compactMap { collection in
                if let albumTitle = collection.representativeItem?.albumTitle {
                    return Album(title: albumTitle, artwork: collection.representativeItem?.artwork)
                }
                return nil
            }.sorted { $0.title < $1.title }
        }
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumView(artist: Artist(name: "Preview Artist", imageName: "person.fill"))
    }
}
