//
//  Untitled.swift
//  NetworkService
//
//  Created by Abhilash Palem on 19/10/24.
//
import Alamofire

extension DataRequest {
    func validateForServerError() -> Self {
        return validate { request,response,data in
            let statusCode = response.statusCode
            do {
                guard let data else {
                    throw NetworkAPIFailure.badResponse
                }
                let responseValidator = ServerResponseValidation(response: response, data: data)
                try responseValidator.evaluate()
            } catch let error {
                return .failure(error)
            }
            return .success(())
        }
    }
}
