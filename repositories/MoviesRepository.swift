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
import RealmSwift
import RealmDataManager

class MoviesRepository: NetworkBoundResource<[Movie], MovieDB, ApiObjectPaginator<ApiObjectMovie>> {
    
    private var apiRestClient: ApiServiceProtocol
    private var databaseManager: Database
    private var configuration: ConfigurationProtocol
    
    
    
    init(apiRestClient: ApiServiceProtocol, databaseManager: Database, configuration: ConfigurationProtocol) {
        self.apiRestClient = apiRestClient
        self.databaseManager = databaseManager
        self.configuration = configuration
    }
    
    func loadMovies() {
        fetch()
    }
    
    override func fetchDatabase() throws -> Results<MovieDB>? {
        return try databaseManager.get(type: MovieDB.self)
    }
    
    override func convertFromDatabaseToResults(data: Results<MovieDB>) -> [Movie]? {
        return data.compactMap {
            Movie(id: $0.id, imdbId: $0.imdbId, title: $0.title, overView: $0.overView, posterPath: $0.posterPath)
        }
    }
    
    override func fetchWS(page: Int) -> AnyPublisher<DataResponse<ApiObjectPaginator<ApiObjectMovie>, ApiRestError>, Never>? {
        return apiRestClient.fetchPopularMovies(page: page)
    }
    
    override func saveFromAPIToDatabase(response: DataResponse<ApiObjectPaginator<ApiObjectMovie>, ApiRestError>) {
        let objects: [Object] = response.value?.results.compactMap({ apiItem in
            MovieDB.build(apiItem: apiItem, urlImages: self.configuration.urlImages)
        }) ?? []
        
        if numPage == 1 {
            try? self.databaseManager.delete(type: MovieDB.self)
        }
        
        try? self.databaseManager.save(objects: objects)
    }
    
    override func hasMorePages(response: DataResponse<ApiObjectPaginator<ApiObjectMovie>, ApiRestError>) -> Bool {
        return response.value?.results.count ?? 0 > 0
    }
    
}
