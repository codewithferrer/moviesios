//
//  MovieRepositoryTest.swift
//  moviesTests
//
//  Created by Daniel Ferrer on 4/11/22.
//

import Foundation
import Combine
import RealmDataManager
import XCTest

@testable import movies

class MovieRepositoryTest: XCTestCase {
    
    private var mockConfiguration: MockConfiguration!
    private var mockApiRestClient: MockApiRestClient!
    private var mockDatabase: Database!
    
    private var repository: MovieRepository!
    
    var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockConfiguration = MockConfiguration()
        mockApiRestClient = MockApiRestClient()
        mockDatabase = MockDatabaseBuilder.build()
        
        repository = MovieRepository(apiRestClient: mockApiRestClient,
                                     databaseManager: mockDatabase,
                                     configuration: mockConfiguration)
    }
    
    override func tearDownWithError() throws {
        mockDatabase = nil
        mockConfiguration = nil
        mockApiRestClient = nil
        
        repository = nil
        
        try super.tearDownWithError()
    }
    
    func testGetMovie_OK() {
        let expectation = XCTestExpectation(description: "get a movie") //1. Creamos expectation
        
        repository.$result.dropFirst().sink { result in
            XCTAssertNotNil(result)
            XCTAssertEqual(result?.id, "12345")
            XCTAssertEqual(result?.posterPath, "http://mock.com/images/path/image/test.jpeg")
            
            expectation.fulfill() //3. Marcamos el proceso como finalizado
            
        }.store(in: &cancellables)
        
        mockApiRestClient.fetchMovie = MockApiObjectData.buildSuccessApiObjectMovie() //Añadimos datos de entrada mock
        
        repository.loadMovie(movieId: "12345") //Método a testear
        
        wait(for: [expectation], timeout: 2) //2. Esperamos 2 segundos
    }
    
    func testGetMovie_WRONG() {
        let expectation = XCTestExpectation(description: "get a movie") //1. Creamos expectation
        
        repository.$result.dropFirst().sink { result in
            XCTAssertNil(result)
            
            expectation.fulfill() //3. Marcamos el proceso como finalizado
            
        }.store(in: &cancellables)
        
        mockApiRestClient.fetchMovie = MockApiObjectData.buildErrorApiObjectMovie() //Añadimos datos de entrada mock
        
        repository.loadMovie(movieId: "12345") //Método a testear
        
        wait(for: [expectation], timeout: 2) //2. Esperamos 2 segundos
    }
    
}
