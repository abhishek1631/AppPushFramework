//
//  Router.swift
//  PushFramework
//
//  Created by Abhishek on 17/02/21.
//

import Foundation

class Router: NetworkRouter {

    
    static let session : URLSession = URLSession.init(configuration: .default)
    
    private var task : URLSessionTask?
    
    private func validation(for range : Range<Int> ,statusCode : URLResponse?) -> Bool {
        guard let code = statusCode as? HTTPURLResponse else {
            return false
        }
        return range.contains(code.statusCode)
    }
    
    
    private func errorcode<T : Codable>(for type : T.Type, from responseData : Data) throws -> (code :Int? , errorMessage : String?) {
        let decode = try JSONDecoder().decode(type.self, from: responseData)
        switch type {
        case is SponsoredResponse.Type :
            let value = decode as? SponsoredResponse
            return (value?.errorCode ,nil)
        case is NetworkResponse.Type:
            let value = decode as? NetworkResponse
            return (value?.errorCode ,value?.errorMessage)
        default:
            return (nil ,nil)
        }
    }
    
    func request<T : Codable>(_ route : PERouter,for type : T.Type, completion: @escaping NetworkRouterCompletion) {
          
        if NetworkConnectivity.isConnectedToInternet == false {
            completion(.failure(.networkNotReachable))
        }
        
        do {
            let request = try route.asURLRequest()
            PELogger.logNetworkRequest(className: String(describing: Router.self), request: request)
            task = Router.session.dataTask(with: request) { [weak self] (data, response, error) in
                PELogger.logNetworkResponse(className: String(describing: Router.self), response: (request , data, response))
                guard let responseData = data else {
                    completion(.failure(.network))
                    return
                }
                if let status = self?.validation(for: 200..<300, statusCode: response), status {
                    do {
                        let errorResponsed = try self?.errorcode(for: T.self, from: responseData)
                        if let code =  errorResponsed?.code , code == 0 {
                            completion(.success(responseData))
                        } else {
                            let message = errorResponsed?.errorMessage == nil ? "Other than Network Type Error" : errorResponsed?.errorMessage
                            PELogger.error(className: String(describing:Router.self ), message: message ?? "")
                            completion(.failure(.errorResponse(message ?? "")))
                        }
                    } catch let error {
                        PELogger.error(className: String(describing:Router.self ), message: error.localizedDescription)
                        completion(.failure(.dataEncodeingFailed))
                    }
                    
                } else {
                    completion(.failure(.invalidStatusCode))
                }
            }
        } catch let error {
            PELogger.error(className: String(describing:Router.self ), message: error.localizedDescription)
            completion(.failure(.network))
        }
        self.task?.resume()
    }
    
    func requestDownload(_ route: PERouter, completion: @escaping NetworkRouterDownloadCompletion) {
        
        if NetworkConnectivity.isConnectedToInternet == false {
            completion(.failure(.networkNotReachable))
        }
        
        do {
            let request = try route.asURLRequest()
            PELogger.logNetworkRequest(className: String(describing: Router.self), request: request)
            task = Router.session.downloadTask(with: request) { [weak self] (url,response,error) in
                PELogger.logNetworkResponse(className: String(describing: Router.self), response: (request , nil, response))
                
                guard let imageURL = url ,let _response = response else {
                    completion(.failure(.downloadAttachmentfailed))
                    return
                }
                if let status = self?.validation(for: 200..<300, statusCode: response), status {
                    completion(.success((imageURL,_response)))
                } else {
                    completion(.failure(.invalidStatusCode))
                }
            }
        } catch {
            completion(.failure(.network))
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
}
