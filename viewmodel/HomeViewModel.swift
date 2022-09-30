//
//  HomeViewModel.swift
//  movies
//
//  Created by Daniel Ferrer on 20/7/22.
//

import SwiftUI
import Combine
import Factory
import RealmSwift

class HomeViewModel: ObservableObject {
    
    @Injected(Container.apiRestClientService) private var apiRestClient: ApiRestClient
    @Injected(Container.databaseManager) private var databaseManager: Database
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    @Published var movies: [Movie] = []
    
    init() {
        
    }
    
    func loadMovies() {
        apiRestClient.fetchPopularMovies()
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    print(dataResponse.error.debugDescription)
                } else {
                    let objects: [Object] = dataResponse.value?.results.compactMap({ apiItem in
                        MovieDB(id: String(apiItem.id),
                                imdbId: nil,
                                title: apiItem.original_title,
                                overView: apiItem.overview,
                                posterPath: apiItem.poster_path)
                    }) ?? []
                    
                    try? self.databaseManager.save(objects: objects)
                }
            }
            .store(in: &cancellableSet)
        
        
        try? databaseManager.get(type: MovieDB.self)
            .collectionPublisher
            .subscribe(on: DispatchQueue(label: "background queue"))
            .freeze()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
            },receiveValue: { results in
                self.movies = results.compactMap {
                    Movie(id: $0.id, imdbId: $0.imdbId, title: $0.title, overView: $0.overView, posterPath: $0.posterPath)
                }
            })
            .store(in: &cancellableSet)
    }
    
}


#if DEBUG
class MockHomeViewModel: HomeViewModel {
    
    override func loadMovies() {
        self.movies = moviesTest
    }

}
#endif
