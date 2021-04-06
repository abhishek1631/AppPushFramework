//
//  PEPayLoadProtocol.swift
//  PushFramework
//
//  Created by Abhishek on 18/02/21.
//

import Foundation
protocol PEPayloadProtocol {
    func response(form payLoad : [AnyHashable : Any]) -> PEPayload?
}
