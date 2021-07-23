//
//  User.swift
//
//  Created by AK on 16/09/20.
//  Copyright © 2020 AK. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: NSObject, NSCoding {

    var id:Int = 0
    var firstName: String = ""
    var lastName: String = ""
    var dob: String = ""
    var email:String = ""
    var gender: String = ""
    var looking_for:String = ""
    var job_title:String = ""
    var passion:[String] = []
    var address: String = ""
    var about:String = ""
    var num_of_kids:Int = 0
    var email_verified:Int = 0
    var image1:String = ""
    var image2:String = ""
    var image3:String = ""
    var image4:String = ""
    var image5:String = ""
    var image6:String = ""
    var user_kids:[String] = []
    var api_token:String = ""
 
    
    init(_ json: JSON) {
        super.init()
        id = json["data"]["user"]["id"].intValue
        firstName = json["data"]["user"]["first_name"].stringValue
        lastName = json["data"]["user"]["last_name"].stringValue
        dob = json["data"]["user"]["dob"].stringValue
        email = json["data"]["user"]["email"].stringValue
        gender = json["data"]["user"]["gender"].stringValue
        looking_for = json["data"]["user"]["looking_for"].stringValue
        job_title = json["data"]["user"]["job_title"].stringValue
        for pas in json["data"]["user"]["passion"].arrayValue {
            passion.append(pas.stringValue)
        }
        address = json["data"]["user"]["address"].stringValue
        about = json["data"]["user"]["about"].stringValue
        num_of_kids = json["data"]["user"]["num_of_kids"].intValue
        email_verified = json["data"]["email_verified"].intValue
        image1 = json["data"]["user"]["image1"].stringValue
        image2 = json["data"]["user"]["image2"].stringValue
        image3 = json["data"]["user"]["image3"].stringValue
        image4 = json["data"]["user"]["image4"].stringValue
        image5 = json["data"]["user"]["image5"].stringValue
        image6 = json["data"]["user"]["image6"].stringValue
        for kid in json["data"]["user"]["user_kids"].arrayValue {
            user_kids.append(kid["kids_status"].stringValue)
        }
        api_token = json["data"]["user"]["api_token"].stringValue
       

    }
    
    init(json: JSON, token: String) {
        super.init()
        id = json["data"]["user"]["id"].intValue
        firstName = json["data"]["user"]["first_name"].stringValue
        lastName = json["data"]["user"]["last_name"].stringValue
        dob = json["data"]["user"]["dob"].stringValue
        email = json["data"]["user"]["email"].stringValue
        gender = json["data"]["user"]["gender"].stringValue
        looking_for = json["data"]["user"]["looking_for"].stringValue
        job_title = json["data"]["user"]["job_title"].stringValue
        for pas in json["data"]["user"]["passion"].arrayValue {
            passion.append(pas.stringValue)
        }
        address = json["data"]["user"]["address"].stringValue
        about = json["data"]["user"]["about"].stringValue
        num_of_kids = json["data"]["user"]["num_of_kids"].intValue
        email_verified = json["data"]["email_verified"].intValue
        image1 = json["data"]["user"]["image1"].stringValue
        image2 = json["data"]["user"]["image2"].stringValue
        image3 = json["data"]["user"]["image3"].stringValue
        image4 = json["data"]["user"]["image4"].stringValue
        image5 = json["data"]["user"]["image5"].stringValue
        image6 = json["data"]["user"]["image6"].stringValue
        for kid in json["data"]["user"]["user_kids"].arrayValue {
            user_kids.append(kid["kids_status"].stringValue)
        }
        api_token = json["data"]["user"]["api_token"].stringValue
       
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id,forKey: "id")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(dob, forKey: "dob")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(looking_for, forKey: "lookingFor")
        aCoder.encode(job_title, forKey: "jobTitle")
        aCoder.encode(passion, forKey: "passion")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(about, forKey: "about")
        aCoder.encode(num_of_kids, forKey: "noOfkids")
        aCoder.encode(email_verified, forKey: "emailVerify")
        aCoder.encode(image1,forKey: "image1")
        aCoder.encode(image2,forKey: "image2")
        aCoder.encode(image3,forKey: "image3")
        aCoder.encode(image4,forKey: "image4")
        aCoder.encode(image5,forKey: "image5")
        aCoder.encode(image6,forKey: "image6")
        aCoder.encode(user_kids, forKey: "kidsStatus")
        aCoder.encode(api_token, forKey: "token")
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        id = aDecoder.decodeInteger(forKey: "id") 
        firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        dob = aDecoder.decodeObject(forKey: "dob") as! String
        email = aDecoder.decodeObject(forKey: "email") as! String
        gender = aDecoder.decodeObject(forKey: "gender") as! String
        looking_for = aDecoder.decodeObject(forKey: "lookingFor") as! String
        job_title = aDecoder.decodeObject(forKey: "jobTitle") as! String
        passion = aDecoder.decodeObject(forKey: "passion") as! [String]
        address = aDecoder.decodeObject(forKey: "address") as! String
        about = aDecoder.decodeObject(forKey: "about") as! String
        num_of_kids = aDecoder.decodeInteger(forKey: "noOfkids") 
        email_verified = aDecoder.decodeInteger(forKey: "emailVerify") 
      
        image1 = aDecoder.decodeObject(forKey: "image1") as! String
        image2 = aDecoder.decodeObject(forKey: "image2") as! String
        image3 = aDecoder.decodeObject(forKey: "image3") as! String
        image4 = aDecoder.decodeObject(forKey: "image4") as! String
        image5 = aDecoder.decodeObject(forKey: "image5") as! String
        image6 = aDecoder.decodeObject(forKey: "image6") as! String
        user_kids = aDecoder.decodeObject(forKey: "kidsStatus") as! [String]
        api_token = aDecoder.decodeObject(forKey: "token") as! String
       
    }
}


extension User {
        
    static var isExist: Bool {
        let decodedData  = UserDefaults.standard.object(forKey: "saveUserCredentials") as? Data
        return decodedData != nil
    }
    
//    static var token: [String:String] {
//        get {
//            return ["Authorization": "Bearer \(User.details.barearToken)", "X-Requested-With": "XMLHttpRequest"]
//        }
//    }
    
//    static var token: [String:String] {
//        get {
//            return ["Authorization": "Bearer \(User.token)"]
//        }
//    }
    
   
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
