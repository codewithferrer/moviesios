//
//  ApiObjectMovie.swift
//  movies
//
//  Created by Daniel Ferrer on 20/8/22.
//

import Foundation

struct ApiObjectMovie: Codable {
    var id: Int64
    var original_title: String
    var overview: String
    var poster_path: String
}
