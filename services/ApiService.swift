//
//  ApiService.swift
//  movies
//
//  Created by Daniel Ferrer on 20/8/22.
//

import Foundation
import Combine
import Alamofire

struct ApiRestError: Error {
  let error: Error
  let serverError: ServerError?
}

struct ServerError: Codable, Error {
    var status: String
    var message: String
}

struct ConfigError: Error {
    var code: Int
    var message: String
}


protocol ApiServiceProtocol {
    
    func fetchPopularMovies(page: Int) -> AnyPublisher<DataResponse<ApiObjectPaginator<ApiObjectMovie>, ApiRestError>, Never>
    
    func fetchMovie(movieId: String) -> AnyPublisher<DataResponse<ApiObjectMovie, ApiRestError>, Never>
    
}

class ApiRestClient {
    
    private let urlBase: String = "https://api.themoviedb.org/3/movie/"
    private let APIKEY_NAME: String = "api_key"
    private let configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
}

extension ApiRestClient: ApiServiceProtocol {
    
    func fetchPopularMovies(page: Int) -> AnyPublisher<DataResponse<ApiObjectPaginator<ApiObjectMovie>, ApiRestError>, Never> {
        guard let apiKey = configuration.apiKey,
            let url = URL(string: "\(urlBase)popular?page=\(page)&\(APIKEY_NAME)=\(apiKey)") else {
                return emptyPublisher(error: ConfigError(code: 555, message: "No URL defined"))
        }
        
        return AF.request(url, method: .get)
            .proccessResponse(type: ApiObjectPaginator<ApiObjectMovie>.self)
            
    }
    
    func fetchMovie(movieId: String) -> AnyPublisher<DataResponse<ApiObjectMovie, ApiRestError>, Never> {
        guard let apiKey = configuration.apiKey,
            let url = URL(string: "\(urlBase)\(movieId)?\(APIKEY_NAME)=\(apiKey)") else {
                 return emptyPublisher(error: ConfigError(code: 555, message: "No URL defined"))
        }
        
        return AF.request(url, method: .get)
            .proccessResponse(type: ApiObjectMovie.self)
    }
    
    
    private func emptyPublisher<T: Codable>(error: ConfigError) -> AnyPublisher<DataResponse<T, ApiRestError>, Never> {
            
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

extension DataRequest {
    
    func proccessResponse<T: Codable>(type: T.Type) -> AnyPublisher<DataResponse<T, ApiRestError>, Never> {
        validate()
        .publishDecodable(type: type.self)
        .map { response in
            response.mapError { error in
                let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0)}
                return ApiRestError(error: error, serverError: serverError)
                
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
}
