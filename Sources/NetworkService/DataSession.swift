//
//  AlamofireSessionProvider.swift
//  NetworkService
//
//  Created by Abhilash Palem on 18/10/24.
//

import Foundation
import Alamofire
import Combine

class DataSession {
    
    let configuration: NetworkServiceConfiguration
    let session: Alamofire.Session
    
    init(configuration: NetworkServiceConfiguration) {
        self.configuration = configuration
        let sessionConfiguration = URLSessionConfiguration.default
        if let defaultHeaders = configuration.defaultHeaders {
            sessionConfiguration.httpAdditionalHeaders = defaultHeaders
        }
        sessionConfiguration.timeoutIntervalForResource = 90
        sessionConfiguration.urlCache = nil
        sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let eventMonitors = configuration.logEnabled ? [AFEventLogger(logger: .networkService)] : []
        self.session = Session(configuration: sessionConfiguration, eventMonitors: eventMonitors)
    }
    
    func request<T>(_ route: any APIRoutable, baseURL: URL, responseType: T.Type, completion: @escaping @Sendable (Result<T, NetworkAPIFailure>) -> Void) where T : Decodable, T : Sendable {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            session.request(
                try constructFullURL(route: route, baseURL: baseURL),
                method: route.httpMethod.method,
                parameters: try route.parameters?.toJson(),
                headers: .init(route.headers)
            )
            .validateForServerError()
            .responseDecodable(of: responseType, decoder: decoder) { response in
                if let value = response.value {
                    completion(.success(value))
                } else {
                    completion(.failure(NetworkAPIFailure.fromAFError(response.error!)))
                }
            }
        } catch {
            completion(.failure(.genericFailure))
        }
    }
    
    func fetchData<T: Decodable & Sendable>(_ route: any APIRoutable, responseType: T.Type) -> AnyPublisher<T, NetworkAPIFailure> {
        Future<T, NetworkAPIFailure> {[weak self] promise in
            #if swift(>=6)
                nonisolated(unsafe) let promise = promise
            #endif
            guard let self else {
                promise(.failure(NetworkAPIFailure.genericFailure))
                return
            }
            request(route, baseURL:  configuration.baseURL, responseType: responseType) { result in
                switch result {
                case .success(let model):
                    promise(.success(model))
                case .failure(let failure):
                    promise(.failure(failure))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func constructFullURL(route: any APIRoutable, baseURL: URL) throws -> URL {
        guard let url = URL(string: route.path, relativeTo: baseURL) else {
            throw URLError(.badURL)
        }
        return url
    }
}
