//
//  Movie.swift
//  movies
//
//  Created by Daniel Ferrer on 20/7/22.
//

import SwiftUI

struct Movie: Identifiable {
    var id: String
    var imdbId: String?
    var title: String
    var overView: String
    var posterPath: String?
}

let moviesTest: [Movie] = [
    Movie(id: "1", imdbId: "imdb01", title: "Regreso al Futuro", overView: "Lorem ipsum", posterPath: nil),
    Movie(id: "2", imdbId: "imdb02", title: "Regreso al Futuro II", overView: "Lorem ipsum", posterPath: nil),
    Movie(id: "3", imdbId: "imdb03", title: "Regreso al Futuro III", overView: "Lorem ipsum", posterPath: nil),
    Movie(id: "4", imdbId: "imdb04", title: "Matrix", overView: "Lorem ipsum", posterPath: nil),
    Movie(id: "5", imdbId: "imdb05", title: "Canta", overView: "Lorem ipsum", posterPath: nil),
    Movie(id: "6", imdbId: "imdb06", title: "Scream", overView: "Lorem ipsum", posterPath: nil),
    Movie(id: "7", imdbId: "imdb07", title: "Spiderman No way home", overView: "Lorem ipsum", posterPath: nil),
]
