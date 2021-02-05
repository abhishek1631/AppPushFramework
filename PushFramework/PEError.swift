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
    
    var value : String {
        switch self {
        case .contentNotFound:
            return "Content Not Found"
        case .network:
            return "Network faliure"
        case .downloadAttachmentfailed:
            return "Download Attachment Failed"
        }
    }
}
