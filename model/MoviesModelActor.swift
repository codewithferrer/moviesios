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
    
    func deleteMovies() {
        try? context.delete(model: MovieDB.self)
    }
    
    func getMoviesPublisher() -> AnyPublisher<[MovieDB], Never>? {
        
        let fetchDescriptor: FetchDescriptor<MovieDB> = FetchDescriptor()
        return try? context.fetch(fetchDescriptor).publisher.collect().eraseToAnyPublisher()
    }
    
    func getMoviePublisher(movieId: String) -> AnyPublisher<[MovieDB], Never>? {
        let fetchDescriptor: FetchDescriptor<MovieDB> = FetchDescriptor(predicate: #Predicate<MovieDB> {
            $0.id == movieId
        })
        return try? context.fetch(fetchDescriptor).publisher.collect()
            .eraseToAnyPublisher()
    }
    
    func saveObjects(objects: [any PersistentModel]) {
        objects.forEach { object in
            context.insert(object)
        }
        try? context.save()
    }
    
}
