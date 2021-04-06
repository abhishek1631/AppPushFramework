//
//  PEOperations.swift
//  PushFramework
//
//  Created by Abhishek on 01/04/21.
//

import Foundation
import UserNotifications

//MARK: - Download operation is create in operation Queue for future depenceny and it make api call sync


typealias DownloadOperationInput = (attachmentString: String,contentToModifiy : UNMutableNotificationContent, networkService : NetworkRouter)

final class DownloadAttachmentOperation: ChainedAsyncResultOperation<DownloadOperationInput,String,PEError> {
    
    init(inputValue : DownloadOperationInput? = nil) {
        super.init(input: inputValue)
    }
    
    override func main() {
        guard let input = input else { return }
        let networkService = input.networkService
        networkService.requestDownload(.getImage(input.attachmentString)) { [weak self] result in
            switch result {
            case .success(let result):
                do {
                    try self?.updateAttactment(content: input.contentToModifiy, attachmentString: input.attachmentString, urlName: result.0 , response : result.1)
                    PELogger.info(className: String(describing: DownloadAttachmentOperation.self), message: "updated-attachements")
                    self?.finish(with: .success("updated-attachements"))
                    
                } catch let error {
                    PELogger.error(className: String(describing: DownloadAttachmentOperation.self), message: error.localizedDescription)
                    self?.finish(with: .failure(.underlying(error: error)))
                    
                }
            case.failure(let error):
                PELogger.error(className: String(describing: DownloadAttachmentOperation.self), message: error.value)
                self?.finish(with: .failure(.underlying(error: error)))
            }
        }
    }
    
    private func updateAttactment(content: UNMutableNotificationContent,
                                  attachmentString : String,
                                  urlName : URL, response : URLResponse)  throws {
        
        let tempDirectoryUrl = FileManager.default.temporaryDirectory
        var attachmentIdString = UUID().uuidString + urlName.lastPathComponent
        if let suggestedFilename = response.suggestedFilename {
            attachmentIdString = UUID().uuidString + suggestedFilename
        }
        let tempFileUrl = tempDirectoryUrl.appendingPathComponent(attachmentIdString)
        try FileManager.default.moveItem(at: urlName, to: tempFileUrl)
        let attachment = try UNNotificationAttachment(identifier: attachmentString,
                                                      url: tempFileUrl,
                                                      options: nil)
        content.attachments.append(attachment)
    }
    
    override final func cancel() {
        input?.networkService.cancel()
        cancel(with: .canceled)
    }
}

//MARK: - SponseredNotifictaionOperation is create in operation Queue for future depenceny and it make api call sync

typealias SponseredNotificationInput = (previousAttachment : String ,mutableContent : UNMutableNotificationContent , notificationLifeCycle : NotificationLifeCycleService , network : NetworkRouter)

final class SponseredNotifictaionOperation : ChainedAsyncResultOperation<SponseredNotificationInput, DownloadOperationInput , PEError> {
    
    init(input : SponseredNotificationInput) {
        super.init(input: input)
    }
    
    override func main() {
        guard let input = input else {return}
        
        input.notificationLifeCycle.sponseredNotification(for: SponsoredResponse.self) { [weak self] result in
            
            switch result {
             case .success(let response):
                let links = response.data.map { data -> String in return data.options.data}.first
                let icon = response.data.map {data -> String in return data.options.icon}.first ?? ""
                let body = response.data.map {data -> String in return data.options.body}.first
                let title = response.data.map {data -> String in return data.title}.first
                input.mutableContent.title = title ?? ""
                input.mutableContent.body = body ?? ""
                input.mutableContent.userInfo[PayloadConstants.deeplinkingKey] = links
                PELogger.info(className: String(describing: SponseredNotifictaionOperation.self), message: "content updated with sponsered")
                self?.finish(with: .success((icon,input.mutableContent,input.network)))
            case .failure(let error):
                PELogger.error(className: String(describing: SponseredNotifictaionOperation.self), message: "\(error) cascading with result provided")
                self?.finish(with: .failure(.SponseredfailWithContent((input.previousAttachment,input.mutableContent,input.network))))
            }
        }
    }
    
    override final func cancel() {
        input?.notificationLifeCycle.canceled()
        cancel(with: .canceled)
    }
}
