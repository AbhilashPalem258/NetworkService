//
//  APIFailure.swift
//  NetworkService
//
//  Created by Abhilash Palem on 16/10/24.
//

enum NetworkAPIFailure: Error {
    case unAuthenticated
    case noInternet
    case serverNotReachable
    case requestTimedOut
    case badRequest
    case badResponse
    case failureInResponse(title: String, message: String, errorCode: Int)
    case failureInParsing
    case logout(reason: String)
    case genericFailure
    case cancelled
}
