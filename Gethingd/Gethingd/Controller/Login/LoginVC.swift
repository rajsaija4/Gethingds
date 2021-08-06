//
//  LoginVC.swift
//  Gethingd
//
//  Created by GT-Raj on 22/07/21.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase


class LoginVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        GIDSignIn.sharedInstance()?.presentingViewController = self
        NotificationCenter.default.addObserver(self,
                                                   selector: #selector(userDidSignInGoogle(_:)),
                                                   name: .signInGoogleCompleted,
                                                   object: nil)
        // Do any additional setup after loading the view.
    }
    
    
    private func updateScreen() {
           
           if let user = GIDSignIn.sharedInstance()?.currentUser {
            let firstName = user.profile.givenName
            let lastName = user.profile.familyName
            let email = user.profile.email
            let loginId = user.userID
            let loginType = "google"
            
            let params = [
                "login_id": loginId ?? 0,
                "login_type":loginType ,
                "email": email ?? "",
                "first_name":firstName ?? "",
                "last_name":lastName ?? "",
                "device_type":"ios",
                "fcm_token": AppUserDefaults.value(forKey: .fcmToken, fallBackValue: "123").stringValue
                ] as [String:Any]
            
            NetworkManager.Auth.socialLogin(param: params) { (success) in
                if User.details.firstName.count > 0 {
                APPDEL?.setupMainTabBarController()
                }
                else {
                    APPDEL?.setupCreateProfileVC()
                }

            } _: { (error) in
                print(error)
            }

           
           
           } else {
              
           }
       }
    
//    // MARK:- Button action
//       @objc func signInButtonTapped(_ sender: UIButton) {
//           GIDSignIn.sharedInstance()?.signOut()
//           GIDSignIn.sharedInstance()?.signIn()
//       }

      

       // MARK:- Notification
       @objc private func userDidSignInGoogle(_ notification: Notification) {
           // Update screen after user successfully signed in
           updateScreen()
       }
    @IBAction func onPressLogin(_ sender: UIButton) {
        
        userLogIn()
    }
    
    @IBAction func onPressFbloginbtnTap(_ sender: UIButton) {
        LoginManager().logOut()
        let facebookReadPermissions = ["public_profile", "email","user_birthday","user_gender"]
        LoginManager().logIn(permissions: facebookReadPermissions, from: self) { (loginResult, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                let fbloginresult : LoginManagerLoginResult = loginResult!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                    }
                }
            }
        }
        
        
    }
    
    func getFBUserData() {
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email,gender,birthday"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil) {
                    let data = result as! [String:Any]
                    let email = (data["email"] as? String)
                    let firstName = (data["first_name"] as? String)
                    let lastName = (data["last_name"] as? String)
                    let id = (data["id"] as? String)
                    
                    let params = [
                        "login_id": id ?? "",
                        "login_type":"ios" ?? "",
                        "email": email ?? "",
                        "first_name":firstName ?? "" ,
                        "last_name":lastName ?? "",
                        "device_type":"ios",
                        "fcm_token": AppUserDefaults.value(forKey: .fcmToken, fallBackValue: "123").stringValue
                        ] as [String:Any]
                    
                    NetworkManager.Auth.socialLogin(param: params) { (success) in
                        if User.details.firstName.count > 0 {
                        APPDEL?.setupMainTabBarController()
                        }
                        else {
                        APPDEL?.setupCreateProfileVC()
                        }

                    } _: { (error) in
                        print(error)
                    }
               
                }
            })
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onPressGoogleSIgnin(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
        
    }
    @IBAction func btnPasswordhideonPress(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        txtPassword.isSecureTextEntry = !sender.isSelected
        
        
    }
    @IBAction func onPressForgotPassword(_ sender: UIButton) {
        
        let vc = FpasswordVC.instantiate(fromAppStoryboard: .Login)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onPressbtnSingUp(_ sender: UIButton) {
        
        let vc = SignInVC.instantiate(fromAppStoryboard: .Login)
        self.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}


extension LoginVC {
    fileprivate func userLogIn() {
        
        guard let email = txtEmail.text, email.count > 0 else {
            self.showToast("Please Enter Email")
            return
        }
        
        guard email.isValidEmail else {
            self.showToast("Please Enter Valid Email")
            return
        }
        
        guard let password = txtPassword.text, password.count > 0 else {
            self.showToast("Please Enter Password")
            return
        }
        
        guard password.count >= 6 else {
            showToast("Password should be 6 or more then 6 characters")
            return
        }
    
        let param = ["email": email,
                     "password":password,
                     "device_type":"ios",
                     "fcm_token": AppUserDefaults.value(forKey: .fcmToken, fallBackValue: "123").stringValue

                     
        ] as [String:Any]
        showHUD()
        
        NetworkManager.Auth.SignIn(param: param, { (response) in
            self.hideHUD()
            if User.details.firstName.count > 0 {
            APPDEL?.setupMainTabBarController()
            }
            else {
                APPDEL?.setupCreateProfileVC()
            }
           print(response)
        }) { (error) in
            self.hideHUD()
            let alert = UIAlertController(title: "Oops!", message: error)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

