//
//  NotificationExtensionManager.swift
//  PushFramework
//
//  Created by Abhishek on 16/02/21.
//

import Foundation
import UserNotifications

class NotificationExtensionManager: NotificationExtensionProtocol {
    
    var networkService : NetworkRouter
    var payLoadService : PEPayloadProtocol
    var notificationService : NotificationProtocol
    var notifcationLifeCycleService : NotificationLifeCycleService
    var userDefaultDatasource : UserDefaultProtocol
    let operationQueue : OperationQueue
    
    init(_networkService : NetworkRouter,
         _payLoadService : PEPayloadProtocol,
         _notificationService : NotificationProtocol,
         _notifcationLifeCycleService : NotificationLifeCycleService,
         _userDefaultDatasource : UserDefaultProtocol) {
        self.networkService = _networkService
        self.payLoadService = _payLoadService
        self.notificationService = _notificationService
        self.notifcationLifeCycleService = _notifcationLifeCycleService
        self.userDefaultDatasource = _userDefaultDatasource
        self.operationQueue = OperationQueue()
    }
    
    func didReceiveNotificationExtensionRequest(_ request: UNNotificationRequest,
                                                bestContentHandler : UNMutableNotificationContent) {
        let payLoad = payLoadService.response(form: request.content.userInfo)
        addButtonTo(extension: request, withNotification: payLoad, content: bestContentHandler)
        let isSponsered = bestContentHandler.userInfo[PayloadConstants.sponsored] as? Bool
        if let attachmentString = bestContentHandler.userInfo[PayloadConstants.attachmentKey] as? String {
            let sponseredInput = (attachmentString ,bestContentHandler , self.notifcationLifeCycleService , self.networkService)
            let sponserOperation = SponseredNotifictaionOperation(input: sponseredInput)
            sponserOperation.onResult = { result in
                switch result {
                case .success(let updateAttachment):
                    PELogger.info(className: String(describing: NotificationExtensionManager.self), message: updateAttachment.attachmentString)
                case .failure(let error):
                    PELogger.error(className: String(describing: NotificationExtensionManager.self), message: error.value)
                }
            }
            let downloadOperationQueue : DownloadOperationInput? = isSponsered == true ? nil  : (attachmentString , bestContentHandler , networkService)
            
            let imageDownloadOperation = DownloadAttachmentOperation(inputValue: downloadOperationQueue)
            imageDownloadOperation.onResult = { result in
                switch result {
                case .failure(let error):
                    PELogger.error(className: String(describing: NotificationExtensionManager.self), message: error.value)
                    
                case .success(let message):
                    PELogger.info(className: String(describing: NotificationExtensionManager.self), message: message)
                }
            }
            isSponsered == true ? imageDownloadOperation.addDependency(sponserOperation) : sponserOperation.cancel(with: .canceled)
            operationQueue.addOperations([sponserOperation , imageDownloadOperation], waitUntilFinished: true)
        }
        notifcationLifeCycleService.notificationLifecycleUpdate(with: .viewed, deviceHash: userDefaultDatasource.subscriberHash, notificationId: "N-49438-37382-df4bfe55fc37266b552c991f83923fbcfb0fbbe4930cf355ed3e849daacc4ffb",completionHandler: nil)
    }
    
    func serviceExtensionTimeWillExpire(_ request : UNNotificationRequest ,content: UNMutableNotificationContent?) -> UNMutableNotificationContent? {
        guard let updateContent = content else {
            return nil
        }
        let payLoad = payLoadService.response(form: request.content.userInfo)
        addButtonTo(extension: request, withNotification: payLoad, content: updateContent)
        return updateContent
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
    
    private func addButtonTo(extension request : UNNotificationRequest,
                             withNotification : PEPayload?,
                             content : UNMutableNotificationContent) {
        
        //If developer has already set the catogery identifier then we will not over ride the category with over created one
        
        if ( !request.content.categoryIdentifier.isEmpty) {
            return
        }
        
        guard let payLoad = withNotification,
              let actionButtons = payLoad.actionButtons else {
            return
        }
        
        if actionButtons.count == 0 {
            return
        }
        
        var buttons = [UNNotificationAction]()
        
        for button in actionButtons {
            let action = UNNotificationAction(identifier: button.id,
                                              title: button.text ?? "",
                                              options: .foreground)
            buttons.append(action)
        }
        let buttonIds = buttons.map{ $0.identifier }
        let categoryIdentifier = UUID().uuidString
        let category = UNNotificationCategory(identifier: categoryIdentifier, actions: buttons, intentIdentifiers: buttonIds, options: .customDismissAction)
        notificationService.setNotificationCategories([category])
        content.categoryIdentifier = categoryIdentifier
    }
}
