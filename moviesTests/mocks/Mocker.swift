//
//  Mocker.swift
//  movies
//
//  Created by Daniel Ferrer on 7/2/23.
//

import Foundation
import Mocker

class MockerMock {
    
    public static func mockMovieListOK() {
        let url = URL(string: "https://api.mock/movie/popular?page=1&api_key=api_key_value")!
        
        let mock = Mock(url: url, dataType: Mock.DataType.json, statusCode: 200, data: [
            .get: MockedData.moviesListJSON()
        ])
        
        Mocker.register(mock)
    }
    
    public static func mockMovieListWRONG() {
        let url = URL(string: "https://api.mock/movie/popular?page=1&api_key=api_key_value")!
        
        let mock = Mock(url: url, dataType: Mock.DataType.json, statusCode: 503, data: [
            .get: Data()
        ])
        
        Mocker.register(mock)
    }
    
    public static func mockMovieDetailOK() {
        let url = URL(string: "https://api.mock/movie/12345?api_key=api_key_value")!
        
        let mock = Mock(url: url, dataType: Mock.DataType.json, statusCode: 200, data: [
            .get: MockedData.movieDetailJSON()
        ])
        
        Mocker.register(mock)
    }
    
    public static func mockMovieDetailWRONG() {
        let url = URL(string: "https://api.mock/movie/12345?api_key=api_key_value")!
        
        let mock = Mock(url: url, dataType: Mock.DataType.json, statusCode: 503, data: [
            .get: Data()
        ])
        
        Mocker.register(mock)
    }
    
    
}
