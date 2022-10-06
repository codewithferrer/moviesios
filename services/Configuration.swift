//
//  Configuration.swift
//  movies
//
//  Created by Daniel Ferrer on 11/8/22.
//

import Foundation

class Configuration {
    
    let apiKey: String? = Bundle.main.infoDictionary?["API_KEY"] as? String
    
    let urlImages: String = "https://image.tmdb.org/t/p/original"
    
}
