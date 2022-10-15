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
    @Injected(Container.configurationService) private var configuration: Configuration
    
    private var cancellableSet: Set<AnyCancellable> = []
    private var numPage: Int = 0
    
    @Published var movies: [Movie] = []
    @Published var loadMoreState: LoadMoreState = LoadMoreState(isRunning: false, hasMorePages: true)
    
    init() {
        
    }
    
    func loadMovies() {
        
        loadNextPage()
        
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
    
    private func loadFromAPI(page: Int) {
        apiRestClient.fetchPopularMovies(page: page)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    print(dataResponse.error.debugDescription)
                    self.loadMoreState = LoadMoreState(isRunning: false, hasMorePages: false)
                } else {
                    let objects: [Object] = dataResponse.value?.results.compactMap({ apiItem in
                        MovieDB.build(apiItem: apiItem, urlImages: self.configuration.urlImages)
                    }) ?? []
                    
                    if page == 1 {
                        try? self.databaseManager.delete(type: MovieDB.self)
                    }
                    
                    try? self.databaseManager.save(objects: objects)
                    
                    self.loadMoreState = LoadMoreState(isRunning: false, hasMorePages: !objects.isEmpty)
                }
            }
            .store(in: &cancellableSet)
    }
    
    func loadNextPage() {
        if self.loadMoreState.isRunning || !self.loadMoreState.hasMorePages {
            return
        }
        
        self.loadMoreState = LoadMoreState(isRunning: true, hasMorePages: true)
        
        numPage += 1
        loadFromAPI(page: numPage)
    }
    
}

struct LoadMoreState {
    let isRunning: Bool
    let hasMorePages: Bool
}


#if DEBUG
class MockHomeViewModel: HomeViewModel {
    
    override func loadMovies() {
        self.movies = moviesTest
    }

}
#endif
