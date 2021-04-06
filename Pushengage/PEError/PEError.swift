//
//  PEError.swift
//  PushFramework
//
//  Created by Abhishek on 05/02/21.
//

import Foundation
enum PEError : Error {
    case contentNotFound
    case network
    case downloadAttachmentfailed
    case parametersNil
    case encodingFailed
    case missingURL
    case parsingError
    case invalidStatusCode
    case dataEncodeingFailed
    case errorResponse(String)
    case networkNotReachable
    case canceled
    case missingInputURL
    case missingRedirectURL
    case underlying(error: Swift.Error)
    case SponseredfailWithContent(DownloadOperationInput)
    case incorrectParameter
    var value : String {
        switch self {
        case .contentNotFound:
            return "Content Not Found"
        case .network:
            return "Network faliure"
        case .downloadAttachmentfailed:
            return "Download Attachment Failed"
        case .parametersNil:
            return "Parameters were nil."
        case .encodingFailed:
            return "Parameter encoding failed"
        case .missingURL:
            return "URL is nil"
        case .parsingError:
            return "Error in parsing file"
        case .invalidStatusCode:
            return "invalid status code"
        case .dataEncodeingFailed:
             return "data encodeing failed"
        case .errorResponse(let errorMessage):
            return errorMessage
        case .networkNotReachable:
            return "Network not Reachable"
        case .canceled:
            return "Canceled the operation in operationQueue"
        case .missingInputURL:
            return "input URL is missing"
        case .missingRedirectURL:
            return "missing redirect url"
        case .underlying(let error):
            return error.localizedDescription
        case .SponseredfailWithContent:
            return "failed with previous mutable content"
        case .incorrectParameter:
            return "incorrect parameter for type of call"
        }
    }
}
