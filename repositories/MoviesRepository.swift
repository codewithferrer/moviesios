//
//  MoviesRepository.swift
//  movies
//
//  Created by Daniel Ferrer on 22/10/22.
//

import Foundation
import Combine
import Alamofire
import SwiftUI

class MoviesRepository: NetworkBoundResource<[Movie], MovieDB, ApiObjectPaginator<ApiObjectMovie>> {
    
    private var apiRestClient: ApiServiceProtocol
    private var configuration: ConfigurationProtocol
    private var modelActor: MoviesModelActor
    
    init(apiRestClient: ApiServiceProtocol,
         modelActor: MoviesModelActor,
         configuration: ConfigurationProtocol) {
        self.apiRestClient = apiRestClient
        self.modelActor = modelActor
        self.configuration = configuration
    }
    
    func loadMovies() async {
        await fetch()
    }
    
    override func fetchDatabase() async throws -> AnyPublisher<[MovieDB], Never>? {
        return await modelActor.getMoviesPublisher()
    }
    
    override func convertFromDatabaseToResults(data: [MovieDB]) -> [Movie]? {
        return data.compactMap {
            Movie(id: $0.id, imdbId: $0.imdbId, title: $0.title, overView: $0.overView, posterPath: $0.posterPath)
        }
    }
    
    override func fetchWS(page: Int) async -> ApiObjectPaginator<ApiObjectMovie>? {
        return await apiRestClient.popularMovies(page: page)
    }
    
    override func saveFromAPIToDatabase(response: ApiObjectPaginator<ApiObjectMovie>) async {
        let objects: [MovieDB] = response.results.compactMap({ apiItem in
            MovieDB.build(apiItem: apiItem, urlImages: self.configuration.urlImages)
        })
        
        if numPage == 1 {
            await self.modelActor.deleteMovies()
        }
        
        await self.modelActor.saveObjects(objects: objects)
    }
    
    override func hasMorePages(response: ApiObjectPaginator<ApiObjectMovie>) async -> Bool {
        return response.results.count > 0
    }
    
}
