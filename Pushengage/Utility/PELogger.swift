//
//  PELogger.swift
//  PushFramework
//
//  Created by Abhishek on 26/02/21.
//

import Foundation

typealias Response = (request: URLRequest?,data : Data?, response : URLResponse?)

struct PELogger {
    
    static func verbose(className: String, message: String) {
        #if DEBUG
        print(className + ": " + message)
        #endif
    }

    static func debug(className: String, message: String) {
        #if DEBUG
        print(className + ": " + message)
        #endif
    }

    static func info(className: String, message: String) {
        #if DEBUG
        print(className + ": " + message)
        #endif
    }

    static func warning(className: String, message: String) {
        #if DEBUG
        print(className + ": " + message)
        #endif
    }

    static func error(className: String, message: String) {
        #if DEBUG
        print(className + ": " + message)
        #endif
    }

    static func logNetworkRequest(className: String, request: URLRequest) {
        #if DEBUG
        print(className + ": " + "Request started at : \(Date())")
        print(className + ": " + "Request URL : \(String(describing: request.url))")
        print(className + ": " + "Request Headers : \(String(describing: request.allHTTPHeaderFields))")
        let requestBody = request.httpBody
        if let data = requestBody, let jsonString = String(data: data, encoding: .utf8) {
            print(className + ": " + "Request Body JSON: \(jsonString)")
        }
        #endif
    }

    static func logNetworkResponse(className: String, response: Response) {
        #if DEBUG
        print(className + ": " + "Response received at : \(Date())")
        print(className + ": " + "Response for  : \(String(describing: response.request?.url))")
        let responseStatus = response.response as? HTTPURLResponse
        print(className + ": " + "Response status code : \(String(describing: responseStatus?.statusCode))")
        if let data = response.data {
            print(className + ": " + "Response Body : \(String(data: data, encoding: .utf8)  ?? "") ")
        }

        #endif
    }

    static func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        #if DEBUG
        Swift.print(items, separator: separator, terminator: terminator)
        #endif
    }
}
