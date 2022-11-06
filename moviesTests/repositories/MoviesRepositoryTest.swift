//
//  MoviesRepositoryTest.swift
//  moviesTests
//
//  Created by Daniel Ferrer on 6/11/22.
//

import Combine
import RealmDataManager
import XCTest
@testable import movies

class MoviesRepositoryTest: XCTestCase {
    
    private var mockApiRest: MockApiRestClient!
    private var mockDatabase: Database!
    private var mockConfiguration: MockConfiguration!
    
    private var repositoryTest: MoviesRepository!
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockApiRest = MockApiRestClient()
        mockDatabase = MockDatabaseBuilder.build()
        mockConfiguration = MockConfiguration()
        
        repositoryTest = MoviesRepository(apiRestClient: mockApiRest, databaseManager: mockDatabase, configuration: mockConfiguration)
    }
    
    override func tearDownWithError() throws {
        mockDatabase = nil
        mockConfiguration = nil
        mockApiRest = nil
        
        repositoryTest = nil
        
        try super.tearDownWithError()
    }
    
    func testGetMovies_OK() {
        
        let expectation = XCTestExpectation(description: "get a list of movies")
        
        repositoryTest.$result.dropFirst().sink { result in
            XCTAssertNotNil(result)
            XCTAssertEqual(result?.count, 10)
            
            let firstItem = result?[0]
            
            XCTAssertEqual(firstItem?.id, "12341")
            XCTAssertEqual(firstItem?.posterPath, "http://mock.com/images/path/image/test_12341.jpeg")
            
            expectation.fulfill()
        }.store(in: &cancellables)
        
        
        mockApiRest.fetchPopularMovies = MockApiObjectData.buildSuccessApiObjectMovies()
        
        repositoryTest.fetch()
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testGetMovie_Wrong() {
        
        let expectation = XCTestExpectation(description: "list of movies not found")
        
        repositoryTest.$result.dropFirst().sink { result in
            XCTAssertNotNil(result)
            XCTAssertEqual(result?.count, 0)
            
            expectation.fulfill()
        }.store(in: &cancellables)
        
        
        mockApiRest.fetchPopularMovies = MockApiObjectData.buildErrorApiObjectMovies()
        
        repositoryTest.fetch()
        
        wait(for: [expectation], timeout: 2)
        
    }
    
}
