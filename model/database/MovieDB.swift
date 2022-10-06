//
//  MovieDB.swift
//  movies
//
//  Created by Daniel Ferrer on 24/9/22.
//

import RealmSwift

class MovieDB: Object {
    
    @Persisted(primaryKey: true) var id: String
    @Persisted var imdbId: String?
    @Persisted var title: String
    @Persisted var overView: String
    @Persisted var posterPath: String?
    
    convenience init(id: String, imdbId: String?, title: String, overView: String, posterPath: String?) {
        self.init()
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
