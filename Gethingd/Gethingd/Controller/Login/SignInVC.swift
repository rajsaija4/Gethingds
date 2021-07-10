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
    @IBOutlet weak var txtPhoneNumber: PhoneNumberTextField!
    @IBOutlet weak var imgNumberStatus: UIImageView!
    
    
    //MARK:- LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
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
    
}



extension SignInVC {
    
    fileprivate func setupUI() {
        AppUserDefaults.save(value: true, forKey: .isFirstTimeUpgrade)
        txtPhoneNumber.withFlag = true
        txtPhoneNumber.withPrefix = true
        txtPhoneNumber.withExamplePlaceholder = true
        txtPhoneNumber.withDefaultPickerUI = true
        txtPhoneNumber.addTarget(self, action:#selector(self.textFieldDidChange(sender:)), for: UIControl.Event.editingChanged)
        PhoneNumberKit.CountryCodePicker.forceModalPresentation = true
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
    }
    
    @objc func textFieldDidChange(sender: UITextField) {
        imgNumberStatus.isHidden = !txtPhoneNumber.isValidNumber
    }
    
}



extension SignInVC {
    
    fileprivate func userLogIn(contact: String) {
        
        let param = ["phone": contact]
        showHUD()
        
        NetworkManager.Auth.login(param: param, { (otp) in
            self.hideHUD()
           
            let vc = VerificationVC.instantiate(fromAppStoryboard: .Login)
            vc.contactNumber = contact
            vc.otp = otp
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

        
        guard txtPhoneNumber.text?.count ?? 0 > 0 else {
            showToast("Please enter your mobile number")
            return
        }
            
        guard let phoneNumber = txtPhoneNumber.phoneNumber?.nationalNumber.description else {
            showToast("Please enter your mobile number")
            return
        }
        
        guard let countryCode = txtPhoneNumber.phoneNumber?.countryCode.description else {
            showToast("Please enter country code")
            return
        }


        let contact = "+" + countryCode + phoneNumber

        userLogIn(contact: contact)
       
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        txtPhoneNumber.text = txtPhoneNumber.text ?? "" + string
        print(txtPhoneNumber.isValidNumber)
        return true
    }
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
