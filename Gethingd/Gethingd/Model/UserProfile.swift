//
//  UserProfile.swift
//  Zodi
//
//  Created by AK on 25/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserProfile: NSObject {
    
    var id: Int = 0
    var firstName: String = ""
    var lastName: String = ""
    var nickName: String = ""
    var email: String = ""
    var about: String = ""
    var address: String = ""
    var dateOfBirth: String = ""
    var age: Int = 0
    var userHeight: String = ""
    var lookingFor: String = ""
    var instagramId: String = ""
    var gender: String = ""
    var sunSignId: String = ""
    var moonSignId: String = ""
    var risingSignId: String = ""
    var arrImage: [String] = []
    var token: String = ""
    var isSuperLike = false
    var isButtonHide = false
    var instaToken: String = ""
    var isActiveAccount: Bool = true

    
    init(_ json: JSON) {
        super.init()
        id = json["user_id"].intValue
        firstName = json["first_name"].stringValue
        lastName = json["last_name"].stringValue
        nickName = json["nick_name"].stringValue
        email = json["email"].stringValue
        age = json["age"].intValue
        token = json["access_token"].stringValue
        about = json["about"].stringValue
        dateOfBirth = json["dob"].stringValue
        lookingFor = json["looking_for"].stringValue
        instagramId = json["instagram_id"].stringValue
        gender = json["gender"].stringValue
        address = json["address"].stringValue
        sunSignId = json["sun_zodiac_sign_id"].stringValue
        moonSignId = json["moon_zodiac_sign_id"].stringValue
        risingSignId = json["rising_zodiac_sign_id"].stringValue
        userHeight = json["height"].stringValue
        for image in json["images"].arrayValue {
            arrImage.append(image.stringValue)
        }
        isSuperLike = json["super_like"].stringValue != "No"
        isButtonHide = json["button_hide"].boolValue
        instaToken = json["insta_access_token"].stringValue
        isActiveAccount = json["status"].stringValue == "Active" ? true : false
    }
}
