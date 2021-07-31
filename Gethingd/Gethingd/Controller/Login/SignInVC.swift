//
//  SignInVC.swift
//  Zodi
//
//  Created by AK on 10/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit
import CoreLocation
import PhoneNumberKit

class SignInVC: UIViewController {

    //MARK:- VARIABLE
    fileprivate var locationManager: CLLocationManager?
    
    
    
    //MARK:- OUTLET
    @IBOutlet weak var txtEmail: UITextField!
   @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var TxtPass: UITextField!
    
    //MARK:- LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func onPressSignin(_ sender: Any) {
        
        let vc = LoginVC.instantiate(fromAppStoryboard: .Login)
        self.modalPresentationStyle = .fullScreen
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTermsBtnTap(_ sender: UIButton) {
        
        guard let termsURL = URL(string: "https://www.zodiap.org/page/terms_and_conditions") else {
            return
        }
        
        openSafariViewController(termsURL)
    }
    
    @IBAction func onPrivacyBtnTap(_ sender: UIButton) {
        
        guard let privacyURL = URL(string: "https://www.zodiap.org/page/privacy_policy") else {
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
            self.showToast("Please Enter Both Password Same")
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
                     "password_confirmation":rePassword
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
