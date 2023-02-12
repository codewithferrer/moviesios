//
//  MockConfiguration.swift
//  moviesTests
//
//  Created by Daniel Ferrer on 4/11/22.
//

import Foundation
import Mocker

@testable import movies

class MockConfiguration: ConfigurationProtocol {
    
    let urlBase: String = "https://api.mock/movie/"
    
    let APIKEY_NAME: String = "api_key"
    
    let protocolClasses: [AnyClass] = [MockingURLProtocol.self]
    
    let apiKey: String? = "api_key_value"
    
    let urlImages: String = "http://mock.com/images"
}
