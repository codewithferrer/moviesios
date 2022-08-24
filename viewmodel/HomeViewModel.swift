//
//  HomeViewModel.swift
//  movies
//
//  Created by Daniel Ferrer on 20/7/22.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    
    private let apiRestClient: ApiRestClient
    private let configuration: Configuration
    private var cancellableSet: Set<AnyCancellable> = []
    
    @Published var movies: [Movie] = []
    
    init() {
        self.configuration = Configuration()
        self.apiRestClient = ApiRestClient(configuration: configuration)
    }
    
    func loadMovies() {
        apiRestClient.fetchPopularMovies()
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    print(dataResponse.error.debugDescription)
                } else {
                    self.movies = dataResponse.value?.results.compactMap({ apiItem in
                        Movie(id: String(apiItem.id),
                              imdbId: nil,
                              title: apiItem.original_title,
                              overView: apiItem.overview,
                              posterPath: apiItem.poster_path)
                    }) ?? []
                }
            }
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
