//
//  MockedData.swift
//  movies
//
//  Created by Daniel Ferrer on 7/2/23.
//

import Foundation

public final class MockedData {
    
    public static func moviesListJSON() -> Data {
        return readDataFromFile(fileName: "movies_list")!
    }
    
    public static func movieDetailJSON() -> Data {
        return readDataFromFile(fileName: "movie_detail")!
    }
    
    private static func readDataFromFile(fileName: String) -> Data? {
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                return data
            } catch {
                
            }
        }
        return nil
    }
    
}
