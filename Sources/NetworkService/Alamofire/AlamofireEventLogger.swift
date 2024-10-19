//
//  AlamofireEventLogger.swift
//  NetworkService
//
//  Created by Abhilash Palem on 16/10/24.
//

import Alamofire
import Foundation
import OSLog

struct AFEventLogger: EventMonitor {
    
    let logger: Logger
    
    func request<Value>(
        _ request: DataRequest,
        didParseResponse response: DataResponse<Value, AFError>
    ) where Value : Sendable {
        let allRequestHeaders = request.request.flatMap { request in
            request.allHTTPHeaderFields.map {
                $0.description
            }
        }
        
        let httpBody = request.request?.httpBody.flatMap { data in
            String(decoding: data, as: UTF8.self)
        } ?? "None"
        
        let allResponseHeaders = response.response?.allHeaderFields ?? [:]
        
        let responseStr = response.response.debugDescription
        
        let message = """
        =============================================================
        Request: \(request.request?.urlRequest?.debugDescription ?? "None")
        Request Body: \(httpBody)
        StatusCode: \(String(describing: response.response?.statusCode))
        Request Headers: \(String(describing: allRequestHeaders))
        Response Headers: \(String(describing: allResponseHeaders))
        Response: \(responseStr)
        ===============================================================
        """
        
        logger.debug("\(message)")
    }
}
