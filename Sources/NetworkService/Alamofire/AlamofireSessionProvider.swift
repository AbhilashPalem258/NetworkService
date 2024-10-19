//
//  AlamofireSessionProvider.swift
//  NetworkService
//
//  Created by Abhilash Palem on 18/10/24.
//

import Foundation
import Alamofire

//struct AlamofireSessionProvider: SessionProvidable {
//    static func dataSession<S>(_ configuration: NetworkServiceConfiguration) -> S where S : SessionProtocol {
//        AFDataSession(configuration: configuration) as! S
//    }
//    
//    static func resourceSession<S>(_ configuration: NetworkServiceConfiguration) -> S where S : SessionProtocol {
//        AFDataSession(configuration: configuration) as! S
//    }
//}

class ResourceSession {
    
    private let resourceCache: URLCache = {
        var fileURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        fileURL?.append(component: "Resources")
        return URLCache(memoryCapacity: 50_000_000, diskCapacity: 100_000_000, diskPath: fileURL?.path())
    }()
    
    func request(_ route: any APIRoutable, baseURL: URL, completion: @escaping @Sendable (Result<Data, NetworkAPIFailure>) -> Void) {
        do {
            session.request(
                try constructFullURL(route: route, baseURL: baseURL),
                method: route.httpMethod.method,
                parameters: try route.parameters?.toJson(),
                headers: .init(route.headers)
            )
            .validateForServerError()
            .responseData { response in
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
    
    let configuration: NetworkServiceConfiguration
    let session: Alamofire.Session
    
    init(configuration: NetworkServiceConfiguration) {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.urlCache = resourceCache
        sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
        sessionConfiguration.timeoutIntervalForRequest = configuration.requestTimeout
        
        let eventMonitors = configuration.logEnabled ? [AFEventLogger(logger: .networkService)] : []
        self.session = Session(configuration: sessionConfiguration, eventMonitors: eventMonitors)
        self.configuration = configuration
    }
    
    private func constructFullURL(route: any APIRoutable, baseURL: URL) throws -> URL {
        guard let url = URL(string: route.path, relativeTo: baseURL) else {
            throw URLError(.badURL)
        }
        return url
    }
}

class DataSession: SessionProtocol {
    
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
        do {
            session.request(
                try constructFullURL(route: route, baseURL: baseURL),
                method: route.httpMethod.method,
                parameters: try route.parameters?.toJson(),
                headers: .init(route.headers)
            )
            .validateForServerError()
            .responseDecodable(of: responseType) { response in
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
    
    private func constructFullURL(route: any APIRoutable, baseURL: URL) throws -> URL {
        guard let url = URL(string: route.path, relativeTo: baseURL) else {
            throw URLError(.badURL)
        }
        return url
    }
}
