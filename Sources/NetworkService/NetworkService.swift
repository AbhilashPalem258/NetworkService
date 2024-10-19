//
//  NetworkService.swift
//  NetworkService
//
//  Created by Abhilash Palem on 15/10/24.
//
import Foundation
import Alamofire

public final class NetworkService {
    
    private let dataSession: DataSession
    private let resourceSession: ResourceSession
    private let configuration: NetworkServiceConfiguration
    
    init(configuration: NetworkServiceConfiguration) {
        self.dataSession = DataSession(configuration: configuration)
        self.resourceSession = ResourceSession(configuration: configuration)
        self.configuration = configuration
    }
    
}
extension NetworkService {
    func fetchData<T: Decodable & Sendable>(_ route: any APIRoutable, responseType: T.Type, completion: @escaping @Sendable (Result<T, NetworkAPIFailure>) -> Void) {
        dataSession.request(route, baseURL: configuration.baseURL, responseType: responseType, completion: completion)
    }
    
    func request(_ route: any APIRoutable, baseURL: URL, completion: @escaping @Sendable (Result<Data, NetworkAPIFailure>) -> Void) {
        resourceSession.request(route, baseURL: baseURL, completion: completion)
    }
}
