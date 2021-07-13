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
    var user_images:[String] = []
    var user_kids:[String] = []
    var api_token:String = ""
    
    init(_ json: JSON) {
        super.init()
        id = json["data"]["id"].intValue
        firstName = json["data"]["first_name"].stringValue
        lastName = json["data"]["last_name"].stringValue
        dob = json["data"]["dob"].stringValue
        email = json["data"]["email"].stringValue
        gender = json["data"]["gender"].stringValue
        looking_for = json["data"]["looking_for"].stringValue
        job_title = json["data"]["job_title"].stringValue
        for pas in json["data"]["passion"].arrayValue {
            passion.append(pas.stringValue)
        }
        address = json["data"]["address"].stringValue
        about = json["data"]["about"].stringValue
        num_of_kids = json["data"]["num_of_kids"].intValue
        email_verified = json["data"]["email_verified"].intValue
        for image in json["data"]["user_images"].arrayValue {
            user_images.append(image.stringValue)
        }
        for kid in json["data"]["user_kids"].arrayValue {
            user_kids.append(kid["kids_status"].stringValue)
        }
        api_token = json["data"]["api_token"].stringValue

    }
    
    init(json: JSON, token: String) {
        super.init()
        id = json["data"]["id"].intValue
        firstName = json["data"]["first_name"].stringValue
        lastName = json["data"]["last_name"].stringValue
        dob = json["data"]["dob"].stringValue
        email = json["data"]["email"].stringValue
        gender = json["data"]["gender"].stringValue
        looking_for = json["data"]["looking_for"].stringValue
        job_title = json["data"]["job_title"].stringValue
        for pas in json["data"]["passion"].arrayValue {
            passion.append(pas.stringValue)
        }
        address = json["data"]["address"].stringValue
        about = json["data"]["about"].stringValue
        num_of_kids = json["data"]["num_of_kids"].intValue
        email_verified = json["data"]["email_verified"].intValue
        for image in json["data"]["user_images"].arrayValue {
            user_images.append(image.stringValue)
        }
        for kid in json["data"]["user_kids"].arrayValue {
            user_kids.append(kid["kids_status"].stringValue)
        }
        api_token = json["data"]["api_token"].stringValue
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
        aCoder.encode(user_images, forKey: "images")
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
      
        user_images = aDecoder.decodeObject(forKey: "images") as! [String]
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
//            return ["Authorization": "Bearer \(details.token)", "X-Requested-With": "XMLHttpRequest"]
//        }
//    }
    
    static var token: [String:String] {
        get {
            return ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMzc1ZWI3MGM1NGY1NjUwMGNkZDc1ZWI5YTBjOTgxNTA4OWY2Nzk5NmE4YjJlZTEzOGFkZDQ1MDIyOWI0ZDkzODA1YWRjNWE5YWMxOWYzNmQiLCJpYXQiOjE2MjYwODI3MjQsIm5iZiI6MTYyNjA4MjcyNCwiZXhwIjoxNjU3NjE4NzI0LCJzdWIiOiIxNCIsInNjb3BlcyI6W119.z2QhYhtT2dQnrSzOZ6uHCpKuY5ATJzxazfyPQz_KBIT3EySSaF_K0BaaylJ6vl4nSqp32oqXozp2BcMryeAw2D4oOBjZiBta0T5v8uXBBiHRo3SMMmgmVmEBmRFJzeAbj7qHd01pb_It7DioG1qwUV_h_zQq97iY3V9JjE5PhOg_9O9VnaWvCGINz13JnzeLtE9X_ua_WGikirLbbYfadhSuFNcyZY3Wk87wAuJ8HTVhO2RR_E82UrPU6ivuFg4rxuDxxem8L9lbCn6E6PKQSjEuPRQCIcLooViSvdaR9W_5a3EC7I7eetwaiEbWDlZ0ejkuVcuS0AbVvtFTYMcd5ZB_hDgFaJhnNRTNylDsxOWFROqqVlwZWJ_tiPIMAVaJ0_dyvX5TROR1HcNMZV-f95d0BKNU3DIDjGNCjYgG6ZUInlpx5On41bg1aZvu6VIjxDw1xipbRLDTqvJeadOlloKyE24mpK9PzTsf-3CDhS7jgQ90iNesjca5zHdU-hqU3m3ivuV8m2sBPS2VFspeGipc6DxOofid48RUSY-Qc631PoFnufxT60o6wkDgrEkaHAbd98WsiyXJbMwthUBEWENegAwZBxNc4R7HA-YP8_61WDT_J5X8VFiDZ5kLMTJi7vTHoqPsojaPep4Z1WfHQjiFKd3ew5KqCPyWgtDkHb0"]
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
