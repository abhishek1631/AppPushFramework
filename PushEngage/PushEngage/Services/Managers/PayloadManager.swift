//
//  PayloadManager.swift
//  PushFramework
//
//  Created by Abhishek on 18/02/21.
//

import Foundation

class PayLoadManager : PEPayloadProtocol {
    
    func response(form payLoad: [AnyHashable : Any]) -> PEPayload? {
        return parse(payload: payLoad)
    }
    
    private func parse(payload : [AnyHashable : Any]) -> PEPayload? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
            let payLoad = try JSONDecoder().decode(PEPayload.self, from: jsonData)
            return payLoad
        } catch let error {
            PELogger.error(className: String(describing: PayLoadManager.self), message: error.localizedDescription)
            return nil
        }
    }
}
