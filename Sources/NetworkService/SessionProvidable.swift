//
//  SessionProvidable.swift
//  NetworkService
//
//  Created by Abhilash Palem on 17/10/24.
//

import Foundation

protocol SessionProtocol {
    func request<T: Decodable & Sendable>(_ route: APIRoutable, baseURL: URL, responseType: T.Type, completion: @escaping @Sendable (Result<T, NetworkAPIFailure>) -> Void)
}

protocol SessionProvidable {
    static func dataSession<S: SessionProtocol>(_ configuration: NetworkServiceConfiguration) -> S
    static func resourceSession<S: SessionProtocol>(_ configuration: NetworkServiceConfiguration) -> S
}
