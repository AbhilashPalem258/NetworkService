//
//  NetworkAPIFailure+Alamofire.swift
//  NetworkService
//
//  Created by Abhilash Palem on 17/10/24.
//
import Alamofire

extension NetworkAPIFailure {
    static func fromAFError(_ error: AFError) -> NetworkAPIFailure {
        var failureType: Self = .genericFailure
        switch error {
        case .invalidURL,
             .parameterEncodingFailed,
             .multipartEncodingFailed,
             .urlRequestValidationFailed,
             .createUploadableFailed,
             .createURLRequestFailed,
             .parameterEncoderFailed,
             .requestAdaptationFailed:
            failureType = .badRequest
        case .responseValidationFailed(let reason):
            switch reason {
            case .dataFileNil,
                 .dataFileReadFailed,
                 .missingContentType,
                 .unacceptableContentType,
                 .unacceptableStatusCode(_):
                failureType = .badResponse
            case .customValidationFailed(error: _):
                // If error is due to shuttl server response validator
                failureType = .genericFailure
            }
        case .responseSerializationFailed:
            failureType = .failureInParsing
            
        case .explicitlyCancelled:
            failureType = .cancelled
        case .serverTrustEvaluationFailed(reason: _):
            // Handle if ssl pinning enabled
            failureType = .genericFailure
        default:
            failureType = .genericFailure
        }
        return failureType
    }
}
