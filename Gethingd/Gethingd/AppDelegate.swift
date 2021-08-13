//
//  AppDelegate.swift
//  Gethingd
//
//  Created by Ashish on 10/06/21.
//

import UIKit
import IQKeyboardManagerSwift
import GooglePlaces
import Firebase
import UserNotifications
import GoogleSignIn
import FBSDKCoreKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
  

    var window: UIWindow?
//     var applicationBadgeno = 0

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 1
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        GIDSignIn.sharedInstance().clientID = "351382606491-ihlgmj4uva73q31lve5nflkmbsge658j.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self

//        setupCreateProfileVC()
//        setupLogin()
        setupAppDelegate()
//        getPassion() 
//        setupMainTabBarController()
//        return true
//        editProfile()
//        return true
        
        if User.isExist {
            if User.details.firstName.count > 0  {
                setupMainTabBarController()
            } else {
                print(User.details.firstName)
                setupCreateProfileVC()
//                editProfile()
            }
        } else {
          
            setupLogin()
            
            
        }
        
        return true
    }
    
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {

        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )

    }

}

extension AppDelegate {
    
    fileprivate func setupAppDelegate() {
        
        FirebaseApp.configure()
        registerNotification()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [MessageVC.self]
        IQKeyboardManager.shared.disabledToolbarClasses = [MessageVC.self]
        IQKeyboardManager.shared.disabledTouchResignedClasses = [MessageVC.self]
        GMSPlacesClient.provideAPIKey(GooglePlaceAPIKey)
        IAPManager.setup()
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .white
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func setupLogin() {
        let vc = LoginVC.instantiate(fromAppStoryboard: .Login)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.isNavigationBarHidden = true
        window?.rootViewController = nvc
        window?.makeKeyAndVisible()
    }
    
    
    func editProfile() {
        let vc = DiscoverVC.instantiate(fromAppStoryboard: .Discover)
            let nvc = UINavigationController(rootViewController: vc)
            nvc.isNavigationBarHidden = true
            window?.rootViewController = nvc
            window?.makeKeyAndVisible()
        }

        
   
    
    func setupCreateProfileVC() {
        let vc = CreateProfileTVC.instantiate(fromAppStoryboard: .Profile)
        vc.isFromLogin = true
        let nvc = UINavigationController(rootViewController: vc)
        nvc.isNavigationBarHidden = true
        window?.rootViewController = nvc
        window?.makeKeyAndVisible()
    }
    
    func setupMainTabBarController() {
        
        let tabBarVC = MainTabBarController.instantiate(fromAppStoryboard: .Main)
        
        let profileVC = ProfileTVC.instantiate(fromAppStoryboard: .Profile)
        profileVC.tabBarItem = UITabBarItem(title: "PROFILE", image: UIImage(named: "user"), selectedImage: UIImage(named: "user"))
        let profileNVC = UINavigationController(rootViewController: profileVC)
        
        let discoverVC = DiscoverVC.instantiate(fromAppStoryboard: .Discover)
        discoverVC.tabBarItem = UITabBarItem(title: "DISCOVER", image: UIImage(named: "Dashboard"), selectedImage: UIImage(named: "Dashboard"))
        let discoverNVC = UINavigationController(rootViewController: discoverVC)
        discoverNVC.isNavigationBarHidden = true
        
        let reviewLaterVC = ReviewLaterVC.instantiate(fromAppStoryboard: .ReviewLater)
        reviewLaterVC.tabBarItem = UITabBarItem(title: "REVIEW LATER", image: UIImage(named: "star-1"), selectedImage: UIImage(named: "star-1"))
        let reviewLaterNVC = UINavigationController(rootViewController: reviewLaterVC)
        reviewLaterNVC.isNavigationBarHidden = true
        
        let chatVC = MainchatVC.instantiate(fromAppStoryboard: .Chat)
        chatVC.tabBarItem = UITabBarItem(title: "CHAT", image: UIImage(named: "chat"), selectedImage: UIImage(named: "chat"))
        let chatNVC = UINavigationController(rootViewController: chatVC)
        
        
        tabBarVC.viewControllers = [profileNVC, discoverNVC, reviewLaterNVC, chatNVC]
        tabBarVC.selectedIndex = 1
        
        let tabBarNVC = UINavigationController(rootViewController: tabBarVC)
        tabBarNVC.isNavigationBarHidden = true
        
        window?.rootViewController = tabBarNVC
        window?.makeKeyAndVisible()
        
    }
    
}


extension AppDelegate {
    
    fileprivate func registerNotification() {
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
          
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    
        
    }
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print(fcmToken)
        AppUserDefaults.save(value: fcmToken ?? "", forKey: .fcmToken)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        print(response)
        guard let jsonString = response.notification.request.content.userInfo["custom"] as? String,  let json = jsonString.jsonObject else {
            completionHandler()
            return
        }
        
       
        
       
        
        if json["message"].dictionaryObject != nil {
            let vc = MessageVC.instantiate(fromAppStoryboard: .Chat)
            let conversation = ChatMessages(json)
            vc.conversation = conversation
            vc.userImage = conversation.userImage
            vc.match_Id = conversation.matchId
            vc.selectedUserId = conversation.userId
            vc.oppositeUserName = conversation.userName
            vc.isFromNotification = true
            let nvc = UINavigationController(rootViewController: vc)
            nvc.isNavigationBarHidden = true
            window?.rootViewController = nvc
            window?.makeKeyAndVisible()
            completionHandler()
            return
        }
        
        if json["match"].dictionaryObject != nil {
            let vc = MainchatVC.instantiate(fromAppStoryboard: .Chat)
            vc.isFromPushnotifications = true
            vc.selectedIndex = 1
            let nvc = UINavigationController(rootViewController: vc)
            nvc.isNavigationBarHidden = true
            window?.rootViewController = nvc
            window?.makeKeyAndVisible()
            
            

            
           
            
//            let vc  = MainchatVC.instantiate(fromAppStoryboard: .Chat)
//            let nvc = UINavigationController(rootViewController: vc)
//            nvc.isNavigationBarHidden = true
//            window?.rootViewController = nvc
//            window?.makeKeyAndVisible()
            completionHandler()
            return
        }
        
        if json["like"].dictionaryObject != nil {
            
            let vc = MainchatVC.instantiate(fromAppStoryboard: .Chat)
            vc.isFromPushnotifications = true
            vc.selectedIndex = 2
            let nvc = UINavigationController(rootViewController: vc)
            nvc.isNavigationBarHidden = true
            window?.rootViewController = nvc
            window?.makeKeyAndVisible()
             completionHandler()

        }
        
        if json["custom"].dictionaryObject != nil {
            let vc = NotificationVC.instantiate(fromAppStoryboard: .Notification)
            vc.isFromNotification = true
            let nvc = UINavigationController(rootViewController: vc)
            window?.rootViewController = nvc
            window?.makeKeyAndVisible()
            completionHandler()
          
            
            
        }
        
        /*
        if json["astro_like"].dictionaryObject != nil {
            
            let vc = UserDetailsTVC.instantiate(fromAppStoryboard: .Discover)
            vc.isFromNotification = true
            vc.userId = json["astro_like"]["user_id"].intValue
            let nvc = UINavigationController(rootViewController: vc)
            window?.rootViewController = nvc
            window?.makeKeyAndVisible()
            completionHandler()
            return
        }
        
        if json["premium"].dictionaryObject != nil {
            let vc = UpgradeVC.instantiate(fromAppStoryboard: .Upgrade)
            vc.isFromNotification = true
            let nvc = UINavigationController(rootViewController: vc)
            window?.rootViewController = nvc
            window?.makeKeyAndVisible()
            completionHandler()
            return
        }
        */
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard (userInfo["aps"] as? [String: AnyObject]) != nil else {
            completionHandler(.failed)
            return
        }
        completionHandler(.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
        guard let jsonString = notification.request.content.userInfo["custom"] as? String,  let json = jsonString.jsonObject else {
            completionHandler([.alert, .sound])
            return
        }
        
        if json["message"].dictionaryObject != nil {
            let msg = Message(jsonNotification: json)
            if AppUserDefaults.value(forKey: .selectedUserId).stringValue == msg.sender.senderId {
                NotificationCenter.default.post(name: .receiveMessage, object: self, userInfo: notification.request.content.userInfo)
                completionHandler([])
            } else {
                guard let mainTVC = (window?.rootViewController as? UINavigationController)?.viewControllers.first as? MainTabBarController else { return }
                mainTVC.tabBar.items?.last?.badgeValue = json["message"]["unread_count"] > 0 ? "\(json["message"]["unread_count"])" : nil
                completionHandler([.alert, .sound])
            }
            return
        }
    
        completionHandler([.alert, .sound])
    }
}


extension AppDelegate {
    
  
}


extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        // Check for sign in error
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }

        // Post notification after user successfully sign in
        NotificationCenter.default.post(name: .signInGoogleCompleted, object: nil)
    }
}

// MARK:- Notification names
extension Notification.Name {
    
    /// Notification when user successfully sign in using Google
    static var signInGoogleCompleted: Notification.Name {
        return .init(rawValue: #function)
    }
}
