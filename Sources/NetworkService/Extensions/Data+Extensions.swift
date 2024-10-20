//
//  Data+Extensions.swift
//  NetworkService
//
//  Created by Abhilash Palem on 20/10/24.
//
import Foundation
extension Data {
    var prettyPrintedJSONString: String {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: jsonObject,
                                                     options: [.prettyPrinted, .withoutEscapingSlashes]),
              let prettyJSON = String(data: data, encoding: .utf8) else {
                  return "None"
               }

        return prettyJSON
    }
}
extension Dictionary<AnyHashable, Any> {
    func data() -> Data? {
        try? JSONSerialization.data(withJSONObject: self)
    }
}
