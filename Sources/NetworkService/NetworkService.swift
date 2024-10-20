//
//  NetworkService.swift
//  NetworkService
//
//  Created by Abhilash Palem on 15/10/24.
//
import Foundation
import Alamofire
import Combine

public final class NetworkService {
    
    private let dataSession: DataSession
    private let resourceSession: ResourceSession
    private let configuration: NetworkServiceConfiguration
    
    public init(configuration: NetworkServiceConfiguration) {
        self.dataSession = DataSession(configuration: configuration)
        self.resourceSession = ResourceSession(configuration: configuration)
        self.configuration = configuration
    }
    
}
public extension NetworkService {
    func fetchData<T: Decodable & Sendable>(_ route: any APIRoutable, responseType: T.Type, completion: @escaping @Sendable (Result<T, NetworkAPIFailure>) -> Void) {
        dataSession.request(route, baseURL: configuration.baseURL, responseType: responseType, completion: completion)
    }
    
    func fetchData<T: Decodable & Sendable>(_ route: any APIRoutable, responseType: T.Type) -> AnyPublisher<T, NetworkAPIFailure> {
        dataSession.fetchData(route, responseType: responseType)
    }
    
    func fetchResource(_ route: any APIRoutable, completion: @escaping @Sendable (Result<Data, NetworkAPIFailure>) -> Void) {
        resourceSession.request(route, baseURL: configuration.baseURL, completion: completion)
    }
    
    func fetchResource(_ route: any APIRoutable) -> AnyPublisher<Data, NetworkAPIFailure> {
        resourceSession.fetchResource(route)
    }
}
