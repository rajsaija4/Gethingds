//
//  Notification.swift
//  Zodi
//
//  Created by GT-Ashish on 24/10/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import Foundation
import SwiftyJSON

class AppNotification: NSObject {
    
    var id: Int = 0
    var title: String = ""
    var type: String = ""
    var message: String = ""
    var userId: Int = 0
    var senderId: Int = 0
    var createdAt: String = ""
    var imgUser: String = ""
    
    init(_ json: JSON) {
        super.init()
        
        id = json["id"].intValue
        title = json["title"].stringValue
        type = json["type"].stringValue
        message = json["message"].stringValue
        userId = json["user_id"].intValue
        createdAt = json["created_at"].stringValue
        userId = json["user_id"].intValue
        senderId = json["sender_id"].intValue
        imgUser = json["user_image"].stringValue
        
    }
    
}
