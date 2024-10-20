//
//  APIRoutable.swift
//  NetworkService
//
//  Created by Abhilash Palem on 15/10/24.
//

import Foundation

public enum HTTPMethod {
    case get
    case post
    case put
    case delete
    
    var notation: String {
        switch self {
        case .get:
            "GET"
        case .post:
            "POST"
        case .put:
            "PUT"
        case .delete:
            "DELETE"
        }
    }
}

public protocol APIRoutable {
    var httpMethod: HTTPMethod {get}
    var parameters: AnyEncodable? {get}
    var path: String { get }
    var headers: [String: String] {get}
}
extension APIRoutable {
    var httpMethod: HTTPMethod {
        .get
    }
    
    var parameters: AnyEncodable? {
        nil
    }
}

public struct AnyEncodable: Encodable {

    private let _encode: (Encoder) throws -> Void
    public init<T: Encodable>(_ wrapped: T) {
        _encode = wrapped.encode
    }

    public func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}

public extension Encodable {
    func eraseToAnyEncodable() -> AnyEncodable {
        .init(self)
    }
}

public prefix func ~ (value: any Encodable) -> AnyEncodable {
    value.eraseToAnyEncodable()
}

extension Encodable {
    func toJson(encoder: JSONEncoder = .init()) throws -> [String: any Any & Sendable] {
        let data = try encoder.encode(self)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: any Any & Sendable]
        return json ?? [:]
    }
}
