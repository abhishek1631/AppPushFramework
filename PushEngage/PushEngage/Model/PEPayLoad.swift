//
//  PEPayLoad.swift
//  PushFramework
//
//  Created by Abhishek on 18/02/21.
//

import Foundation

struct PEPayload: Codable {
    let aps: Aps?
    let attachmentURL: String?
    let deepLinking: String?
    let actionButtons : [Buttons]?

    enum CodingKeys: String, CodingKey {
        case aps
        case attachmentURL = "attachment-url"
        case deepLinking = "deep-linking"
        case actionButtons = "action-buttons"
    }
}

// MARK: - Aps
struct Aps: Codable {
    let alert: Alert?
    let badge: Int?
    let sound: String?
    let category : String?
    let mutableContent, contentAvailable: Int?

    enum CodingKeys: String, CodingKey {
        case alert, badge, sound, category
        case mutableContent = "mutable-content"
        case contentAvailable = "content-available"
        
    }
}

struct Buttons : Codable {
    let id : String
    let text : String?
    let icon : String?
    
    enum CodingKeys: String, CodingKey {
        case id,text,icon
    }
}

// MARK: - Alert
struct Alert : Codable {

    /// A short string describing the purpose of the notification. Apple Watch displays this string as part of the notification interface. This string is displayed only briefly and should be crafted so that it can be understood quickly.
    var title : String?

    /// The text of the alert message.
    var body  : String?

    /// The filename of an image file in the app bundle, with or without the filename extension. The image is used as the launch image when users tap the action button or move the action slider. If this property is not specified, the system either uses the previous snapshot, uses the image identified by the UILaunchImageFile key in the app’s Info.plist file, or falls back to Default.png.
    var launchImage : String?

    /// Variable string values to appear in place of the format specifiers in loc-key. See Localizing the Content of Your Remote Notifications for more information.
    var locArgs : [String]?

    /// The key to a title string in the Localizable.strings file for the current localization. The key string can be formatted with %@ and %n$@ specifiers to take the variables specified in the title-loc-args array.
    var titleLocKey : String?

    /// if a string is specified, the system displays an alert that includes the Close and View buttons. The string is used as a key to get a localized string in the current localization to use for the right button’s title instead of “View”.
    var actionLocKey : String?

    /// Variable string values to appear in place of the format specifiers in title-loc-key.
    var titleLocArgs : [String]?

    private enum CodingKeys : String , CodingKey {
        case title, body
        case launchImage = "launch-image"
        case locArgs = "loc-args"
        case titleLocKey = "title-loc-key"
        case actionLocKey = "action-loc-key"
        case titleLocArgs = "title-loc-args"
    }

}
