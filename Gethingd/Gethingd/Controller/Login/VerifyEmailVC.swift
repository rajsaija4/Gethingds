//
//  VerifyEmailVC.swift
//  Zodi
//
//  Created by GT-Ashish on 19/11/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit
import SVPinView

class VerifyEmailVC: UIViewController {
    
    //MARK: - VARIABLE
    var contactNumber = String()
    var otp = String()
    fileprivate var pin = ""
    var param: [String: Any] = [:]
    
    //MARK: - OUTLET

    @IBOutlet weak var pinView: SVPinView!{
        didSet{
            pinView.pinLength = 4
            pinView.shouldSecureText = false
            pinView.style = .box
            
            pinView.borderLineColor = UIColor.white
            pinView.activeBorderLineColor = UIColor.white
            pinView.borderLineThickness = 1
            pinView.activeBorderLineThickness = 1
            pinView.activeFieldBackgroundColor = .white
            pinView.fieldBackgroundColor = .white
            pinView.fieldCornerRadius = 4
            pinView.activeFieldCornerRadius = 4
            
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


extension VerifyEmailVC {
    
    fileprivate func setupUI() {
        navigationItem.setHidesBackButton(true, animated: true)
//        showToastWithDuration(otp, 5.0)
        
        pinView.didFinishCallback = { [weak self] pin in
            print("The pin entered is \(pin)")
            self?.pin = pin
        }
        
    }
}


extension VerifyEmailVC {
    
    fileprivate func verifyLogin(param: [String: Any]) {
        showHUD()
        NetworkManager.Auth.verifyLogin(param: param, { (success) in
            self.hideHUD()
            
            APPDEL?.setupLogin()
            
            
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
            self.showToast(otp)
            
        }) { (error) in
            self.hideHUD()
            self.showToast(error)
        }
        
    }
}



extension VerifyEmailVC {
    
    @IBAction func onResendBtnTap(_ sender: UIButton) {
        
        let param = [
            "phone_number": contactNumber
        ]
        
        resendOTP(param: param)
    }
    
    @IBAction func onVerifyControlTap(_ sender: UIControl) {
        
        guard pin.count == 4 else {
            self.showToast("Please Enter OTP")
            return
        }
        
        param.merge(["otp": pin]) { (current, new) -> Any in
            return new
        }
        
        verifyLogin(param: param)
        
    }
    
    @IBAction func onBackBtnTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
