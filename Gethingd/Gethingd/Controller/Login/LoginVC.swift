//
//  LoginVC.swift
//  Gethingd
//
//  Created by GT-Raj on 22/07/21.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onPressLogin(_ sender: UIButton) {
        
        userLogIn()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
        
    
        let param = ["email": email,
                     "password":password,
                     
        ] as [String:Any]
        showHUD()
        
        NetworkManager.Auth.SignIn(param: param, { (response) in
            self.hideHUD()
            APPDEL?.setupMainTabBarController()
           print(response)
        }) { (error) in
            self.hideHUD()
            let alert = UIAlertController(title: "Oops!", message: error)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
