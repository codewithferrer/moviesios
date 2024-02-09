//
//  NetworkBoundResource.swift
//  movies
//
//  Created by Daniel Ferrer on 22/10/22.
//

import Foundation
import Combine
import Alamofire
import SwiftUI
import RealmSwift


protocol NetworkBoundResourceProtocol: ObservableObject {
    associatedtype ResultType
    associatedtype DatabaseRequestType: Object
    associatedtype ApiRequestType: Codable
    
    var result: ResultType? { get set }
    var loadMoreState: LoadMoreState { get set }
    

    func fetchDatabase() throws -> Results<DatabaseRequestType>?
    func convertFromDatabaseToResults(data: Results<DatabaseRequestType>) -> ResultType?
    
    func fetchWS(page: Int) -> AnyPublisher<DataResponse<ApiRequestType, ApiRestError>, Never>?
    func saveFromAPIToDatabase(response: DataResponse<ApiRequestType, ApiRestError>)
    func hasMorePages(response: DataResponse<ApiRequestType, ApiRestError>) -> Bool
}

open class NetworkBoundResource<ResultType, DatabaseRequestType: Object, ApiRequestType: Codable>: NetworkBoundResourceProtocol {
    @Published var result: ResultType? = nil
    @Published var loadMoreState: LoadMoreState = LoadMoreState(isRunning: false, hasMorePages: true)
    
    internal var cancellableSet: Set<AnyCancellable> = []
    internal var numPage: Int = 0
    
    func fetchDatabase() throws -> Results<DatabaseRequestType>? {
        return nil
    }
    
    func convertFromDatabaseToResults(data: Results<DatabaseRequestType>) -> ResultType? {
        return nil
    }
    
    func fetchWS(page: Int) -> AnyPublisher<DataResponse<ApiRequestType, ApiRestError>, Never>? {
        return nil
    }
    
    func saveFromAPIToDatabase(response: DataResponse<ApiRequestType, ApiRestError>) {
        
    }
    
    func hasMorePages(response: DataResponse<ApiRequestType, ApiRestError>) -> Bool {
        return true
    }
    
    func fetch() {
        
        fetchNextPage()
        
        loadFromDatabase()
    }
    
    func loadFromDatabase() {
        try? fetchDatabase()?
            .collectionPublisher
            .subscribe(on: DispatchQueue(label: "background queue"))
            .freeze()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
            },receiveValue: { results in
                self.result = self.convertFromDatabaseToResults(data: results)
            })
            .store(in: &cancellableSet)
    }
    
    private func loadFromAPI(page: Int) {
        fetchWS(page: page)?
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    print(dataResponse.error.debugDescription)
                    self.loadMoreState = LoadMoreState(isRunning: false, hasMorePages: false)
                } else {
                    self.saveFromAPIToDatabase(response: dataResponse)
                    
                    self.loadMoreState = LoadMoreState(isRunning: false, hasMorePages: self.hasMorePages(response: dataResponse))
                }
            }
            .store(in: &cancellableSet)
    }
    
    func fetchNextPage() {
        if self.loadMoreState.isRunning || !self.loadMoreState.hasMorePages {
            return
        }
        await MainActor.run {
            self.loadMoreState = LoadMoreState(isRunning: true, hasMorePages: hasMorePages)
        }
        numPage += 1
        loadFromAPI(page: numPage)
    }
}
