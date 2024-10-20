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
        
        let allResponseHeaders = response.response?.allHeaderFields.data()?.prettyPrintedJSONString ?? "None"
        
        let message = """
        =============================================================
        Request: \(request.request?.urlRequest?.url?.absoluteString ?? "None")
        Request Body: \(httpBody)
        StatusCode: \(String(describing: response.response?.statusCode))
        Request Headers: \(String(describing: allRequestHeaders))
        Response Headers: \(String(describing: allResponseHeaders))
        Response: \(response.data?.prettyPrintedJSONString ?? "None")
        ===============================================================
        """
        
        logger.debug("\(message)")
    }
}
