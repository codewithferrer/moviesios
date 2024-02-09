//
//  moviesApp.swift
//  movies
//
//  Created by Daniel Ferrer on 4/7/22.
//

import SwiftUI
import SwiftData
import Factory

@main
struct moviesApp: App {
    
    @Injected(\.modelContainerService)
    private var sharedModelContainer
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(sharedModelContainer)
    }
}
