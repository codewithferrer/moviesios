//
//  Configuration.swift
//  movies
//
//  Created by Daniel Ferrer on 11/8/22.
//

import Foundation

protocol ConfigurationProtocol {
    var apiKey: String? { get }
    var urlImages: String { get }
    var urlBase: String { get }
    var APIKEY_NAME: String { get }
    var protocolClasses: [AnyClass] { get }
    var logLevel: AlamofireLogger.LogLevel { get }
}

class Configuration: ConfigurationProtocol {
    
    let apiKey: String? = Bundle.main.infoDictionary?["API_KEY"] as? String
    
    let urlImages: String = "https://image.tmdb.org/t/p/original"
    
    let urlBase: String = "https://api.themoviedb.org/3/movie/"
    let APIKEY_NAME: String = "api_key"
    
    let protocolClasses: [AnyClass] = []
    
    let logLevel: AlamofireLogger.LogLevel = .Headers
    
}
