//
//  MovieRepository.swift
//  movies
//
//  Created by Daniel Ferrer on 22/10/22.
//

import Foundation
import Combine
import Alamofire
import SwiftUI
import RealmSwift
import RealmDataManager

class MovieRepository: NetworkBoundResource<Movie, MovieDB, ApiObjectMovie> {
    
    private var apiRestClient: ApiServiceProtocol
    private var databaseManager: Database
    private var configuration: ConfigurationProtocol
    
    private var movieId: String? = nil
    
    init(apiRestClient: ApiServiceProtocol, databaseManager: Database, configuration: ConfigurationProtocol) {
        self.apiRestClient = apiRestClient
        self.databaseManager = databaseManager
        self.configuration = configuration
    }
    
    func loadMovie(movieId: String) {
        self.movieId = movieId
        fetch()
    }
    
    override func fetchDatabase() throws -> Results<MovieDB>? {
        guard let movieId = movieId else { return nil }
        return try databaseManager.get(type: MovieDB.self) { $0.id == movieId }
    }
    
    override func convertFromDatabaseToResults(data: Results<MovieDB>) -> Movie? {
        if let _movie = data.last {
            return Movie(id: _movie.id, imdbId: _movie.imdbId, title: _movie.title, overView: _movie.overView, posterPath: _movie.posterPath)
        } else {
            return nil
        }
    }
    
    override func fetchWS(page: Int) -> AnyPublisher<DataResponse<ApiObjectMovie, ApiRestError>, Never>? {
        guard let movieId = movieId else { return nil }
        return apiRestClient.fetchMovie(movieId: movieId)
    }
    
    override func saveFromAPIToDatabase(response: DataResponse<ApiObjectMovie, ApiRestError>) {
        if let apiItem = response.value {
            
            var objects: [Object] = []
            let movie = MovieDB.build(apiItem: apiItem, urlImages: self.configuration.urlImages)
            
            objects.append(movie)
            
            try? self.databaseManager.save(objects: objects)
            
        }
    }
    
}
