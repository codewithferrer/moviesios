//
//  ApiObjectPaginator.swift
//  movies
//
//  Created by Daniel Ferrer on 20/8/22.
//

import Foundation

struct ApiObjectPaginator<T: Codable>: Codable {
    
    var page: Int
    var total_pages: Int
    var total_results: Int64
    
    var results: [T]
    
}
