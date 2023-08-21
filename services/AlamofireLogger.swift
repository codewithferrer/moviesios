//
//  AlamofireLogger.swift
//  movies
//
//  Created by Daniel Ferrer on 21/8/23.
//

import Foundation
import Alamofire

class AlamofireLogger: EventMonitor {
    
    enum LogLevel: Int {
        case None = 0, Basic = 1, Headers = 2, Body = 3
    }
    
    private var logLevel: LogLevel
        
    init(logLevel: LogLevel) {
        self.logLevel = logLevel
    }
    
    func requestDidResume(_ request: Request) {
        if logLevel == .None { return }
        
        if logLevel.rawValue >= LogLevel.Basic.rawValue {
            NSLog("⚡️⚡️⚡️⚡️ Request Started: \(request)")
        }
        
        if logLevel.rawValue >= LogLevel.Headers.rawValue {
            let allHeaders = request.request.flatMap {
                $0.allHTTPHeaderFields.map { $0.description }
            } ?? "None"
            NSLog("⚡️⚡️⚡️⚡️ Headers: \(allHeaders)")
        }
        
        if logLevel.rawValue >= LogLevel.Body.rawValue {
            let body = request.request.flatMap {
                $0.httpBody.map {
                    String(decoding: $0, as: UTF8.self)
                }
            } ?? "None"
            
            NSLog("⚡️⚡️⚡️⚡️ Body Data: \(body)")
        }
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: AFDataResponse<Value>) {
        if logLevel == .None { return }
        
        if logLevel.rawValue >= LogLevel.Basic.rawValue {
            let url = response.response?.url?.absoluteString ?? ""
            let statusCode = response.response?.statusCode ?? -1
            NSLog("⚡️⚡️⚡️⚡️ Response Received: \(url) (\(statusCode))")
        }
        
        if logLevel.rawValue >= LogLevel.Headers.rawValue {
            NSLog("⚡️⚡️⚡️⚡️ Headers: \(String(describing: response.response?.allHeaderFields))")
        }
        
        if logLevel.rawValue >= LogLevel.Body.rawValue {
            NSLog("⚡️⚡️⚡️⚡️ Body Data: \(response.debugDescription)")
        }
    }
    
}
