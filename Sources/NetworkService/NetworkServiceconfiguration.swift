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
}
