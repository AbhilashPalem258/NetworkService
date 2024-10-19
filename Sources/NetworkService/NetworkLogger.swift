//
//  NetworkLogger.swift
//  NetworkService
//
//  Created by Abhilash Palem on 15/10/24.
//
import OSLog

extension Logger {
    static var networkServiceSubsystem: String {
        "\(Bundle.main.bundleIdentifier ?? "App").NetworkService"
    }
    
    static let networkService = Logger(subsystem: networkServiceSubsystem, category: "NetworkService.Logger")
}
