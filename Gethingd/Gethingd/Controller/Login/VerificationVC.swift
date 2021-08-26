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
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblCountdown: UILabel!
    //MARK: - VARIABLE
    var email = ""
    var otp = String()
    var password = ""
    fileprivate var pin = ""
//    var timer:Timer?
//    var timeLeft = 59
   

    
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
            pinView.activeFieldBackgroundColor = COLOR.lightGray
            pinView.fieldBackgroundColor = pinViewColor
            pinView.fieldCornerRadius = pinView.frame.height / 2
            pinView.fieldBackgroundColor = COLOR.lightGray
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
        lblMessage.text = "Please enter the 4 digit code sent to \(email)"
//        lblContactNo.text = contactNumber
//        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)

        setupUI()
//        update()
    }
//    @objc func onTimerFires()
//    {
//        timeLeft -= 1
//        lblCountdown.text = "00:\(timeLeft)"
//
//        if timeLeft <= 0 {
//            timer?.invalidate()
//            timer = nil
//        }
//    }
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
                APPDEL?.setUpAcceptTerms()
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
        NetworkManager.Auth.resendOTP(param: param, { (response) in
            self.hideHUD()
            self.showToast("otp Successfully send")
            
        }) { (error) in
            self.hideHUD()
            self.showToast(error)
        }
        
    }
}



extension VerificationVC {
    
    @IBAction func onResendBtnTap(_ sender: UIButton) {

        let param = [
            "email": email
        ]
        
        resendOTP(param: param)
    }
    
    @IBAction func onCallMeBtnTap(_ sender: UIButton) {
        
//        let param = [
//            "phone_number": contactNumber
//        ]
        
//        resendOTP(param: param)
    }
    
    @IBAction func onVerifyControlTap(_ sender: UIButton) {

        guard pin.count == 4 else {
            self.showToast("Please Enter OTP")
            return
        }
        
        let param = [
            "email": email,
            "login_otp": pin,
            "device_type":"ios",
            "password":password,
            "fcm_token": AppUserDefaults.value(forKey: .fcmToken, fallBackValue: "123").stringValue
        ] as [String : Any]
        
        verifyLogin(param: param)

    }
    
    @IBAction func onBackBtnTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
