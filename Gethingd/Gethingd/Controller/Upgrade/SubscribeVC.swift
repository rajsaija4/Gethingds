//
//  SubscribeVC.swift
//  Gethingd
//
//  Created by GT-Raj on 06/07/21.
//

import UIKit

class SubscribeVC: UIViewController {
    
    fileprivate var freePlan: SubscriptionPlan?
    fileprivate var premiumPlan: SubscriptionPlan?

    @IBOutlet weak var btnFMonthActivate: UIButton!
    @IBOutlet weak var btnTHreeMonthActivate: UIButton!
    @IBOutlet weak var btnFplan: UIButton!
    @IBOutlet weak var btnPplan: UIButton!
    
    @IBOutlet weak var FplanLikesPerDay: UILabel!
    @IBOutlet weak var fplanReviewLater: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getPlanList()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onPressbackbtnTap(_ sender: UIButton) {
        
        self.dismiss(animated: true)
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

extension SubscribeVC {
    
fileprivate func getPlanList() {
    
    showHUD()
    NetworkManager.Subscription.getSubscriptionPlans { (freePlan, premiumPlan) in
        self.hideHUD()
        self.freePlan = freePlan
        self.premiumPlan = premiumPlan
        self.setupUI()
    } _: { (error) in
        self.hideHUD()
        self.showToast(error)
    }
}
    
    func setupUI() {
        FplanLikesPerDay.text = "\(freePlan?.likes_per_day ?? 0) LIKES PER DAY"
        fplanReviewLater.text = "\(freePlan?.review_later_per_day ?? 0) REVIEW LATER PROFILE"
        if freePlan?.is_active == 1 {
            btnPplan.isHidden = true
        }
        
        else {
            btnFplan.isHidden = true
        }
    }
}
