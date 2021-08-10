//
//  Message.swift
//
//  Created by AK on 16/09/20.
//  Copyright © 2020 AK. All rights reserved.
//

import UIKit
import SwiftyJSON
import MessageKit

internal struct Message: MessageType {
    
    var messageId: String
    var sender: SenderType { return user }
    var sentDate: Date
    var kind: MessageKind
    var image: URL?
    var user: ChatUser
    
    static var currentSender: ChatUser {
        return ChatUser(senderId: "\(User.details.id)", displayName: User.details.firstName)
    }
    
//    extension MessageKind {
//        
//        var messageKindString: String {
//            switch self {
//            case .text(_):
//                return "text"
//            case .attributedText(_):
//                return "attributed_text"
//            case .photo(_):
//                return "photo"
//            case .video(_):
//                return "video"
//            case .location(_):
//                return "location"
//            case .emoji(_):
//                return "emoji"
//            case .audio(_):
//                return "audio"
//            case .contact(_):
//                return "contact"
//            case .custom(_):
//                return "customc"
//            case .linkPreview(_):
//                <#code#>
//            }
//        }
//    }

    private init(_ kind: MessageKind, _ user: ChatUser, _ image: URL?, _ messageId: String, _ date: Date) {
        self.kind = kind
        self.user = user
        self.messageId = messageId
        self.image = image
        self.sentDate = date
    }
    
//    init(_ json: JSON) {
//        self.init(.text(json["message"].stringValue), Message.currentSender, URL(string: json["sender_image_url"].stringValue), json["message_id"].stringValue, json["received_date_time"].stringValue.toDate ?? Date())
//    }
    //https://gurutechnolabs.co.in/website/laravel/gethingd/public/api/get_message_conversation
    init(_ json: JSON) {
        self.init(.text(json["message"].stringValue), ChatUser(senderId: "\(json["sender_id"].intValue)", displayName: ""), URL(string: json["sender_user_image"].stringValue), json["message_id"].stringValue, json["created_at"].stringValue.toDate ?? Date())
    }
    
    //https://gurutechnolabs.co.in/website/laravel/gethingd/public/api/send_message
    init(json: JSON) {
        self.init(.text(json["data"]["message"].stringValue), ChatUser(senderId: "\(json["data"]["sender_id"].intValue)", displayName: ""), URL(string: json["data"]["sender_user_image"].stringValue), json["data"]["message_id"].stringValue, json["data"]["created_at"].stringValue.toDate ?? Date())
    }
    
    init(jsonNotification: JSON) {
        self.init(.text(jsonNotification["message"]["message"].stringValue), ChatUser(senderId: "\(jsonNotification["message"]["sender_id"].intValue)", displayName: ""), URL(string: jsonNotification["message"]["sender_user_image"].stringValue), jsonNotification["message"]["message_id"].stringValue, jsonNotification["message"]["created_at"].stringValue.toDate ?? Date())
    }
    
//    init(json: JSON) {
//        self.init(image:UIImage, ChatUser(senderId: "\(json["data"]["sender_id"].intValue)", displayName: ""), URL(string: json["data"]["sender_user_image"].stringValue), json["data"]["message_id"].stringValue, json["data"]["created_at"].stringValue.toDate ?? Date()))
//    }
//    
//    init(_ text: String) {
//
//        self.init(.text(text), ChatUser(senderId: "\(User.details.id)", displayName: User.details.firstName), URL(string: User.details.image1 ?? ""), UUID().uuidString, Date())
//    }
//
//    class UserInfo: NSObject {
//
//        var id: String?
//        var name: String?
//        var email: String?
//        var image: URL?
//
//        init(_ json: JSON) {
//            super.init()
//            id = json["user_id"].stringValue
//            name = json["name"].stringValue
//            email = json["email"].stringValue
//            image = json["image"].url
//        }
//    }
}



extension MessageType {
    
    var avatar: Avatar {
        get {
            let firstName = sender.displayName.components(separatedBy: " ").first
            let lastName = sender.displayName.components(separatedBy: " ").last
            let initials = "\(firstName?.first ?? "A")\(lastName?.first ?? "A")"
            return Avatar(image: nil, initials: initials)
        }
    }
}



    
    private struct ImageMediaItem: MediaItem {

        var url: URL?
        var image: UIImage?
        var placeholderImage: UIImage
        var size: CGSize

        init(image: UIImage) {
            self.image = image
            self.size = CGSize(width: 240, height: 240)
            self.placeholderImage = UIImage()
        }

        init(imageURL: URL) {
            self.url = imageURL
            self.size = CGSize(width: 240, height: 240)
            self.placeholderImage = UIImage(imageLiteralResourceName: "image_message_placeholder")
        }
    }

