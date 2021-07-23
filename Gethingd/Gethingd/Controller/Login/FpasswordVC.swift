//
//  FpasswordVC.swift
//  Gethingd
//
//  Created by GT-Raj on 22/07/21.
//

import UIKit

class FpasswordVC: UIViewController {

    @IBOutlet weak var txtEMail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        // Do any additional setup after loading the view.
    }
    @IBAction func onPressLoginbtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onPressbtnSend(_ sender: UIButton) {
        
        forgotPassword()
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension FpasswordVC  {
        func forgotPassword() {
        
        guard let email = txtEMail.text, email.count > 0 else {
            self.showToast("Please Enter Email")
            return
        }
        
        guard email.isValidEmail else {
            self.showToast("Please Enter Valid Email")
            return
        }
        
       let param = [
            
            "email":email
        
        
        ] as [String:Any]
        
            showHUD()
            NetworkManager.Auth.forgotPassword(param: param) { response in
                self.hideHUD()
                self.showVerifyEmailAlert()
                
            } _: { error in
                self.hideHUD()
                let alert = UIAlertController(title: "Oops!", message: error)
                self.present(alert, animated: true, completion: nil)
            }

      
    }
    
     fileprivate func verifyEmailOTP(param: [String: Any]) {
        
        showHUD()
        NetworkManager.Auth.verifyEmail(param: param, { (success) in
            self.hideHUD()
            let vc = NewPasswordVC.instantiate(fromAppStoryboard: .Login)
            vc.key = success
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }) { (error) in
            self.hideHUD()
            let alert = UIAlertController(title: "Oops!", message: error)
            self.present(alert, animated: true, completion: nil)
        }
     }

    
    
       fileprivate func showVerifyEmailAlert() {
        guard let email = self.txtEMail.text else { return }
        let alert = UIAlertController(title: "Email OTP Verification", message: "Please enter the code received in your email \(email). If you do not see email in your Inbox then please check your Spam/Junk emails.", actionName: "Verify", placeholder: "Enter Verification OTP") { (txtOTP) in
            
            let param = [
                "email": email,
                "otp": txtOTP.text ?? ""
            ]
            self.verifyEmailOTP(param: param)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}
