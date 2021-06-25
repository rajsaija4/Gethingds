//
//  URLManager.swift
//
//  Created by Ashish on 20/08/20.
//  Copyright © 2020 Ashish. All rights reserved.
//

import Foundation



struct URLManager {
    
//    static let basePath = "https://gurutechnolabs.co.in/website/laravel/zodi/public/api/"
//    static let basePath = "https://www.zodiap.org/public/api/"
    
    // Developement Path - current live
    //static let mainBasePath = "https://www.zodiap.org/development/public/"
    
    // Live Path
    //static let mainBasePath = "https://www.zodiap.org/public/"
    
    static let mainBasePath = "https://www.zodiap.org/development/public/"
    static let basePath = "\(mainBasePath)api/"

    
    
    struct Auth {
        static let userSignUp = basePath + "user_signup"
        static let login = basePath + "login?"
        static let verify = basePath + "user_verification"
        static let forgotPassword = basePath + "forget_password"
        static let changePassword = basePath + "change_password"
        static let resendOTP = basePath + "resend_otp"
        static let emailVerification = basePath + "email_verification"
        
    }
    
    struct Profile {
        static let addProfile = basePath + "update_profile"
        static let addInstagramToken = basePath + "add_instagram_token"
        static let getUserProfile = basePath + "use_profile_view?"
        static let getMyProfile = basePath + "get_profile"
        static let getHeight = basePath + "get_height"
        static let getOtherUserProfile = basePath + "get_user_profile"
        static let logoutProfile = basePath + "logout"
        static let deleteUser = basePath + "delete_user"
        static let pauseAccount = basePath + "pause_account"
    }
    
    struct Discover {
        static let discover = basePath + "discover"
        static let swipe = basePath + "swipe_profiles?"
        static let boostUser = basePath + "add_user_boost"
    }
    
    struct Chat {
        static let matchDetails = basePath + "match_details"
        static let messageConversation = basePath + "message_conversation"
        static let sendMessage = basePath + "send_message"
    }
    
    struct Report {
        static let reasons = basePath + "unmatch_details"
        static let actionAccount = basePath + "unmatch_account"
    }
    
    struct AllNotification {
        static let notification = basePath + "notification_history"
    }
    
    struct GalaxyPass {
        static let insertLocation = basePath + "insertlocation"
        static let getLocation = basePath + "getLocation"
        static let defaultLocaion = basePath + "defaultLocation"
        static let deleteLocation = basePath + "deleteLocation"
    }
    
    struct Payment {
        static let makePayment = basePath + "after_payment"
        static let getPlans = basePath + "super_gold_slider"
    }
    

}