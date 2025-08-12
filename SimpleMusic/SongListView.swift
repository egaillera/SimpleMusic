
//
//  SongListView.swift
//  SimpleMusic
//
//  Created by Enrique Garcia Illera on 12/8/25.
//

import SwiftUI
import MediaPlayer

struct Song: Identifiable {
    let id: MPMediaEntityPersistentID
    let title: String
    let duration: TimeInterval
}

struct SongListView: View {
    let album: Album
    @State private var songs: [Song] = []

    var body: some View {
        VStack {
            Text(String(format: NSLocalizedString("Songs in %@", comment: ""), album.title))
                .font(.largeTitle)
                .padding()
            List(songs) { song in
                HStack {
                    Button(action: {
                        // Play song action to be implemented
                    }) {
                        Image(systemName: "play.fill")
                    }
                    Text(song.title)
                    Spacer()
                    Text(formatDuration(song.duration))
                }
            }
        }
        .onAppear(perform: loadSongs)
        .navigationTitle(album.title)
    }

    private func loadSongs() {
        let songsQuery = MPMediaQuery.songs()
        songsQuery.addFilterPredicate(MPMediaPropertyPredicate(value: album.title, forProperty: MPMediaItemPropertyAlbumTitle))

        if let mediaSongs = songsQuery.items {
            self.songs = mediaSongs.compactMap { mediaItem in
                if let songTitle = mediaItem.title {
                    return Song(id: mediaItem.persistentID, title: songTitle, duration: mediaItem.playbackDuration)
                }
                return nil
            }
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct SongListView_Previews: PreviewProvider {
    static var previews: some View {
        SongListView(album: Album(title: "Preview Album", artwork: nil))
    }
}
