//
//  ErrorResponse.swift
//  PushFramework
//
//  Created by Abhishek on 08/03/21.
//

import Foundation

struct NetworkResponse : Codable {
    let errorCode: Int?
    let data: DataClass?
    let errorMessage: String?

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case data
        case errorMessage = "error_message"
    }
}



