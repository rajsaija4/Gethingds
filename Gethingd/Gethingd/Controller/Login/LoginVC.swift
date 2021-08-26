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
import AuthenticationServices
import Firebase




class LoginVC: UIViewController {

    @IBOutlet weak var loginStack: UIStackView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        appleCustomLoginButton()
        self.navigationController?.navigationBar.isHidden = true
        GIDSignIn.sharedInstance()?.presentingViewController = self
        NotificationCenter.default.addObserver(self,
                                                   selector: #selector(userDidSignInGoogle(_:)),
                                                   name: .signInGoogleCompleted,
                                                   object: nil)
        // Do any additional setup after loading the view.
    }
    
    // Custom 'Sign in with Apple' button
    func appleCustomLoginButton() {
        if #available(iOS 13.0, *) {
            let customAppleLoginBtn = UIButton()
            customAppleLoginBtn.setImage(UIImage(named: "apple"), for: .normal)
            customAppleLoginBtn.addTarget(self, action: #selector(actionHandleAppleSignin), for: .touchUpInside)
            self.loginStack.addArrangedSubview(customAppleLoginBtn)
      }
    }
    
    @available(iOS 13.0, *)
    func getCredentialState() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: "USER_ID") { (credentialState, error) in
            switch credentialState {
            case .authorized:
                // Credential is valid
                // Continiue to show 'User's Profile' Screen
                if User.details.address.count > 0 {
                APPDEL?.setupMainTabBarController()
                }
                else {
                    APPDEL?.setUpAcceptTerms()
                }
                
                break
            case .revoked:
                // Credential is revoked.
                APPDEL?.setupLogin()
                break
            case .notFound:
                // Credential not found.
                // Show 'Sign In' Screen
                APPDEL?.setupLogin()
                break
            default:
                break
            }
        }
    }


    @objc func actionHandleAppleSignin() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
    
    
    private func updateScreen() {
           
           if let user = GIDSignIn.sharedInstance()?.currentUser {
            let firstName = user.profile.givenName
            let lastName = user.profile.familyName
            let email = user.profile.email
            let loginId = user.userID
            let params = [
                "login_id": loginId ?? 0,
                "login_type":"google" ,
                "email": email ?? "",
                "first_name":firstName ?? "",
                "last_name":lastName ?? "",
                "device_type":"ios",
                "fcm_token": AppUserDefaults.value(forKey: .fcmToken, fallBackValue: "123").stringValue
                ] as [String:Any]
            
            NetworkManager.Auth.socialLogin(param: params) { (success) in
                if User.details.address.count > 0 {
                APPDEL?.setupMainTabBarController()
                }
                else {
                    APPDEL?.setUpAcceptTerms()
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
                        "login_type":"facebook" ?? "",
                        "email": email ?? "",
                        "first_name":firstName ?? "" ,
                        "last_name":lastName ?? "",
                        "device_type":"ios",
                        "fcm_token": AppUserDefaults.value(forKey: .fcmToken, fallBackValue: "123").stringValue
                        ] as [String:Any]
                    
                    NetworkManager.Auth.socialLogin(param: params) { (success) in
                        if User.details.address.count > 0 {
                        APPDEL?.setupMainTabBarController()
                        }
                        else {
                        APPDEL?.setUpAcceptTerms()
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
    @IBAction func onPressPrivacybtnTap(_ sender: UIButton) {
        
        guard let termsURL = URL(string: URLManager.PrivacyPolicy.TermsUrl) else {
            return
        }
        
        openSafariViewController(termsURL)
    }

    @IBAction func onPressTermsbtnTap(_ sender: UIButton) {
        
        guard let privacyURL = URL(string: URLManager.PrivacyPolicy.privacyUrl) else {
            return
        }
        
        openSafariViewController(privacyURL)
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
            if User.details.address.count > 0 {
            APPDEL?.setupMainTabBarController()
            }
            else {
                APPDEL?.setUpAcceptTerms()
            }
           print(response)
        }) { (error) in
            self.hideHUD()
            let alert = UIAlertController(title: "Oops!", message: error)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

@available(iOS 13.0, *)
extension LoginVC: ASAuthorizationControllerDelegate {

    // Authorization Failed
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }


    // Authorization Succeeded
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Get user data with Apple ID credentitial
            let appleId = appleIDCredential.user
              let userID = appleId
              let appleUserFirstName = appleIDCredential.fullName?.givenName
              let firstName = appleUserFirstName ?? ""
              let appleUserLastName = appleIDCredential.fullName?.familyName
              let lastName = appleUserLastName ?? ""
              let appleUserEmail = appleIDCredential.email
              let email = appleUserEmail ?? ""
                let params = [
                    "login_id": appleId ,
                    "login_type":"apple" ,
                    "email": email ,
                    "first_name":firstName ,
                    "last_name":lastName ,
                    "device_type":"ios",
                    "fcm_token": AppUserDefaults.value(forKey: .fcmToken, fallBackValue: "123").stringValue
                ] as [String:Any]
            print(params)
            
            NetworkManager.Auth.socialLogin(param: params) { (success) in
                if User.details.address.count > 0 {
                APPDEL?.setupMainTabBarController()
                }
                else {
                APPDEL?.setUpAcceptTerms()
                }

            } _: { (error) in
                print(error)
            }        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Get user data using an existing iCloud Keychain credential
            let appleUsername = passwordCredential.user
            let applePassword = passwordCredential.password
            // Write your code
        }
    }

}


@available(iOS 13.0, *)
extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    
    // For present window
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
}
