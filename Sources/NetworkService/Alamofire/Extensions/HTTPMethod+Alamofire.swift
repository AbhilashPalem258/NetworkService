//
//  HTTPMethod+Alamofire.swift
//  NetworkService
//
//  Created by Abhilash Palem on 17/10/24.
//
import Alamofire

extension HTTPMethod {
    var method: Alamofire.HTTPMethod {
        switch self {
        case .get: return .get
        case .delete: return .delete
        case .post: return .post
        case .put: return .put
        }
    }
}
