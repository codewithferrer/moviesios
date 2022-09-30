//
//  DatabaseConfiguration.swift
//  movies
//
//  Created by Daniel Ferrer on 24/9/22.
//

import Foundation
import RealmSwift

open class DatabaseConfiguration {
    
    private let _databaseName: String
    let writeType: DatabaseWriteType
    let debug: DatabaseDebugVerbosity
    let schemaVersion: UInt64
    let objectTypes: [ObjectBase.Type]?
    
    var databaseName: String {
        get {
            return "\(_databaseName).realm"
        }
    }
    
    public init (databaseName: String = "database",
                 type: DatabaseWriteType = .disk,
                 debug : DatabaseDebugVerbosity = .none,
                 schemaVersion: UInt64 = 1,
                 objectTypes: [ObjectBase.Type]? = nil) {
        
        self._databaseName = databaseName
        self.writeType = type
        self.debug = debug
        self.schemaVersion = schemaVersion
        self.objectTypes = objectTypes
    }
    
}
