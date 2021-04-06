//
//  NetworkRouter.swift
//  PushFramework
//
//  Created by Abhishek on 17/02/21.
//

import Foundation

typealias NetworkRouterCompletion = (Result<Data , PEError>) -> ()
typealias NetworkRouterDownloadCompletion = (Result<(URL,URLResponse),PEError>) -> ()

protocol NetworkRouter : class {
    func request<T : Codable>(_ route : PERouter,for type : T.Type, completion: @escaping NetworkRouterCompletion)
    func requestDownload(_ route : PERouter ,completion : @escaping NetworkRouterDownloadCompletion)
    func cancel()
}
