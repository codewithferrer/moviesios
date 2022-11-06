//
//  MockConfiguration.swift
//  moviesTests
//
//  Created by Daniel Ferrer on 4/11/22.
//

import Foundation
@testable import movies

class MockConfiguration: ConfigurationProtocol {
    let apiKey: String? = "api_key_value"
    
    let urlImages: String = "http://mock.com/images"
}
