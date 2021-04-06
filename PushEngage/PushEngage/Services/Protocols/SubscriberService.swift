//
//  NetworkDataService.swift
//  PushFramework
//
//  Created by Abhishek on 25/02/21.
//

import Foundation

typealias ServiceCallBack = (Result<Parameters? , PEError>) -> ()
typealias ServiceCallWithMessage = (Result<String , PEError>) -> ()
protocol SubscriberService {
    func addSubscriber(completionHandler : ServiceCallBack?)
    func getSubscriber(for fields : [String], completionHandler : @escaping ServiceCallBack)
    func update(attributes: Parameters , completionHandler : @escaping ServiceCallWithMessage)
    func getAttribute(completionHandler : @escaping ServiceCallBack)
    func updateSubscriberStatus(completionHandler : ServiceCallWithMessage?)
    func addProfile(id : String, completionHandler : @escaping ServiceCallWithMessage)
    func deleteAttribute(with values : [String], completionHandler : @escaping ServiceCallWithMessage)
    func upgradeSubscription(completion : @escaping (Bool) -> Void)
    func updateTimeZone()
    func update(segments : [String] , action : SegmentActions , completionHandler : @escaping ServiceCallWithMessage)
    func update(dynamic segmentInfo : [Parameters], completionHandler : @escaping ServiceCallWithMessage)
    func segmentHashArray(for segmentId : Int)
    func removeDynamic(for segments : [String])
    func updateTrigger(status : Bool , completionHandler : @escaping ServiceCallWithMessage)
    func checkSubscriber(completionHandler : @escaping ServiceCallBack)
    func updateSubsciber(completionHandler : @escaping ServiceCallWithMessage)
}

