//
//  ContentView.swift
//  SimpleMusic
//
//  Created by Enrique Garcia Illera on 12/8/25.
//

import SwiftUI
import MediaPlayer

struct Artist: Identifiable {
    let id = UUID()
    let name: String
    // In a real app, this would likely be an image or a path to an image
    let imageName: String // Placeholder for now, as MPMediaItem doesn't directly provide artist images
}

struct ContentView: View {
    @State private var artists: [Artist]
    @State private var authorizationStatus: MPMediaLibraryAuthorizationStatus = .notDetermined

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    init(artists: [Artist]? = nil) {
        if let artists = artists {
            _artists = State(initialValue: artists)
            _authorizationStatus = State(initialValue: .authorized)
        } else {
            _artists = State(initialValue: [])
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                if authorizationStatus == .authorized {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(artists) { artist in
                                NavigationLink(destination: AlbumView(artist: artist)) {
                                    ArtistGridItem(artist: artist)
                                }
                            }
                        }
                        .padding()
                    }
                    .navigationTitle(LocalizedStringKey("Artists"))
                } else {
                    Text(LocalizedStringKey("Please grant access to your media library in Settings to view artists."))
                        .multilineTextAlignment(.center)
                        .padding()
                    Button(LocalizedStringKey("Request Access")) {
                        requestMediaLibraryAuthorization()
                    }
                }
            }
            .onAppear(perform: checkMediaLibraryAuthorization)
        }
    }

    private func checkMediaLibraryAuthorization() {
        // Only attempt to load artists if they weren't provided for preview
        if artists.isEmpty && authorizationStatus == .notDetermined {
            authorizationStatus = MPMediaLibrary.authorizationStatus()
            if authorizationStatus == .notDetermined {
                requestMediaLibraryAuthorization()
            } else if authorizationStatus == .authorized {
                loadArtists()
            }
        }
    }

    private func requestMediaLibraryAuthorization() {
        MPMediaLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                self.authorizationStatus = status
                if status == .authorized {
                    self.loadArtists()
                }
            }
        }
    }

    private func loadArtists() {
        let artistQuery = MPMediaQuery.artists()
        if let mediaArtists = artistQuery.collections {
            self.artists = mediaArtists.compactMap { collection in
                if let artistName = collection.representativeItem?.artist {
                    return Artist(name: artistName, imageName: "person.fill") // Using person.fill as a placeholder
                }
                return nil
            }.sorted { $0.name < $1.name } // Sort artists alphabetically
        }
    }
}

struct ArtistGridItem: View {
    let artist: Artist

    var body: some View {
        VStack {
            Image(systemName: artist.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                .shadow(radius: 5)

            Text(artist.name)
                .font(.headline)
                .padding(.top, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(artists: [
            Artist(name: "Preview Artist 1", imageName: "person.fill"),
            Artist(name: "Preview Artist 2", imageName: "person.fill"),
            Artist(name: "Preview Artist 3", imageName: "person.fill"),
            Artist(name: "Preview Artist 4", imageName: "person.fill")
        ])
    }
}
