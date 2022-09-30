//
//  LocalDatabaseManager.swift
//  movies
//
//  Created by Daniel Ferrer on 24/9/22.
//

import RealmSwift

class LocalDatabaseManager: Database {
    
    internal var configuration: DatabaseConfiguration
    private var _database: Realm?
    
    init(configuration: DatabaseConfiguration) {
        self.configuration = configuration
    }
    
    internal var database: Realm? {
        get {
            if _database == nil {
                do {
                    try self.configure()
                } catch(let e) {
                    debug(error: e.localizedDescription)
                }
                
            }
            
            return _database
        }
    }
    
    func reset() {
        _database = nil
    }
    
    private func configure() throws {
        var dbConf = Realm.Configuration()
        
        switch configuration.writeType {
        case .disk:
            guard let fileUrl = dbConf.fileURL?.deletingLastPathComponent().appendingPathComponent(configuration.databaseName) else {
                throw DatabaseError.databaseNameError
            }
            
            dbConf.fileURL = fileUrl
        case .memory:
            dbConf.fileURL = nil
            dbConf.inMemoryIdentifier = configuration.databaseName
        }
        
        dbConf.objectTypes = configuration.objectTypes
        dbConf.readOnly = false
        dbConf.schemaVersion = configuration.schemaVersion
        
        do {
            _database = try Realm(configuration: dbConf)
        } catch (let e) {
            debug(error: e.localizedDescription)
        }
    }
    
}
