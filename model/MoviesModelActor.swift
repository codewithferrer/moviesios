//
//  MoviesModelActor.swift
//  movies
//
//  Created by Daniel Ferrer on 29/12/23.
//

import Foundation
import SwiftData
import Combine

actor MoviesModelActor: ModelActor {
    
    let modelContainer: ModelContainer
    let modelExecutor: any ModelExecutor
    let context: ModelContext

    init(modelContainer: ModelContainer) {
      self.modelContainer = modelContainer
      context = ModelContext(modelContainer)
      modelExecutor = DefaultSerialModelExecutor(modelContext: context)
    }
    
    func saveMovies(movies: [Movie]) {
        movies.forEach { movie in
            context.insert(movie)
        }
        try? context.save()
    }
    
    func deleteMovies() {
        try? context.delete(model: Movie.self)
    }
    
    func getMovies() -> [Movie] {
        let fetchDescriptor: FetchDescriptor<Movie> = FetchDescriptor()
        
        return (try? context.fetch(fetchDescriptor)) ?? []
    }
    
    func getMoviesPublisher() -> AnyPublisher<[Movie], Never>? {
        
        let fetchDescriptor: FetchDescriptor<Movie> = FetchDescriptor()
        return try? (context.fetch(fetchDescriptor).publisher.collect().eraseToAnyPublisher())
    }
    
    func getMoviePublisher(movieId: String) -> AnyPublisher<[Movie], Never>? {
        let fetchDescriptor: FetchDescriptor<Movie> = FetchDescriptor(predicate: #Predicate<Movie> {
            $0.id == movieId
        })
        return try? context.fetch(fetchDescriptor).publisher.collect()
            /*.map({
                $0.first
            })*/
            .eraseToAnyPublisher()
    }
    
    func saveObjects(objects: [any PersistentModel]) {
        objects.forEach { object in
            context.insert(object)
        }
        try? context.save()
    }
    
}
