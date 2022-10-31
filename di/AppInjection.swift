//
//  AppInjection.swift
//  movies
//
//  Created by Daniel Ferrer on 27/8/22.
//

import Foundation
import Factory
import RealmDataManager

extension Container {
    
    static let configurationService = Factory(scope: .singleton) {
        Configuration()
    }
    
    static let apiRestClientService = Factory(scope: .singleton) {
        ApiRestClient(configuration: configurationService())
    }
    
    static let databaseManager = Factory(scope: .singleton) {
        let configuration = DatabaseConfiguration(
            databaseName: "movies",
            type: .disk,
            debug: .all,
            schemaVersion: 1,
            objectTypes: [MovieDB.self]
        )
        
        return LocalDatabaseManager(configuration: configuration) as Database
    }
    
    //ViewModels
    static let homeViewModel = Factory() {
        HomeViewModel()
    }
    
    static let movieViewModel = Factory() {
        MovieViewModel()
    }
    
    //Repositories
    static let moviesRepository = Factory() {
        MoviesRepository(apiRestClient: apiRestClientService(), databaseManager: databaseManager(), configuration: configurationService())
    }
    
    static let movieRepository = Factory() {
        MovieRepository(apiRestClient: apiRestClientService(), databaseManager: databaseManager(), configuration: configurationService())
    }
    
}
