//
//  SimpleMusicApp.swift
//  SimpleMusic
//
//  Created by Enrique Garcia Illera on 12/8/25.
//

import SwiftUI

@main
struct SimpleMusicApp: App {
    @StateObject private var musicPlayerManager = MusicPlayerManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(musicPlayerManager)
        }
    }
}
