
//
//  AlbumView.swift
//  SimpleMusic
//
//  Created by Enrique Garcia Illera on 12/8/25.
//

import SwiftUI
import MediaPlayer



struct AlbumView: View {
    let artist: Artist
    @State private var albums: [Album] = []

    var body: some View {
        VStack {
            Text(String(format: NSLocalizedString("Albums for %@", comment: ""), artist.name))
                .font(.largeTitle)
                .padding()
            List(albums) { album in
                NavigationLink(destination: SongListView(album: album)) {
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
        let fakeAlbums = [
            Album(title: "Album 1", artwork: nil),
            Album(title: "Album 2", artwork: nil),
            Album(title: "Album 3", artwork: nil)
        ]
        AlbumView(artist: Artist(name: "Preview Artist", imageName: "person.fill"), albums: fakeAlbums)
    }
}

extension AlbumView {
    init(artist: Artist, albums: [Album]) {
        self.artist = artist
        self._albums = State(initialValue: albums)
    }
}
