//
//  SignInVC.swift
//  Zodi
//
//  Created by AK on 10/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleSignIn
import PhoneNumberKit
import AuthenticationServices
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class SignInVC: UIViewController {

    //MARK:- VARIABLE
    fileprivate var locationManager: CLLocationManager?
    
    
    
    //MARK:- OUTLET
    @IBOutlet weak var txtEmail: UITextField!
   @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var TxtPass: UITextField!
    @IBOutlet weak var loginStack: UIStackView!
    
    //MARK:- LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        appleCustomLoginButton()
        setupUI()
        self.navigationController?.navigationBar.isHidden = true
        GIDSignIn.sharedInstance()?.presentingViewController = self
        NotificationCenter.default.addObserver(self,
                                                   selector: #selector(userDidSignInGoogle(_:)),
                                                   name: .signInGoogleCompleted,
                                                   object: nil)
    }
    
    
    
    @IBAction func onPressGoogleLoginbtnTap(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
        
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
    
    // MARK:- Button action
       @objc func signInButtonTapped(_ sender: UIButton) {
           GIDSignIn.sharedInstance()?.signOut()
           GIDSignIn.sharedInstance()?.signIn()
       }

      

       // MARK:- Notification
       @objc private func userDidSignInGoogle(_ notification: Notification) {
           // Update screen after user successfully signed in
           updateScreen()
       }

    
    @IBAction func onPressSignin(_ sender: Any) {
        
        let vc = LoginVC.instantiate(fromAppStoryboard: .Login)
        self.modalPresentationStyle = .fullScreen
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onPressFbloginbtnTap(_ sender: Any) {
        
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
                    let email = (data["email"] as? String) ?? "no email"
                    let firstName = (data["first_name"] as? String) ?? "no fname"
                    let lastName = (data["last_name"] as? String) ?? "no lastname"
                    let id = (data["id"] as? String) ?? "no id"
                    
                    let params = [
                        "login_id": id ,
                        "login_type":"facebook" ,
                        "email": email ,
                        "first_name":firstName ,
                        "last_name":lastName ,
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
    @IBAction func onTermsBtnTap(_ sender: UIButton) {
        
        guard let termsURL = URL(string: URLManager.PrivacyPolicy.TermsUrl) else {
            return
        }
        
        openSafariViewController(termsURL)
    }
    
    @IBAction func onPrivacyBtnTap(_ sender: UIButton) {
        
        guard let privacyURL = URL(string: URLManager.PrivacyPolicy.privacyUrl) else {
            return
        }
        
        openSafariViewController(privacyURL)
    }
    
    @IBAction func btnPassVisible(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.tag == 0 {
            TxtPass.isSecureTextEntry = !sender.isSelected
        }
        
        else if sender.tag == 1 {
            txtConfirmPass.isSecureTextEntry = !sender.isSelected
        }
        
    }
}



extension SignInVC {
    
    fileprivate func setupUI() {
        AppUserDefaults.save(value: true, forKey: .isFirstTimeUpgrade)
//        txtPhoneNumber.withFlag = true
//        txtPhoneNumber.withPrefix = true
//        txtPhoneNumber.withExamplePlaceholder = true
//        txtPhoneNumber.withDefaultPickerUI = true
//        txtEmail.addTarget(self, action:#selector(self.textFieldDidChange(sender:)), for: UIControl.Event.editingChanged)
//        PhoneNumberKit.CountryCodePicker.forceModalPresentation = true
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
    }
    
//    @objc func textFieldDidChange(sender: UITextField) {
//       imgNumberStatus.isHidden = !txtPhoneNumber.isValidNumber
//    }
    
}



extension SignInVC {
    
    
    fileprivate func userLogIn() {
        
        guard let email = txtEmail.text, email.count > 0 else {
            self.showToast("Please Enter Email")
            return
        }
        
        guard email.isValidEmail else {
            self.showToast("Please Enter Valid Email")
            return
        }
        
        guard let password = TxtPass.text, password.count > 0 else {
            self.showToast("Please Enter Password")
            return
        }
        
        guard let rePassword = txtConfirmPass.text, rePassword.count > 0 else {
            self.showToast("Please Enter Password")
            return
        }
        
        guard password == rePassword else {
            self.showToast("Both Password Must be Same")
            return
            
        }
        
        guard password.count >= 6 else {
            showToast("Password should be 6 or more then 6 characters")
            return
        }
        
        guard rePassword.count >= 6 else {
            showToast("Password should be 6 or more then 6 characters")
            return
        }
        
        
        let param = ["email": email,
                     "password":password,
                     "password_confirmation":rePassword,
        ] as [String:Any]
        showHUD()
        
        NetworkManager.Auth.login(param: param, { (otp) in
            self.hideHUD()
           
            let vc = VerificationVC.instantiate(fromAppStoryboard: .Login)
            vc.email = self.txtEmail.text ?? ""
            vc.password = self.TxtPass.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
           
        }) { (error) in
            self.hideHUD()
            let alert = UIAlertController(title: "Oops!", message: error)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}


@available(iOS 13.0, *)
extension SignInVC: ASAuthorizationControllerDelegate {

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
extension SignInVC: ASAuthorizationControllerPresentationContextProviding {
    
    // For present window
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
}


extension SignInVC {
    
    @IBAction func signInBtnTap(_ sender: UIButton) {

//        guard let phoneNumber = txtPhoneNumber.phoneNumber?.nationalNumber.description else {
//            showToast("Please enter your mobile number")
//            return
//        }
//
//        guard let countryCode = txtPhoneNumber.phoneNumber?.countryCode.description else {
//            showToast("Please enter country code")
//            return
//        }


//        let contact = "+" + countryCode + phoneNumber
//
           userLogIn()
       
    }
    
    @IBAction func forgotPasswordBtnTap(_ sender: UIButton) {
        let vc = ForgotPasswordVC.instantiate(fromAppStoryboard: .Login)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func signUpBtnTap(_ sender: UIButton) {
        let vc = SignUpVC.instantiate(fromAppStoryboard: .Login)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}



extension SignInVC: UITextFieldDelegate {
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        txtEmail.text = txtEmail.text ?? "" + string
//
//        return true
//    }
}


extension SignInVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
            
        } else {
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            //            Filter.longitude = "\(location.coordinate.longitude)"
            //            Filter.latitude = "\(location.coordinate.latitude)"
        }
    }
}
