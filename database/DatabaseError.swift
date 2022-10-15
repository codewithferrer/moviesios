//
//  DatabaseError.swift
//  movies
//
//  Created by Daniel Ferrer on 24/9/22.
//

import Foundation

enum DatabaseError: Error {
    case databaseNameError, configurationError, instanceNotAvailable, cannotSaveError, cannotDeleteError
}
