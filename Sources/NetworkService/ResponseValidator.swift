//
//  ResponseValidator.swift
//  NetworkService
//
//  Created by Abhilash Palem on 15/10/24.
//

import Foundation

/*
 {
    data: {
    },
    status: "SUCCESS",
    error: {
        code: 1001,
        message: "",
    }
 }
 */

// https://gist.github.com/IngmarBoddington/5056166
struct ServerResponseValidation {
    let response: HTTPURLResponse
    let data: Data

    func evaluate() throws {
        try checkForLogout()
        try checkForServerError()
        if !isResponseOK(statusCode: response.statusCode) {
            throw NetworkAPIFailure.badResponse
        }
    }
    
    func checkForLogout() throws {
        
    }
    
    func checkForServerError() throws {
//        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any], let status = json["status"] as? String else {
//            throw NetworkAPIFailure.badResponse
//        }
//        if status == "SUCCESS" {
//            
//        } else {
//            throw NetworkAPIFailure.failureInResponse(title: "Error", message: "Error message", errorCode: 1201)
//        }
    }
    
    func isResponseOK(statusCode: Int) -> Bool {
        return (200...299).contains(statusCode)
    }
}

extension String: Error {}
