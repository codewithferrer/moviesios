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
    
    @Injected(\.moviesRepository) private var repository: MoviesRepository
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    @Published var movies: [Movie] = []
    @Published var loadMoreState: LoadMoreState = LoadMoreState(isRunning: false, hasMorePages: true)
    
    init() {
        repository.$result.compactMap { $0 }
            .assign(to: \.movies, on: self)
            .store(in: &cancellableSet)
        
        repository.$loadMoreState.compactMap { $0 }
            .assign(to: \.loadMoreState, on: self)
            .store(in: &cancellableSet)
    }
    
    func loadMovies() {
        repository.loadMovies()
    }
    
    func loadNextPage() {
        repository.fetchNextPage()
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
