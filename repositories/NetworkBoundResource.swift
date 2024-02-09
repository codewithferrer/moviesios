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
import SwiftData


protocol NetworkBoundResourceProtocol: ObservableObject {
    associatedtype ResultType
    associatedtype DatabaseRequestType: PersistentModel
    associatedtype ApiRequestType: Codable
    
    var result: ResultType? { get set }
    var loadMoreState: LoadMoreState { get set }
    
    
    func fetchDatabase() async throws -> AnyPublisher<[DatabaseRequestType], Never>?
    func convertFromDatabaseToResults(data: [DatabaseRequestType]) -> ResultType?
    
    func fetchWS(page: Int) async -> ApiRequestType?
    func saveFromAPIToDatabase(response: ApiRequestType) async
    func hasMorePages(response: ApiRequestType) async -> Bool
}

open class NetworkBoundResource<ResultType, DatabaseRequestType: PersistentModel, ApiRequestType: Codable>: NetworkBoundResourceProtocol {
    @Published var result: ResultType? = nil
    @Published var loadMoreState: LoadMoreState = LoadMoreState(isRunning: false, hasMorePages: true)
    
    internal var cancellableSet: Set<AnyCancellable> = []
    internal var numPage: Int = 0
    internal var isRunning: Bool = false
    internal var hasMorePages: Bool = true
    
    func fetchDatabase() async throws -> AnyPublisher<[DatabaseRequestType], Never>? {
        return nil
    }
    
    func convertFromDatabaseToResults(data: [DatabaseRequestType]) -> ResultType? {
        return nil
    }
    
    func fetchWS(page: Int) async -> ApiRequestType? {
        return nil
    }
    
    func saveFromAPIToDatabase(response: ApiRequestType) async {
        
    }
    
    func hasMorePages(response: ApiRequestType) async -> Bool {
        return true
    }
    
    func fetch() async {
        if numPage == 0 {
            await loadFromDatabase()
        }
        
        await fetchNextPage()
    }
    
    func loadFromDatabase() async {
        try? await fetchDatabase()?
            .subscribe(on: DispatchQueue(label: "background queue"))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { results in
                self.result = self.convertFromDatabaseToResults(data: results)
            })
            .store(in: &cancellableSet)
            
    }
    
    private func loadFromAPI(page: Int) async {
        isRunning = true
        let response = await fetchWS(page: page)
        
        if let value = response {
            await self.saveFromAPIToDatabase(response: value)
            let _hasMorePages = await self.hasMorePages(response: value)
            hasMorePages = _hasMorePages
            isRunning = false
            await MainActor.run {
                self.loadMoreState = LoadMoreState(isRunning: false, hasMorePages: _hasMorePages)
            }
        } else {
            hasMorePages = false
            isRunning = false
            await MainActor.run {
                self.loadMoreState = LoadMoreState(isRunning: false, hasMorePages: false)
            }
        }
    }
    
    func fetchNextPage() async {
        if self.isRunning || !self.hasMorePages {
            return
        }
        isRunning = true
        await MainActor.run {
            self.loadMoreState = LoadMoreState(isRunning: isRunning, hasMorePages: hasMorePages)
        }
        numPage += 1
        await loadFromAPI(page: numPage)
    }
}
