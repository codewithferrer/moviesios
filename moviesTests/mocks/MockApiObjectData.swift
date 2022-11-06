//
//  MockApiObjectData.swift
//  moviesTests
//
//  Created by Daniel Ferrer on 4/11/22.
//

import Foundation
import Alamofire
import Combine

@testable import movies

class MockApiObjectData {
    
    
    static func buildSuccessApiObjectMovie() -> AnyPublisher<DataResponse<ApiObjectMovie, ApiRestError>, Never> {
            
        let data = ApiObjectMovie(id: 12345, original_title: "title mocked", overview: "Lorem ipsum", poster_path: "/path/image/test.jpeg")
        
        return createSuccessPublisher(data: data)
    }
    
    static func buildErrorApiObjectMovie() -> AnyPublisher<DataResponse<ApiObjectMovie, ApiRestError>, Never> {
        return createErrorPublisher(error: ConfigError(code: 555, message: "No URL defined"))
    }
    
    static func buildSuccessApiObjectMovies() -> AnyPublisher<DataResponse<ApiObjectPaginator<ApiObjectMovie>, ApiRestError>, Never> {
        var data: [ApiObjectMovie] = []
        for i in 12341...12350 {
            data.append(
                ApiObjectMovie(id: Int64(i), original_title: "title mocked \(i)", overview: "Lorem ipsum \(i)", poster_path: "/path/image/test_\(i).jpeg")
            )
        }
        var paginator = ApiObjectPaginator(page: 1, total_pages: 10, total_results: 10, results: data)
        return createSuccessPublisher(data: paginator)
    }
    
    static func buildErrorApiObjectMovies() -> AnyPublisher<DataResponse<ApiObjectPaginator<ApiObjectMovie>, ApiRestError>, Never> {
        return createErrorPublisher(error: ConfigError(code: 555, message: "No URL defined"))
        
    }
    
    
    private static func createSuccessPublisher<T: Codable>(data: T) -> AnyPublisher<DataResponse<T, ApiRestError>, Never> {
                
        return Just<DataResponse<T, ApiRestError>>(
            DataResponse(request: nil,
                         response: nil,
                         data: nil,
                         metrics: nil,
                         serializationDuration: 0,
                         result: .success(data)
                        )
        )
        .eraseToAnyPublisher()
        
    }
    
    private static func createErrorPublisher<T: Codable>(error: Error) -> AnyPublisher<DataResponse<T, ApiRestError>, Never> {
                
        return Just<DataResponse<T, ApiRestError>>(
            DataResponse(request: nil,
                         response: nil,
                         data: nil,
                         metrics: nil,
                         serializationDuration: 0,
                         result: .failure(ApiRestError(error: error, serverError: nil))
                        )
        )
        .eraseToAnyPublisher()
        
    }
    
}
