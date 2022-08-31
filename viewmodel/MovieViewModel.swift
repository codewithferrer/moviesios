//
//  MovieViewModel.swift
//  movies
//
//  Created by Daniel Ferrer on 21/8/22.
//

import SwiftUI
import Combine
import Factory

class MovieViewModel: ObservableObject {
    
    @Injected(Container.apiRestClientService) private var apiRestClient: ApiRestClient
    
    @Published var movie: Movie? = nil
    
    private var cancellableSet: Set<AnyCancellable> = []
        
    init() {
        
    }
    
    func loadMovie(movieId: String) {
        apiRestClient
            .fetchMovie(movieId: movieId)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    print(dataResponse.error.debugDescription)
                } else {
                    if let apiItem = dataResponse.value {
                        self.movie =
                            Movie(id: String(apiItem.id),
                                  imdbId: nil,
                                  title: apiItem.original_title,
                                  overView: apiItem.overview,
                                  posterPath: apiItem.poster_path)
                        
                    } else {
                        self.movie = nil
                    }
                }
            }
            .store(in: &cancellableSet)
    }
    
}


#if DEBUG
class MockMovieViewModel: MovieViewModel {
    
    override func loadMovie(movieId: String) {
        self.movie = moviesTest[0]
    }

}
#endif
