//
//  MovieDB.swift
//  movies
//
//  Created by Daniel Ferrer on 24/9/22.
//

import SwiftData

@Model
final class MovieDB: Identifiable {
    
    @Attribute(.unique) var id: String
    var imdbId: String?
    var title: String
    var overView: String
    var posterPath: String?
    
    init(id: String, imdbId: String?, title: String, overView: String, posterPath: String?) {
        self.id = id
        self.imdbId = imdbId
        self.title = title
        self.overView = overView
        self.posterPath = posterPath
    }
}

extension MovieDB {
    
    static func build(apiItem: ApiObjectMovie, urlImages: String) -> MovieDB {
        
        let absoluteUrl: String = "\(urlImages)\(apiItem.poster_path)"
        
        return MovieDB(id: String(apiItem.id),
                       imdbId: nil,
                       title: apiItem.original_title,
                       overView: apiItem.overview,
                       posterPath: absoluteUrl)
    }
    
}
