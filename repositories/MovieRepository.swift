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

class MovieRepository: NetworkBoundResource<Movie, MovieDB, ApiObjectMovie> {
    
    private var apiRestClient: ApiServiceProtocol
    private var configuration: ConfigurationProtocol
    private var modelActor: MoviesModelActor
    
    private var movieId: String? = nil
    
    init(apiRestClient: ApiServiceProtocol, modelActor: MoviesModelActor, configuration: ConfigurationProtocol) {
        self.apiRestClient = apiRestClient
        self.modelActor = modelActor
        self.configuration = configuration
    }
    
    func loadMovie(movieId: String) async {
        self.movieId = movieId
        await fetch()
    }
    
    override func fetchDatabase() async throws -> AnyPublisher<[MovieDB], Never>? {
        guard let movieId = movieId else { return nil }
        return await modelActor.getMoviePublisher(movieId: movieId)
    }
    
    override func convertFromDatabaseToResults(data: [MovieDB]) -> Movie? {
        if let _movie = data.last {
            return Movie(id: _movie.id, imdbId: _movie.imdbId, title: _movie.title, overView: _movie.overView, posterPath: _movie.posterPath)
        } else {
            return nil
        }
    }
    
    override func fetchWS(page: Int) async -> ApiObjectMovie? {
        guard let movieId = movieId else { return nil }
        return await apiRestClient.movie(movieId: movieId)
    }
    
    override func saveFromAPIToDatabase(response: ApiObjectMovie) async {
        let movies:[MovieDB] = [
            MovieDB.build(apiItem: response, urlImages: self.configuration.urlImages)
        ]
        await modelActor.saveObjects(objects: movies)
    }
    
}
