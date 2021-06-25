//
//  ForgotPasswordVC.swift
//  Zodi
//
//  Created by AK on 10/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    //MARK: - VARIABLE
    
    //MARK: - OUTLET
    @IBOutlet weak var txtEmail: UITextField!
    
    //MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: true)
    }
 

}



extension ForgotPasswordVC {
    
    fileprivate func forgotPassword(param: [String: String]) {
        
        showHUD()
        
        NetworkManager.Auth.forgotPassword(param: param, { (message) in
            self.hideHUD()
            let alert = UIAlertController(title: "Forgot Password", message: message, actionName: "Ok") { (_) in
                self.navigationController?.popViewController(animated: true)
            }
            self.present(alert, animated: true, completion: nil)
        }, { (error) in
            self.hideHUD()
            self.showToast(error)
        })
        
    }
    
}



extension ForgotPasswordVC {
    
    @IBAction func onContinueControlTap(_ sender: UIControl) {
        
        guard let email = txtEmail.text, email.count > 0 else {
            showToast("Please \(txtEmail.placeholder ?? "")")
            return
        }
        
        guard email.isValidEmail else {
            showToast("Please Enter Valid Email Address")
            return
        }
        
        let param = ["email": email]
        forgotPassword(param: param)
    }
    
    @IBAction func onBackBtnTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
