//
//  ApiServiceTest.swift
//  moviesTests
//
//  Created by Daniel Ferrer on 9/2/23.
//

import Foundation
import Combine
import XCTest

@testable import movies

class ApiServiceTest: XCTestCase {
    
    private var mockConfiguration: MockConfiguration!
    private var apiRestClient: ApiRestClient!
    
    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockConfiguration = MockConfiguration()
        apiRestClient = ApiRestClient(configuration: mockConfiguration)
        
    }
    
    override func tearDownWithError() throws {
        
        mockConfiguration = nil
        apiRestClient = nil
        
        try super.tearDownWithError()
    }
    
    func testGetMovieList_OK() {
        let expectation = XCTestExpectation(description: "get movies list") //1. Creamos expectation
        
        MockerMock.mockMovieListOK() //Registramos el mock de la petición del listado
        
        //Método a testear
        apiRestClient.fetchPopularMovies(page: 1).sink { results in
            //Comprobaciones del test
            XCTAssertNotNil(results)
            
            XCTAssertEqual(results.response?.statusCode, 200)
            
            var apiObject = results.value!
            XCTAssertEqual(apiObject.results.count, 20)
            
            
            let firstItem = apiObject.results.first!
            XCTAssertEqual(firstItem.id, 505642)
            XCTAssertEqual(firstItem.original_title, "Black Panther: Wakanda Forever")
            XCTAssertEqual(firstItem.poster_path, "/sv1xJUazXeYqALzczSZ3O6nkH75.jpg")
            XCTAssertEqual(firstItem.overview, "Queen Ramonda, Shuri, M’Baku, Okoye and the Dora Milaje fight to protect their nation from intervening world powers in the wake of King T’Challa’s death.")
            
            expectation.fulfill() //3. Marcamos el proceso como finalizado
            
        }.store(in: &cancellables)
        
        
        
        wait(for: [expectation], timeout: 5) //2. Esperamos 2 segundos
    }
    
    func testGetMovieList_WRONG() {
        let expectation = XCTestExpectation(description: "get movies list") //1. Creamos expectation
        
        MockerMock.mockMovieListWRONG() //Registramos el mock de la petición del listado
        
        //Método a testear
        apiRestClient.fetchPopularMovies(page: 1).sink { results in
            //Comprobaciones del test
            
            XCTAssertNotNil(results)
            
            XCTAssertEqual(results.response?.statusCode, 503)
            
            expectation.fulfill() //3. Marcamos el proceso como finalizado
            
        }.store(in: &cancellables)
        
        
        
        wait(for: [expectation], timeout: 2) //2. Esperamos 2 segundos
    }
    
    func testGetMovieDetail_OK() {
        let expectation = XCTestExpectation(description: "get movies detail") //1. Creamos expectation
        
        MockerMock.mockMovieDetailOK() //Registramos el mock de la petición del listado
        
        //Método a testear
        apiRestClient.fetchMovie(movieId: "12345").sink { results in
            //Comprobaciones del test
            XCTAssertNotNil(results)
            
            XCTAssertEqual(results.response?.statusCode, 200)
            
            var apiObject = results.value!
            
            XCTAssertEqual(apiObject.id, 505642)
            XCTAssertEqual(apiObject.original_title, "Black Panther: Wakanda Forever")
            XCTAssertEqual(apiObject.poster_path, "/sv1xJUazXeYqALzczSZ3O6nkH75.jpg")
            XCTAssertEqual(apiObject.overview, "Queen Ramonda, Shuri, M’Baku, Okoye and the Dora Milaje fight to protect their nation from intervening world powers in the wake of King T’Challa’s death.")
            
            expectation.fulfill() //3. Marcamos el proceso como finalizado
            
        }.store(in: &cancellables)
        
        
        
        wait(for: [expectation], timeout: 2) //2. Esperamos 2 segundos
    }
    
    func testGetMovieDetail_WRONG() {
        let expectation = XCTestExpectation(description: "get movies detail") //1. Creamos expectation
        
        MockerMock.mockMovieDetailWRONG() //Registramos el mock de la petición del listado
        
        //Método a testear
        apiRestClient.fetchMovie(movieId: "12345").sink { results in
            //Comprobaciones del test
            
            XCTAssertNotNil(results)
            
            XCTAssertEqual(results.response?.statusCode, 503)
            
            expectation.fulfill() //3. Marcamos el proceso como finalizado
            
        }.store(in: &cancellables)
        
        
        
        wait(for: [expectation], timeout: 2) //2. Esperamos 2 segundos
    }
    
}
    
