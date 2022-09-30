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
    
    @Injected(Container.apiRestClientService) private var apiRestClient: ApiRestClient
    @Injected(Container.databaseManager) private var databaseManager: Database
    
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
                        
                        var objects: [Object] = []
                        let movie = MovieDB(id: String(apiItem.id),
                                imdbId: nil,
                                title: apiItem.original_title,
                                overView: apiItem.overview,
                                posterPath: apiItem.poster_path)
                        
                        objects.append(movie)
                        
                        try? self.databaseManager.save(objects: objects)
                        
                    }
                }
            }
            .store(in: &cancellableSet)
        
        
        try? databaseManager.get(type: MovieDB.self) { $0.id == movieId }
            .collectionPublisher
            .subscribe(on: DispatchQueue(label: "background queue"))
            .freeze()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
            },receiveValue: { results in
                if let _movie = results.last {
                    self.movie = Movie(id: _movie.id, imdbId: _movie.imdbId, title: _movie.title, overView: _movie.overView, posterPath: _movie.posterPath)
                } else {
                    self.movie = nil
                }
                
                
            })
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
