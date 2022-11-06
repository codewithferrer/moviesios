//
//  MockDatabaseBuilder.swift
//  moviesTests
//
//  Created by Daniel Ferrer on 4/11/22.
//

import Foundation
import RealmDataManager

@testable import movies

class MockDatabaseBuilder {
    
    public static func build() -> Database {
            
        let time = Date().timeIntervalSince1970 * 1000
        let rnd = Double.random(in: 0.0...100.0)
        
        let configuration = DatabaseConfiguration(
            databaseName: "movies_\(time)_\(rnd)",
            type: .memory,
            debug: .all,
            schemaVersion: 1,
            objectTypes: [MovieDB.self]
        )
        
        return LocalDatabaseManager(configuration: configuration) as Database
    }
    
}
