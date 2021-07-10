//
//  User.swift
//
//  Created by AK on 16/09/20.
//  Copyright © 2020 AK. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: NSObject, NSCoding {

    var id: Int = 0
    var firstName: String = ""
    var lastName: String = ""
    var nickName: String = ""
    var email: String = ""
    var token: String = ""
    var address: String = ""
    var gender: String = ""
    var height: String = ""
    var sunSignId: String = ""
    var moonSignId: String = ""
    var risingSignId: String = ""
    var about: String = ""
    var dob: String = ""
    var lookingFor: String = ""
    var instagramId: String = ""
    var arrImage: [String] = []
    


    init(_ json: JSON) {
        super.init()
        
        id = json["user_id"].intValue
        firstName = json["first_name"].stringValue
        lastName = json["last_name"].stringValue
        nickName = json["nick_name"].stringValue
        email = json["email"].stringValue
        for image in json["images"].arrayValue {
            arrImage.append(image.stringValue)
        }
        token = json["access_token"].stringValue
        address = json["address"].stringValue
        gender = json["gender"].stringValue
        height = json["height"].stringValue
        sunSignId = json["sun_zodiac_sign_id"].stringValue
        moonSignId = json["moon_zodiac_sign_id"].stringValue
        risingSignId = json["rising_zodiac_sign_id"].stringValue
        about = json["about"].stringValue
        dob = json["dob"].stringValue
        lookingFor = json["looking_for"].stringValue
        instagramId = json["instagram_id"].stringValue
        
    }
    
    init(json: JSON, token: String) {
        super.init()
        id = json["user_id"].intValue
        firstName = json["first_name"].stringValue
        lastName = json["last_name"].stringValue
        nickName = json["nick_name"].stringValue
        email = json["email"].stringValue
        for image in json["images"].arrayValue {
            arrImage.append(image.stringValue)
        }
        self.token = token
        address = json["address"].stringValue
        gender = json["gender"].stringValue
        height = json["height"].stringValue
        sunSignId = json["sun_zodiac_sign_id"].stringValue
        moonSignId = json["moon_zodiac_sign_id"].stringValue
        risingSignId = json["rising_zodiac_sign_id"].stringValue
        about = json["about"].stringValue
        dob = json["dob"].stringValue
        lookingFor = json["looking_for"].stringValue
        instagramId = json["instagram_id"].stringValue
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(nickName, forKey: "nickName")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(height, forKey: "height")
        aCoder.encode(sunSignId, forKey: "sunSignId")
        aCoder.encode(moonSignId, forKey: "moonSignId")
        aCoder.encode(risingSignId, forKey: "risingSignId")
        aCoder.encode(about, forKey: "about")
        aCoder.encode(dob, forKey: "dob")
        aCoder.encode(lookingFor, forKey: "lookingFor")
        aCoder.encode(instagramId, forKey: "instagramId")
        aCoder.encode(arrImage, forKey: "arrImage")
  
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        id = aDecoder.decodeInteger(forKey: "id")
        firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        nickName = aDecoder.decodeObject(forKey: "nickName") as! String
        email = aDecoder.decodeObject(forKey: "email") as! String
        token = aDecoder.decodeObject(forKey: "token") as! String
        address = aDecoder.decodeObject(forKey: "address") as! String
        gender = aDecoder.decodeObject(forKey: "gender") as! String
        height = aDecoder.decodeObject(forKey: "height") as! String
        sunSignId = aDecoder.decodeObject(forKey: "sunSignId") as! String
        moonSignId = aDecoder.decodeObject(forKey: "moonSignId") as! String
        risingSignId = aDecoder.decodeObject(forKey: "risingSignId") as! String
        about = aDecoder.decodeObject(forKey: "about") as! String
        dob = aDecoder.decodeObject(forKey: "dob") as! String
        lookingFor = aDecoder.decodeObject(forKey: "lookingFor") as! String
        instagramId = aDecoder.decodeObject(forKey: "instagramId") as! String
        arrImage = aDecoder.decodeObject(forKey: "arrImage") as! [String]
    }
}


extension User {
        
    static var isExist: Bool {
        let decodedData  = UserDefaults.standard.object(forKey: "saveUserCredentials") as? Data
        return decodedData != nil
    }
    
//    static var token: [String:String] {
//        get {
//            return ["Authorization": "Bearer \(details.token)", "X-Requested-With": "XMLHttpRequest"]
//        }
//    }
    
    static var token: [String:String] {
        get {
            return ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZGIwMzRmOTM5YmEzNTcyYTRmOWVjNzNlOTIzNmRmOWMzZjIzYWI3YjJkNDU1MGY3ODA4YmZhMTNjZDJmMWI1OWY2YzhiMTk1YjgyNjg1M2EiLCJpYXQiOjE2MjU5MjIwMTUsIm5iZiI6MTYyNTkyMjAxNSwiZXhwIjoxNjU3NDU4MDE1LCJzdWIiOiIxNCIsInNjb3BlcyI6W119.sSHjKORRU8OfvnOHV5ub1iF9hFi71XMDLJM0TTnV_-XBocuIMJFRgVqu1mtFU_mJk-xqztOOH1Xp79JzcHj7UTFXOue4PfFs_zJ8-0iMGLDvJWuyQ-IPVKXv1dPOfCrRSen6erO4hgPU6JjJus-u7DLfopCIu9xvJ086BXF_TfIHBD5Ho8SBalX6Pa4NvOHWt3urIXNwR1IfS2ZK0G4Rn37oXXZ2OzHw8By1HtMqOMS-1r1IcJ9AwZuLmPb-91MOyrdVN98GdoXgOP7iyfNi5D6HCpmH-q97nDchK4NhmBaGAUu7wakFSlH1xKotRAkBqOKVZ1c0OTdmzES1eH_nfljNQrJePHXPQCzR8QHOEyd5qGlliqKh8BGxCoVyt1AAqASt8qfi2BNZL8XdHKAqmA2mWekLqDggh5iiOKwNr50JAziJA0rp_cuTkvtLdkHIfmUOuk2ycdf37sBqU999lFFdgaf0nrz55Wn-lGREgh2vxlfsa9M76gQitM3EooXsF2yfQ7LfyENvF7QjzdOlSKAyaI1tRn3sKxH4S1I8TM98aLs1IaoFOw8zoRA5v1OL-UHQ2JjKfTSQqbvtaPRlQSBRwwbzNWT63EjiGQopom-yljKAJNlP4RW-q1c9fywXasbICpavkzWmbAZrPjFJ16Zng8lTt2rlRkjDC9dToe0", "X-Requested-With": "XMLHttpRequest"]
        }
    }
    
   
    static var details: User {
        get {
            let decodedData  = UserDefaults.standard.object(forKey: "saveUserCredentials") as! Data
            let userDetails = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decodedData) as! User
            return userDetails
        }
    }
}



extension User {
    
    func save() {
        let encodedData = try! NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
        UserDefaults.standard.set(encodedData, forKey: "saveUserCredentials")
        UserDefaults.standard.synchronize()
    }
    
    func delete() {
        UserDefaults.standard.removeObject(forKey: "saveUserCredentials")
        UserDefaults.standard.synchronize()
    }
}
