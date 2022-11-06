//
//  MockApiRestClient.swift
//  moviesTests
//
//  Created by Daniel Ferrer on 4/11/22.
//

import Foundation
import Alamofire
import Combine

@testable import movies

class MockApiRestClient: ApiServiceProtocol {
    var fetchPopularMovies: AnyPublisher<DataResponse<ApiObjectPaginator<ApiObjectMovie>, ApiRestError>, Never>!
    var fetchMovie: AnyPublisher<DataResponse<ApiObjectMovie, ApiRestError>, Never>!
        
        
    func fetchPopularMovies(page: Int) -> AnyPublisher<DataResponse<ApiObjectPaginator<ApiObjectMovie>,ApiRestError>, Never> {
        return fetchPopularMovies
    }
    
    func fetchMovie(movieId: String) -> AnyPublisher<DataResponse<ApiObjectMovie, ApiRestError>, Never> {
        return fetchMovie
    }
}
