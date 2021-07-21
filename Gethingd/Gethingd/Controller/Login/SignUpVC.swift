//
//  SignUpVC.swift
//  Zodi
//
//  Created by AK on 10/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    //MARK: - VARIABLE
    
    
    //MARK: - OUTLET
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!{
        didSet{
            txtPhoneNumber.delegate = self
        }
    }
    @IBOutlet weak var txtPassword: UITextField!
    
   
    
    //MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: true)
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewTop.roundCorners(corners: .bottomRight, radius: 50)
    }
    

    
}



extension SignUpVC {
    
    fileprivate func userSignUp(param: [String: Any]) {
        
        showHUD()
        NetworkManager.Auth.signUp(param: param, { (otp) in
            self.hideHUD()
            Filter.reset()
            let vc = VerificationVC.instantiate(fromAppStoryboard: .Login)
            vc.otp = otp
//            vc.contactNumber = self.txtPhoneNumber.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }) { (error) in
            self.hideHUD()
            self.showToast(error)
        }
        
    }
    
}



extension SignUpVC {
    
    @IBAction func onSignUpControlTap(_ sender: UIControl) {
        
        guard let firstName = txtName.text, firstName.count > 0 else {
            showToast("Please \(txtName.placeholder ?? "")")
            return
        }
        
        guard let lastName = txtLastName.text, lastName.count > 0 else {
            showToast("Please \(txtLastName.placeholder ?? "")")
            return
        }
        
        guard let email = txtEmail.text, email.count > 0 else {
            showToast("Please \(txtEmail.placeholder ?? "")")
            return
        }
        
        guard email.isValidEmail else {
            showToast("Please Enter Valid Email Address")
            return
        }
        
        guard txtPhoneNumber.text?.count ?? 0 > 0 else {
            showToast("Please \(txtPhoneNumber.placeholder ?? "") ")
            return
        }
        
        guard let contactNumber = txtPhoneNumber.text else {
            showToast("Phone Number should be of 10 characters")
            return
        }
        
        guard txtPassword.text?.count ?? 0 > 0 else {
            showToast("Please \(txtPassword.placeholder ?? "")")
            return
        }
        
        guard let password = txtPassword.text , password.count >= 6 else {
            showToast("Password should be 6 or more then 6 characters")
            return
        }
        
        let param = [
            "phone_number": contactNumber,
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "password": password
        ]
        
        userSignUp(param: param)
        
        
    }
    
    @IBAction func onSignInBtnTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}



extension SignUpVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
        
        /*
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 10
        */
    }
}
