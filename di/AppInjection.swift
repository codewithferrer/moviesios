//
//  AppInjection.swift
//  movies
//
//  Created by Daniel Ferrer on 27/8/22.
//

import Foundation
import Factory
import SwiftData

extension Container {
    
    var configurationService: Factory<Configuration> {
        self { Configuration() }.singleton
    }
    
    var apiRestClientService: Factory<ApiRestClient> {
        self { ApiRestClient(configuration: self.configurationService()) }.singleton
    }
    
    var modelContainerService: Factory<ModelContainer> {
        self {
            
            let sharedModelContainer: ModelContainer = {
                let schema = Schema([
                    MovieDB.self,
                ])
                let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

                do {
                    return try ModelContainer(for: schema, configurations: [modelConfiguration])
                } catch {
                    fatalError("Could not create ModelContainer: \(error)")
                }
            }()
            
            return sharedModelContainer
            
        }.singleton
    }
    
    var moviesModelActor: Factory<MoviesModelActor> {
        self {
            MoviesModelActor(modelContainer: self.modelContainerService())
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
                             modelActor: self.moviesModelActor(),
                             configuration: self.configurationService()
            )
        }
    }
    
    var movieRepository: Factory<MovieRepository> {
        self {
            MovieRepository(apiRestClient: self.apiRestClientService(),
                            modelActor: self.moviesModelActor(),
                            configuration: self.configurationService()
            )
        }
    }
    
}
