//
//  NetworkManager.swift
//
//  Created by Ashish on 20/08/20.
//  Copyright © 2020 Ashish. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NetworkManager {
    
    static var header: HTTPHeaders? {
        guard User.isExist else {
            return nil
        }
        return HTTPHeaders(["Authorization": "Bearer \(UserDefaults.standard.string(forKey: "btoken") ?? "")"])
    }
}

extension NetworkManager {
    
    struct Auth {
        
        static func signUp(param: Parameters, _ success: @escaping (String) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.postRequest(url: URLManager.Auth.userSignUp, params: param, headers: header, { (response) in
                
                guard response.isSuccess, let otp = response["otp"].string else {
                    fail(response.message)
                    return
                }
                
                success(otp)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func login(param: Parameters, _ success: @escaping (String) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.postRequest(url: URLManager.Auth.login, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    for param in param {
                        if response["message"][param.key].arrayValue.count > 0 {
                            let error = response["message"][param.key].arrayValue.map{ $0.stringValue }.joined(separator: "\n")
                            fail(error)
                            return
                        }
                        
                    }
                    fail(response.message)
                    return
                }
                success(response["otp"].stringValue)
     
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func socialLogin(param: Parameters, _ success: @escaping (String) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.postRequest(url: URLManager.Auth.socialLogin, params: param, headers: header, { (response) in
                guard response.isSuccess else {
                    for param in param {
                        if response["message"][param.key].arrayValue.count > 0 {
                            let error = response["message"][param.key].arrayValue.map{ $0.stringValue }.joined(separator: "\n")
                            fail(error)
                            return
                        }
                        
                    }
                    fail(response.message)
                    return
                }
                let user = User(response)
                let barearToken = response["data"]["token"].stringValue
                UserDefaults.standard.set(barearToken, forKey: "btoken")
                user.save()
                success(response["message"].stringValue)

     
            }) { (error) in
                fail(error.localizedDescription)
            }
        }

        
        static func SignIn(param: Parameters, _ success: @escaping (String) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.postRequest(url: URLManager.Auth.loginUser, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    for param in param {
                        if response["message"][param.key].arrayValue.count > 0 {
                            let error = response["message"][param.key].arrayValue.map{ $0.stringValue }.joined(separator: "\n")
                            fail(error)
                            return
                        }
                        
                    }
                    fail(response.message)
                    return
                }
                let user = User(response)
                let barearToken = response["data"]["token"].stringValue
                UserDefaults.standard.set(barearToken, forKey: "btoken")
                user.save()
                success(response["message"].stringValue)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func verifyLogin(param: Parameters, _ success: @escaping (String) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.postRequest(url: URLManager.Auth.verify, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    for param in param {
                        if response["message"][param.key].arrayValue.count > 0 {
                            let error = response["message"][param.key].arrayValue.map{ $0.stringValue }.joined(separator: "\n")
                            fail(error)
                            return
                        }
                        
                    }
                    fail(response.message)
                    return
                }
                let user = User(response)
                let barearToken = response["data"]["token"].stringValue
                UserDefaults.standard.set(barearToken, forKey: "btoken")
                user.save()
                success(response["is_show_popup"].stringValue)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func verifyEmail(param: Parameters, _ success: @escaping (String) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.postRequest(url: URLManager.Auth.emailVerification, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
//                let user = User(response)
//                user.save()
                success(response["data"]["key"].stringValue)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func resendOTP(param: Parameters, _ success: @escaping (String) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.postRequest(url: URLManager.Auth.resendOTP, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                success(response["message"].stringValue)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        
        static func forgotPassword(param: Parameters, _ success: @escaping (String) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.postRequest(url: URLManager.Auth.forgotPassword, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                success(response.message)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func changePassword(param: Parameters, _ success: @escaping (String) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.postRequest(url: URLManager.Auth.changePassword, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                success(response.message)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func updateNewpassword(param: Parameters, _ success: @escaping (String) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.postRequest(url: URLManager.Auth.updatepassword, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                success(response["message"].stringValue)
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
    }
}



extension NetworkManager {
    
    struct Profile {
        
        static func addProfile(source: [String: Data], params: [String: String], _ success: @escaping (String) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.uploadRequest(URLManager.Profile.addProfile, source: source, params: params, headers: header, { (response) in
                
                
                
                guard response.isSuccess else {
                    
                    if response["status"].stringValue == "2" {
                        let user = User(json: response)
                        user.save()
                        fail("2")
                        return
                    }
                    
                    
                    for param in params {
                        if response["message"][param.key].arrayValue.count > 0 {
                            let error = response["message"][param.key].arrayValue.map{ $0.stringValue }.joined(separator: "\n")
                            fail(error)
                            return
                        }
                        
                    }
                    fail(response.message)
                    return
                }
                AppSupport.reviewLater = response["data"]["remaining_review_later_count"].intValue
                AppSupport.remainingLikes = response["data"]["remaining_likes_count"].intValue
                AppSupport.isLikeLimited = response["data"]["is_limited"].stringValue
//                let user = User(json: response, token: User.details.api_token)
                let user = User(json:response)
                user.save()
                success(response.message)
                
            }) { (error) in
                print(error.localizedDescription)
                fail(error.localizedDescription)
            }
        }
        
        static func getMyProfile(_ success: @escaping (User) -> Void, _ fail: @escaping (String) -> Void) {
            

            NetworkCaller.getRequest(url: URLManager.Profile.getMyProfile, params: nil, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                let user = User(json: response)
                user.save()
                success(user)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func getUserProfile(param: Parameters, _ success: @escaping (Bool) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.getRequest(url: URLManager.Auth.login, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                let user = User(response)
                user.save()
                success(true)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func getHeight(_ success: @escaping ([Double]) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.getRequest(url: URLManager.Profile.getHeight, params: nil, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                success(response["height"].arrayValue.map{ $0.doubleValue })
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func getUserDetails(param: Parameters, _ success: @escaping (UserProfile) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.postRequest(url: URLManager.Profile.getUserDetails, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                success(UserProfile(json:response))
                print(response)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func getOtherUserProfile(param: Parameters, _ success: @escaping (UserProfile) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.postRequest(url: URLManager.Profile.getOtherUserProfile, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                success(UserProfile(response))
                print(response)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func getReviewLaterProfiles( _ success: @escaping ([UserProfile]) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.getRequest(url: URLManager.Discover.reviewLater, params: nil, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                var arrUser: [UserProfile] = []
                for user in response["data"].arrayValue {
                    arrUser.append(UserProfile(user))
                }
                print(response)
                success(arrUser)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        
        static func logoutProfile(_ success: @escaping (String) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.getRequest(url: URLManager.Profile.logoutProfile, params: nil, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                success(response.message)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func deleteProfile(_ success: @escaping (String) -> Void, _ fail: @escaping (String) -> Void) {
            
            let param = ["token": User.details.api_token]
            NetworkCaller.getRequest(url: URLManager.Profile.deleteUser, params: param, headers: nil, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                success(response.message)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func pauseProfile(_ success: @escaping (String) -> Void, _ fail: @escaping (String) -> Void) {
            
            let param = ["status": 1]
            NetworkCaller.postRequest(url: URLManager.Profile.pauseAccount, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                success(response.message)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func resumeProfile(_ success: @escaping (String) -> Void, _ fail: @escaping (String) -> Void) {
            
            let param = ["status": 0]
            NetworkCaller.postRequest(url: URLManager.Profile.pauseAccount, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                success(response.message)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func addInstagramAccount(param: Parameters, _ success: @escaping (Bool) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.postRequest(url: URLManager.Profile.addInstagramToken, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                //                let user = User(response)
                //                user.save()
                success(true)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
    }
    
}



extension NetworkManager {
    
    struct Discover {
        
        static func discoverUser(param: Parameters? = nil, _ success: @escaping ([UserProfile]) -> Void, _ fail: @escaping (String) -> Void, _ version: @escaping(String) -> Void, _ unreadmsg:@escaping (Int) -> Void) {
            
            NetworkCaller.postRequest(url: URLManager.Discover.discover, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                Filter.distance = Int(response["data"]["params"]["distance"].intValue)
                Filter.minAge = Int(response["data"]["params"]["min_age"].intValue)
                Filter.maxAge = Int(response["data"]["params"]["max_age"].intValue)
                Filter.minKid = Int(response["data"]["params"]["min_kids"].intValue)
                Filter.maxKid = Int(response["data"]["params"]["max_kids"].intValue)
//                Filter.longitude = String(response["data"]["longitude"].stringValue)
//                Filter.latitude = String(response["data"]["latitude"].stringValue)
                Filter.lookingFor = String(response["data"]["params"]["looking_for"].stringValue)
                
//                Filter.minHeight = Int(response["params"]["min_height"].stringValue) ?? 0
//                Filter.maxHeight = Int(response["params"]["max_height"].stringValue) ?? 0
//                
//                Filter.sunSignId = Int(response["params"]["sun_zodiac_sign_id"].stringValue) ?? 0
//                Filter.moonSignId = Int(response["params"]["moon_zodiac_sign_id"].stringValue) ?? 0
//                Filter.risingSignId = Int(response["params"]["rising_zodiac_sign_id"].stringValue) ?? 0

 
                AppSupport.reviewLater = response["data"]["remaining_review_later_count"].intValue
                AppSupport.remainingLikes = response["data"]["remaining_likes_count"].intValue
                AppSupport.isLikeLimited = response["data"]["is_limited"].stringValue
                AppSupport.isOrder = response["data"]["is_order"].stringValue
//                AppSupport.remainingSuperLikes = response["remaining_slikes_count"].intValue
//                AppSupport.remainingBoost = response["remaining_boost_count"].intValue
//
//                AppSupport.version = response["ios_version"].doubleValue
//
//                SuperLike.superLikeCount = response["super_like_plan"]["count"].intValue
//                SuperLike.price = response["super_like_plan"]["price"].doubleValue

                
                isPurchase = response["data"]["is_order"].stringValue != "No"
                
                
                var arrUser: [UserProfile] = []
                for user in response["data"]["users"].arrayValue {
                    arrUser.append(UserProfile(user))
                }
                print(response)
                success(arrUser)
                
                let versionName = response["data"]["ios_version"].stringValue
                version(versionName)
                
                let unreadMessage = response["data"]["unread_count"].intValue
                unreadmsg(unreadMessage)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func swipeProfiles(param: Parameters, _ success: @escaping (MatchDetails?) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.postRequest(url: URLManager.Discover.swipe, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                print(response)
                
                AppSupport.remainingLikes = response["data"]["remaining_likes_count"].intValue
                AppSupport.isLikeLimited = response["data"]["is_limited"].stringValue
                AppSupport.isOrder = response["data"]["is_order"].stringValue
                AppSupport.reviewLater = response["data"]["remaining_review_later_count"].intValue
                
                if response["data"]["match_status"].stringValue == "match" {
                    success(MatchDetails(response))
                } else {
                    success(nil)
                }

//                success(response["message"].stringValue)
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
//        static func boostProfile(_ success: @escaping (String) -> Void, _ fail: @escaping (String) -> Void) {
//
//            NetworkCaller.getRequest(url: URLManager.Discover.boostUser, params: nil, headers: header, { (response) in
//
//                guard response.isSuccess else {
//                    fail(response.message)
//                    return
//                }
//
//                AppSupport.remainingBoost = response["remaining_boost_count"].intValue
//
//                success(response.message)
//
//            }) { (error) in
//                fail(error.localizedDescription)
//            }
//        }
        
    }
}



extension NetworkManager {
    
    struct Chat {
        
        static func getMatchDetails(_ success: @escaping (MatchesConversation) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.getRequest(url: URLManager.Chat.matchDetails, params: nil, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                success(MatchesConversation(json: response))
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func getMessageConversation(param: Parameters, _ success: @escaping ([Message]) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.postRequest(url: URLManager.Chat.messageConversation, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                var arrMessage: [Message] = []
                
                for message in response["data"].arrayValue {
                    arrMessage.append(Message(message))
                }
                
                success(arrMessage)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func sendMessageConversation(param: Parameters, _ success: @escaping (Message) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.postRequest(url: URLManager.Chat.sendMessage, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                success(Message(json: response))
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
     static func getAllMessageConversation( _ success: @escaping ([ChatMessages]) -> Void, _ fail: @escaping (String) -> Void) {
        
        NetworkCaller.getRequest(url: URLManager.Chat.allmessageConversation, params: nil, headers: header, { (response) in
            
            guard response.isSuccess else {
                fail(response.message)
                return
            }
            
            var arrMessage: [ChatMessages] = []
            
            for message in response["data"].arrayValue {
                arrMessage.append(ChatMessages(json: message))
            }
            
            success(arrMessage)
            
        }) { (error) in
            fail(error.localizedDescription)
        }
     }
        
        static func getWhoLikedMe( _ success: @escaping ([UserProfile]) -> Void, _ fail: @escaping (String) -> Void) {
           
           NetworkCaller.getRequest(url: URLManager.Chat.whoLikedMe, params: nil, headers: header, { (response) in
               
               guard response.isSuccess else {
                   fail(response.message)
                   return
               }
               
               var arrData: [UserProfile] = []
               
               for data in response["data"].arrayValue {
                   arrData.append(UserProfile(data))
               }
               
               success(arrData)
               
           }) { (error) in
               fail(error.localizedDescription)
           }
        }
        
  
    
    
    
 static func checkUserStatus(param: Parameters, _ success: @escaping (String) -> Void, _ fail: @escaping (String) -> Void) {
    
    NetworkCaller.postRequest(url: URLManager.Chat.userStatus, params: param, headers: header, { (response) in
        
        guard response.isSuccess else {
            fail(response.message)
            return
        }
         success(response["message"].stringValue)
        
    }) { (error) in
        fail(error.localizedDescription)
    }
 }
    
}
}



extension NetworkManager {
    
    struct Report {
        
        static func getReasons(param: Parameters, _ success: @escaping ([ReportReason]) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.postRequest(url: URLManager.Report.reasons, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                var arrReportReason: [ReportReason] = []
                
                for reason in response["data"].arrayValue {
                    arrReportReason.append(ReportReason(reason))
                }
                
                success(arrReportReason)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
      
        static func actionAccount(param: Parameters,_ success: @escaping (String) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.postRequest(url: URLManager.Report.actionAccount, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                success(response.message)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
    }
}



extension NetworkManager {
    
    struct NotificationData {
        
        static func getNotification(_ success: @escaping ([AppNotification]) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.getRequest(url: URLManager.AllNotification.notification, params: nil, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                var arrNotification: [AppNotification] = []
                
                for notification in response["data"].arrayValue {
                    arrNotification.append(AppNotification(notification))
                }
                
                success(arrNotification)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
    }
}



extension NetworkManager {
    
    struct Location {
        
        static func insertLocation(param: Parameters, _ success: @escaping ([PassLocation]) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.getRequest(url: URLManager.GalaxyPass.insertLocation, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                var arrLocation: [PassLocation] = []
                
                for location in response["data"].arrayValue {
                    arrLocation.append(PassLocation(location))
                }
                
                success(arrLocation)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func getLocation(_ success: @escaping ([PassLocation]) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.getRequest(url: URLManager.GalaxyPass.getLocation, params: nil, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                var arrLocation: [PassLocation] = []
                
                for location in response["data"].arrayValue {
                    arrLocation.append(PassLocation(location))
                }
                
                success(arrLocation)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func setDefaultLocation(param: Parameters, _ success: @escaping ([PassLocation]) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.getRequest(url: URLManager.GalaxyPass.defaultLocaion, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                var arrLocation: [PassLocation] = []
                
                for location in response["data"].arrayValue {
                    arrLocation.append(PassLocation(location))
                }
                
                success(arrLocation)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func deleteLocation(param: Parameters, _ success: @escaping ([PassLocation]) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.getRequest(url: URLManager.GalaxyPass.deleteLocation, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                var arrLocation: [PassLocation] = []
                
                for location in response["data"].arrayValue {
                    arrLocation.append(PassLocation(location))
                }
                
                success(arrLocation)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
    }
}



extension NetworkManager {
    
    struct Subscription {
        
        static func makePayment(param: Parameters, _ success: @escaping (String) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.getRequest(url: URLManager.Payment.makePayment, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
//                AppSupport.remainingLikes = response["remaining_likes_count"].intValue
//                AppSupport.isLikeLimited = response["is_limited"].stringValue         AppSupport.isOrder = response["is_order"].stringValue
//                AppSupport.reviewLater = response["remaining_review_later_count"].intValue
                
             
                
                success(response.message)
                

            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func getSubscriptionPlans(_ success: @escaping ((freePlan: SubscriptionPlan, premiumPlan: SubscriptionPlan)) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.getRequest(url: URLManager.Payment.getPlans, params: nil, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
        
                success((SubscriptionPlan(fjson: response), SubscriptionPlan(pjson: response)))
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
    }
}


extension NetworkManager {
    
    struct Setting {
        
        static func getUserSetting(_ success: @escaping (JSON) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.getRequest(url: URLManager.Setting.getUserSetting, params: nil, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
        
               success(response)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        static func updateUserSetting(param:Parameters, _ success: @escaping (String) -> Void, _ fail: @escaping (String) -> Void) {
            
            NetworkCaller.postRequest(url: URLManager.Setting.updateUserSetting, params: param, headers: header, { (response) in
                
                guard response.isSuccess else {
                    fail(response.message)
                    return
                }
                
                let message = response["message"].stringValue
               success(message)
                
            }) { (error) in
                fail(error.localizedDescription)
            }
        }
        
        
    }
    
    
    
}


extension NetworkManager {
    
    
    static func getPassion(_ success: @escaping (PassionSetting) -> Void, _ fail: @escaping (String) -> Void) {
        
        NetworkCaller.getRequest(url: URLManager.Setting.passion, params: nil, headers: header, { (response) in
            
            guard response.isSuccess else {
                fail(response.message)
                return
            }
            
            let passion = PassionSetting(json: response)
           success(passion)
            
        }) { (error) in
            fail(error.localizedDescription)
        }
    }
    
    
}
