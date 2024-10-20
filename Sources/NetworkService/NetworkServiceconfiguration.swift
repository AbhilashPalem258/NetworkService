//
//  NetworkServiceconfiguration.swift
//  NetworkService
//
//  Created by Abhilash Palem on 15/10/24.
//

import Foundation

public struct NetworkServiceConfiguration {
    let requestTimeout: Double
    let baseURL: URL
    let logEnabled: Bool
    let defaultHeaders: [String: String]?
    
    public init(requestTimeout: Double, baseURL: URL, logEnabled: Bool, defaultHeaders: [String : String]?) {
        self.requestTimeout = requestTimeout
        self.baseURL = baseURL
        self.logEnabled = logEnabled
        self.defaultHeaders = defaultHeaders
    }
}
