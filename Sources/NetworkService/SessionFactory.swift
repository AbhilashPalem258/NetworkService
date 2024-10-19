//
//  SessionFactory.swift
//  NetworkService
//
//  Created by Abhilash Palem on 15/10/24.
//

import Foundation
import Alamofire

//enum SessionFactory {
//    private static func session(_ configuration: URLSessionConfiguration, eventMonitors: [EventMonitor]) -> Alamofire.Session {
//        Session(configuration: configuration, eventMonitors: [AFEventLogger(logger: .networkService)])
//    }
//    
//    static func dataSession(_ configuration: NetworkServiceConfiguration) -> Alamofire.Session {
//        let sessionConfiguration = URLSessionConfiguration.default
//        if let defaultHeaders = configuration.defaultHeaders {
//            sessionConfiguration.httpAdditionalHeaders = defaultHeaders
//        }
//        sessionConfiguration.timeoutIntervalForResource = 90
//        sessionConfiguration.urlCache = nil
//        sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalCacheData
//        let eventMonitors = configuration.logEnabled ? [AFEventLogger(logger: .networkService)] : []
//        let session = session(sessionConfiguration, eventMonitors: [])
//        return session
//    }
//    
//
//    
//    static func resourceSession(_ configuration: NetworkServiceConfiguration) -> Alamofire.Session  {
//        let sessionConfiguration = URLSessionConfiguration.default
//        sessionConfiguration.urlCache = resourceCache
//        sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
//        sessionConfiguration.timeoutIntervalForRequest = configuration.requestTimeout
//        
//        let eventMonitors = configuration.logEnabled ? [AFEventLogger(logger: .networkService)] : []
//        let session = session(sessionConfiguration, eventMonitors: [])
//        return session
//    }
//}
