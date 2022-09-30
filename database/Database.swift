//
//  Database.swift
//  movies
//
//  Created by Daniel Ferrer on 24/9/22.
//

import RealmSwift
import struct RealmSwift.SortDescriptor


protocol Database: AnyObject {
    
    var database: Realm? { get }
    var configuration: DatabaseConfiguration { get }
    
    func get<T: Object>(type: T.Type) throws -> Results<T>
    func get<T: Object>(type: T.Type, query: ((Query<T>) -> Query<Bool>)) throws -> Results<T>
    
    func save<S: Sequence>(objects: S) throws where S.Iterator.Element: Object
    
    func debug(error: String)
    func debug(data: String)
    
    func reset()
    
}

//GET
extension Database {
    
    func get<T: Object>(type: T.Type) throws -> Results<T> {
        guard let database = database else {
            debug(error: DatabaseError.instanceNotAvailable.localizedDescription)
            throw DatabaseError.instanceNotAvailable
        }
        
        return database.objects(type)
    }
    
    func get<T: Object>(type: T.Type, query: ((Query<T>) -> Query<Bool>)) throws -> Results<T> {
        guard let database = database else {
            debug(error: DatabaseError.instanceNotAvailable.localizedDescription)
            throw DatabaseError.instanceNotAvailable
        }
        
        return database.objects(type).where(query)
    }
    
}

//SAVE
extension Database {
    
    func save<S: Sequence>(objects: S) throws where S.Iterator.Element: Object {
        guard let database = database else {
            debug(error: DatabaseError.instanceNotAvailable.localizedDescription)
            throw DatabaseError.instanceNotAvailable
        }
        
        do {
            try database.write {
                database.add(objects, update: .modified)
            }
        } catch(let e) {
            debug(error: e.localizedDescription)
            throw DatabaseError.cannotSaveError
        }
    }
}

//DEBUG
extension Database {
    
    /// Error debug log wrapper for db
    ///
    /// - Parameter error: string error
    public func debug(error: String) {
        if configuration.debug == .all || configuration.debug == .error {
            print("🗄❌ Database Error ❌ > " + error)
        }
    }
    
    /// Action debug log wrapper for db
    ///
    /// - Parameter data: string
    public func debug(data: String) {
        if configuration.debug == .all || configuration.debug == .message {
            print("🗄👉 Database > " + data)
        }
    }
    
}
