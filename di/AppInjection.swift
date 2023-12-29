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
    
    var configurationService: Factory<Configuration> {
        self { Configuration() }.singleton
    }
    
    var apiRestClientService: Factory<ApiRestClient> {
        self { ApiRestClient(configuration: self.configurationService()) }.singleton
    }
    
    var databaseManager: Factory<Database> {
        self {
            let configuration = DatabaseConfiguration(
                databaseName: "movies",
                type: .disk,
                debug: .all,
                schemaVersion: 1,
                objectTypes: [MovieDB.self]
            )
            
            return LocalDatabaseManager(configuration: configuration) as Database
        }.singleton
    }
    
    //ViewModels
    var homeViewModel: Factory<HomeViewModel> {
        self { HomeViewModel() }
    }
    
    var movieViewModel: Factory<MovieViewModel> {
        self { MovieViewModel() }
    }
    
    //Repositories
    var moviesRepository: Factory<MoviesRepository> {
        self {
            MoviesRepository(apiRestClient: self.apiRestClientService(),
                             databaseManager: self.databaseManager(),
                             configuration: self.configurationService()
            )
        }
    }
    
    var movieRepository: Factory<MovieRepository> {
        self {
            MovieRepository(apiRestClient: self.apiRestClientService(),
                            databaseManager: self.databaseManager(),
                            configuration: self.configurationService()
            )
        }
    }
    
}
