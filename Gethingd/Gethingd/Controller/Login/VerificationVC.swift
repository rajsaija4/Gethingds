//
//  VerificationVC.swift
//  Zodi
//
//  Created by AK on 10/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit
import SVPinView

class VerificationVC: UIViewController {
    
    //MARK: - VARIABLE
    var contactNumber = String()
    var otp = String()
    fileprivate var pin = ""

    
    //MARK: - OUTLET
    @IBOutlet weak var pinView: SVPinView!{
        didSet{
            let pinViewColor = UIColor.lightGray.withAlphaComponent(0.5)
            pinView.pinLength = 4
            pinView.shouldSecureText = false
            pinView.style = .none
            pinView.placeholder = "----"
            
            pinView.borderLineColor = pinViewColor
            pinView.activeBorderLineColor = pinViewColor
            pinView.borderLineThickness = 1
            pinView.activeBorderLineThickness = 1
            pinView.activeFieldBackgroundColor = pinViewColor
            pinView.fieldBackgroundColor = pinViewColor
            pinView.fieldCornerRadius = pinView.frame.height / 2
            pinView.activeFieldCornerRadius = pinView.frame.height / 2
            
            pinView.font = AppFonts.Poppins_SemiBold.withSize(20)
            pinView.keyboardType = .phonePad
            pinView.becomeFirstResponderAtIndex = 0
            pinView.interSpace = (SCREEN_WIDTH - 300) / 4
        }
    }
    
   
    
    //MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
}


extension VerificationVC {
    
    fileprivate func setupUI() {
        navigationItem.setHidesBackButton(true, animated: true)
//        showToastWithDuration(otp, 5.0)
        
        pinView.didFinishCallback = { [weak self] pin in
            print("The pin entered is \(pin)")
            self?.pin = pin
        }
    
    }
}


extension VerificationVC {
    
    fileprivate func verifyLogin(param: [String: Any]) {
        showHUD()
        NetworkManager.Auth.verifyLogin(param: param, { (freemiumPlanActiveMsg) in
            self.hideHUD()
            
            guard User.details.firstName.count > 0 else {
                let vc = CreateProfileTVC.instantiate(fromAppStoryboard: .Profile)
                vc.isFromLogin = true
                vc.freemiumPlanActiveMsg = freemiumPlanActiveMsg
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            
            APPDEL?.setupMainTabBarController()
            
        }) { (error) in
            self.hideHUD()
            self.showToast(error)
        }

    }
    
    fileprivate func resendOTP(param: [String: Any]) {
        showHUD()
        NetworkManager.Auth.resendOTP(param: param, { (otp) in
            self.hideHUD()
            
            self.otp = otp
//            self.showToast(otp)
            
        }) { (error) in
            self.hideHUD()
            self.showToast(error)
        }
        
    }
}



extension VerificationVC {
    
    @IBAction func onResendBtnTap(_ sender: UIButton) {
        
        let param = [
            "phone_number": contactNumber
        ]
        
        resendOTP(param: param)
    }
    
    @IBAction func onCallMeBtnTap(_ sender: UIButton) {
        
        let param = [
            "phone_number": contactNumber
        ]
        
        resendOTP(param: param)
    }
    
    @IBAction func onVerifyControlTap(_ sender: UIButton) {
        
        guard pin.count == 4 else {
            self.showToast("Please Enter OTP")
            return
        }
        
        let param = [
            "phone_number": contactNumber,
            "otp": pin,
            "device_type": 1,
            "fcm_token": AppUserDefaults.value(forKey: .fcmToken, fallBackValue: "123").stringValue
        ] as [String : Any]
        
        verifyLogin(param: param)

    }
    
    @IBAction func onBackBtnTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
