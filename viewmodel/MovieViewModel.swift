//
//  MovieViewModel.swift
//  movies
//
//  Created by Daniel Ferrer on 21/8/22.
//

import SwiftUI
import Combine
import Factory
import RealmSwift

class MovieViewModel: ObservableObject {
    
    @Injected(Container.movieRepository) private var repository: MovieRepository
    
    @Published var movie: Movie? = nil
    
    private var cancellableSet: Set<AnyCancellable> = []
        
    init() {
        repository.$result.compactMap { $0 }
            .assign(to: \.movie, on: self)
            .store(in: &cancellableSet)
    }
    
    func loadMovie(movieId: String) {
        repository.loadMovie(movieId: movieId)
    }
    
}


#if DEBUG
class MockMovieViewModel: MovieViewModel {
    
    override func loadMovie(movieId: String) {
        self.movie = moviesTest[0]
    }

}
#endif
