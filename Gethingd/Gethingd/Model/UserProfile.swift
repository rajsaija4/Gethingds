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
//    var nickName: String = ""
    var email: String = ""
    var about: String = ""
    var address: String = ""
    var dateOfBirth: String = ""
    var age: Int = 0
//    var userHeight: String = ""
    var lookingFor: String = ""
//    var instagramId: String = ""
    var gender: String = ""
//    var sunSignId: String = ""
//    var moonSignId: String = ""
//    var risingSignId: String = ""
    var noOfkids: Int = 0
    var distance:Int = 0
    var image1:String = ""
    var image2:String = ""
    var image3:String = ""
    var image4:String = ""
    var image5:String = ""
    var image6:String = ""
    var userKids: [String] = []
    var token: String = ""
    var status:String = ""
    var userSetting:UserSetting!
    var passion:[String] = []
    var jobTitle:String = ""
    
    
  

    
    init(_ json: JSON) {
        super.init()
        id = json["id"].intValue
        firstName = json["first_name"].stringValue
        lastName = json["last_name"].stringValue
//        nickName = json["nick_name"].stringValue
        email = json["email"].stringValue
        age = json["age"].intValue
        token = json["api_token"].stringValue
        about = json["about"].stringValue
        dateOfBirth = json["dob"].stringValue
        lookingFor = json["looking_for"].stringValue
//        instagramId = json["instagram_id"].stringValue
        gender = json["gender"].stringValue
        address = json["address"].stringValue
//        sunSignId = json["sun_zodiac_sign_id"].stringValue
//        moonSignId = json["moon_zodiac_sign_id"].stringValue
//        risingSignId = json["rising_zodiac_sign_id"].stringValue
//        userHeight = json["height"].stringValue
        distance = json["distance"].intValue
        noOfkids = json["num_of_kids"].intValue
        image1 = json["image1"].stringValue
        image2 = json["image2"].stringValue
        image3 = json["image3"].stringValue
        image4 = json["image4"].stringValue
        status = json["status"].stringValue
        image5 = json["image5"].stringValue
        image6 = json["image6"].stringValue
        jobTitle = json["job_title"].stringValue
        
        for kid in json["user_kids"].arrayValue {
            userKids.append(kid["kids_status"].stringValue)
        }
        
        userSetting = UserSetting(json: json)
        for pas in json["passion"].arrayValue{
            passion.append(pas.stringValue)
        }
       
//        isSuperLike = json["super_like"].stringValue != "No"
//        isButtonHide = json["button_hide"].boolValue
//        instaToken = json["insta_access_token"].stringValue
//        isActiveAccount = json["status"].stringValue == "Active" ? true : false
    }
}

class UserSetting: NSObject {
    
    var showmyAge:Int = 0
    var distanceVisible:Int = 0
    
    init(json:JSON){
        super.init()
        
        showmyAge =  json["user_settings"]["show_my_age"].intValue
        distanceVisible = json["user_settings"]["distance_visible"].intValue
    }
    
}
