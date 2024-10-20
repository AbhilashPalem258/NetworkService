//
//  ResourceSession.swift
//  NetworkService
//
//  Created by Abhilash Palem on 20/10/24.
//
import Foundation
import Alamofire
import Combine

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
    
    func fetchResource(_ route: any APIRoutable) -> AnyPublisher<Data, NetworkAPIFailure> {
        Future<Data, NetworkAPIFailure> {[weak self] promise in
            #if swift(>=6)
                nonisolated(unsafe) let promise = promise
            #endif
            guard let self else {
                promise(.failure(NetworkAPIFailure.genericFailure))
                return
            }
            request(route, baseURL:  configuration.baseURL) { result in
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
