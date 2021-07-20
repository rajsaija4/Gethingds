//
//  SuperLikeAddVC.swift
//  Zodi
//
//  Created by GT-Ashish on 23/10/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit

class SuperLikeAddVC: UIViewController {
    
    //MARK:- VARIABLE
    
    //MARK:- OUTLET
    @IBOutlet weak var lblSuperLike: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPlanInfo: UILabel!
    
    //MARK:- LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
   
}



extension SuperLikeAddVC {
    
    fileprivate func setupUI() {
        
//        lblSuperLike.text = "\(SuperLike.superLikeCount) Astro \n Like"
//        lblPrice.text = "$ \(SuperLike.price)"
        
        
    }
    
    
}



extension SuperLikeAddVC {
    
    @IBAction func onCloseBtnTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onContinueControlTap(_ sender: UIControl) {
        
        addAstroLike()
    }
    
}



extension SuperLikeAddVC {
    
    fileprivate func addAstroLike() {
        showHUD()
        IAPManager.purchaseAddOnProduct(forID: IAPManager.productIdAstroLike) { (isSuccess, transactionID) in
            self.hideHUD()
            guard isSuccess, let id = transactionID else { return }
            
            
            let param = [
                "plan_id": 4,
                "plan_type": "super_like",
                "payment_type": "appstore",
                "package_name": "com.Zodiap",
                "product_id": IAPManager.productIdAstroLike,
                "purchase_token": id,
                "transaction_id": id
            ] as [String : Any]
            
            self.makePayment(param: param)
            
        }
    }
    
    fileprivate func makePayment(param: [String : Any]) {
        
        showHUD()
        
        NetworkManager.Subscription.makePayment(param: param, { (message) in
            self.hideHUD()
            let alert = UIAlertController(title: "Success", message: message) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
            self.present(alert, animated: true, completion: nil)
            
        }, { (error) in
            self.hideHUD()
            self.showToast(error)
        })
        
    }
    
    
}
