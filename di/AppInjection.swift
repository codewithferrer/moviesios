//
//  AppInjection.swift
//  movies
//
//  Created by Daniel Ferrer on 27/8/22.
//

import Foundation
import Factory

extension Container {
    
    static let configurationService = Factory(scope: .singleton) {
        Configuration()
    }
    
    static let apiRestClientService = Factory(scope: .singleton) {
        ApiRestClient(configuration: configurationService())
    }
    
    //ViewModels
    static let homeViewModel = Factory() {
        HomeViewModel()
    }
    
    static let movieViewModel = Factory() {
        MovieViewModel()
    }
    
}
