//
//  HomeViewModel.swift
//  movies
//
//  Created by Daniel Ferrer on 20/7/22.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var movies: [Movie] = []
    
    func loadMovies() {
        self.movies = moviesTest
    }
    
}
