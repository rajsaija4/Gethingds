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
    
    init(_ json: JSON) {
        self.init(.text(json["message"].stringValue), ChatUser(senderId: "\(json["sender_id"].intValue)", displayName: ""), URL(string: json["sender_image_url"].stringValue), json["message_id"].stringValue, json["received_date_time"].stringValue.toDate ?? Date())
    }
    
    init(json: JSON) {
        self.init(.text(json["messages"]["message"].stringValue), ChatUser(senderId: "\(json["messages"]["sender_id"].intValue)", displayName: ""), URL(string: json["messages"]["sender_image_url"].stringValue), json["messages"]["message_id"].stringValue, json["messages"]["received_date_time"].stringValue.toDate ?? Date())
    }
    
    init(_ text: String) {
        
        self.init(.text(text), ChatUser(senderId: "\(User.details.id)", displayName: User.details.firstName), URL(string: User.details.arrImage.first ?? ""), UUID().uuidString, Date())
    }
    
    class UserInfo: NSObject {
        
        var id: String?
        var name: String?
        var email: String?
        var image: URL?
        
        init(_ json: JSON) {
            super.init()
            id = json["user_id"].stringValue
            name = json["name"].stringValue
            email = json["email"].stringValue
            image = json["image"].url
        }
    }
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
