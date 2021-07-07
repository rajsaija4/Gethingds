//
//  UpgradeVC.swift
//  Zodi
//
//  Created by AK on 16/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit
//import Hero

class UpgradeVC: UIViewController {
    
    //MARK:- VARIABLE
    fileprivate var freePlan: SubscriptionPlan?
    fileprivate var premiumPlan: SubscriptionPlan?
    fileprivate var freemiumPlan: SubscriptionPlan?
    var onPurchasePlan: (() -> ())?
    var isFromNotification = false
    
    //MARK:- OUTLET
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var lblFreePlanActive: UILabel!
    @IBOutlet weak var lblPremiumPlanActive: UILabel!
    @IBOutlet weak var lblFreemiumPlanActive: UILabel!
    
    @IBOutlet weak var lblFreeSwipe: UILabel!
    @IBOutlet weak var lblFreeSuperLike: UILabel!
    @IBOutlet weak var lblFreeBoost: UILabel!
    
    @IBOutlet weak var lblFreemiumSwipe: UILabel!
    @IBOutlet weak var lblFreemiumSuperLike: UILabel!
    @IBOutlet weak var lblFreemiumBoost: UILabel!
    @IBOutlet weak var lblFreemiumExpireDate: UILabel!
    
    @IBOutlet weak var lblPremiumSwipe: UILabel!
    @IBOutlet weak var lblPremiumSuperLike: UILabel!
    @IBOutlet weak var lblPremiumBoost: UILabel!
    @IBOutlet weak var lblPremiumExpireDate: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnUpgrade: UIButton!
    
    @IBOutlet weak var stackFreemiumPlan: UIStackView!
    
    //MARK:- LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
//        hero.isEnabled = true
//        btnInfo.heroID = "zodi"
        setupActivePlan()
        navigationItem.setHidesBackButton(true, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if AppUserDefaults.value(forKey: .isFirstTimeUpgrade, fallBackValue: true).boolValue {
            AppUserDefaults.save(value: false, forKey: .isFirstTimeUpgrade)
            let vc = UpgradePlanInfoVC.instantiate(fromAppStoryboard: .Upgrade)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func onInfoBtnTap(_ sender: UIButton) {
        let vc = UpgradePlanInfoVC.instantiate(fromAppStoryboard: .Upgrade)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}



extension UpgradeVC {
    
    fileprivate func setupActivePlan() {
      
        getPlanList()
    }
    
    fileprivate func setupUI() {
        
        btnUpgrade.isEnabled = !((freemiumPlan?.isActive ?? false) || (premiumPlan?.isActive ?? false))
        
        stackFreemiumPlan.isHidden = !((freemiumPlan?.isDisplay ?? true) && (freemiumPlan?.isActive ?? true))
        
        lblFreePlanActive.isHidden = !(freePlan?.isActive ?? false)
        lblPremiumPlanActive.isHidden = !(premiumPlan?.isActive ?? false)
        lblFreemiumPlanActive.isHidden = !(freemiumPlan?.isActive ?? false)
        
        lblFreeSwipe.text = "\(freePlan?.likesCount ?? 30) Likes Daily"
        lblFreeSuperLike.text = "\(freePlan?.superLikeCount ?? 1) Astro Like Daily"
        lblFreeBoost.text = "\(freePlan?.boostCount ?? 1) Moon Boost Monthly"
        
        lblFreemiumSwipe.text = "Unlimited Likes"
        lblFreemiumSuperLike.text = "\(freemiumPlan?.superLikeCount ?? 5) Astro \((freemiumPlan?.superLikeCount ?? 5) > 1 ? "Likes" : "Like") Daily"
        lblFreemiumBoost.text = "\(freemiumPlan?.boostCount ?? 10) Moon Boosts Monthly"
        lblFreemiumExpireDate.text = "Expiry Date : \(freemiumPlan?.expiryDate ?? "")"
        lblFreemiumExpireDate.isHidden = (freemiumPlan?.expiryDate ?? "").count == 0
        
        lblPremiumSwipe.text = "Unlimited Likes"
        lblPremiumSuperLike.text = "\(premiumPlan?.superLikeCount ?? 5) Astro Likes Daily"
        lblPremiumBoost.text = "\(premiumPlan?.boostCount ?? 10) Moon Boosts Monthly"
        lblPremiumExpireDate.text = "Expiry Date : \(premiumPlan?.expiryDate ?? "")"
        lblPremiumExpireDate.isHidden = (premiumPlan?.expiryDate ?? "").count == 0
        
        lblPrice.text = "$\(premiumPlan?.price ?? 9.99) PER MONTH"
        
    }
    
}



extension UpgradeVC {
    
    fileprivate func getPlanList() {
        
        showHUD()
        NetworkManager.Subscription.getSubscriptionPlans { (freePlan, premiumPlan, freemiumPlan) in
            self.hideHUD()
            self.freePlan = freePlan
            self.premiumPlan = premiumPlan
            self.freemiumPlan = freemiumPlan
            self.setupUI()
        } _: { (error) in
            self.hideHUD()
            self.showToast(error)
        }
    }
    
    
    fileprivate func makePayment(param: [String : Any]) {
        
        showHUD()
       
        NetworkManager.Subscription.makePayment(param: param, { (message) in
            self.hideHUD()
            let alert = UIAlertController(title: "Success", message: message) { (_) in
                self.dismissVC()
            }
            self.present(alert, animated: true, completion: nil)
            
        }, { (error) in
            self.hideHUD()
            self.showToast(error)
        })
        
    }
    
}



extension UpgradeVC {
    
    @IBAction func onBackBtnTap(_ sender: UIButton) {
        dismissVC()
    }
    
    @IBAction func onUpgradeBtnTap(_ sender: UIButton) {
        upgradePlan()
    }
}



extension UpgradeVC {
    
    fileprivate func dismissVC() {
        
        if isFromNotification {
            APPDEL?.setupMainTabBarController()
            return
        }
        
        onPurchasePlan?()
        if navigationController == nil {
            self.dismiss(animated: true, completion: nil)
            return
        }
        navigationController?.popViewController(animated: true)
    }
}



extension UpgradeVC {
    
    fileprivate func upgradePlan() {
        showHUD()
        IAPManager.purchaseProduct(forID: IAPManager.productIdMonth) { (isSuccess, transactionID) in
            self.hideHUD()
            guard isSuccess, let id = transactionID else { return }
            
            isPurchase = true
            let param = [
                "plan_id": 1,
                "plan_type": "gold",
                "payment_type": "appstore",
                "package_name": "com.Zodiap",
                "product_id": IAPManager.productIdMonth,
                "purchase_token": id,
                "transaction_id": id
            ] as [String : Any]
            
            self.makePayment(param: param)
            
        }
    }
    

}
