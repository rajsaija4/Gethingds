//
//  DiscoverVC.swift
//  Zodi
//
//  Created by AK on 10/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit
import Koloda
import SwiftyJSON
import CoreLocation

//like,Like,Super Like,super like,nope,Nope,super gold,Super Gold,rewind,Rewind

enum SwipeType: String {
    case like = "like"
    case nope = "nope"
    case reviewLater = "review"

}


class DiscoverVC: UIViewController {
    
    //MARK:- VARIABLE
    
    fileprivate var arrUser: [UserProfile] = []
    fileprivate var arrRewind: [UserProfile] = []
    fileprivate var locationManager: CLLocationManager?
    var timer = Timer()
    
    
    @IBOutlet weak var btnReviewLater: UIButton!
    //MARK:- OUTLET
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var imgNoProfile: UIImageView!
    @IBOutlet weak var btnRewind: UIButton!
    @IBOutlet weak var bottomStack: UIStackView!
    
    //MARK:- LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { [weak self] (timer) in
                    self?.getUserStatus()
                   })
                
              
        setupUI()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        navigationController?.isNavigationBarHidden = true
    }
    
}



extension DiscoverVC {
    
    fileprivate func setupUI() {
        kolodaView.dataSource = self
        kolodaView.delegate = self
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        getUserList()
    }
}



extension DiscoverVC {
    
    func getUserList() {
        
        NetworkManager.Profile.getMyProfile { user in
            guard user.address.count > 0  else {
              
                APPDEL?.setupCreateProfileVC()
               
                return
                    }
        } _: { error in
            self.showToast(error)
        }

 
//        Filter.lookingFor = "both"
        
        let param = [
            "looking_for": Filter.lookingFor,
            "min_age": Filter.minAge,
            "max_age": Filter.maxAge,
            "distance": Filter.distance,
            "min_kids": Filter.minKid,
            "max_kids": Filter.maxKid,
            "latitude": Filter.latitude,
            "longitude": Filter.longitude
        ] as [String : Any]
            
        showHUD()
         NetworkManager.Discover.discoverUser(param: param, { (users) in
            self.hideHUD()
           
            self.tabBarController?.tabBar.items?.last?.badgeValue = AppSupport.reviewLater > 0 ? "\(AppSupport.reviewLater)" : nil
              self.arrUser.removeAll()
            self.arrUser.append(contentsOf: users)
            self.kolodaView.reconfigureCards()
            self.kolodaView.reloadData()
            self.kolodaView.resetCurrentCardIndex()
            
            self.setupNoProfileView()
            
        }, { (error) in
            self.hideHUD()
            let alert = UIAlertController(title: "Oops!", message: error)
            self.present(alert, animated: true, completion: nil)
            self.arrUser.removeAll()
            self.kolodaView.reconfigureCards()
            self.kolodaView.reloadData()
            self.kolodaView.resetCurrentCardIndex()
            self.setupNoProfileView()
        },{ (version) in
            if version != APP_VERSION {
                let vc = UpdateAppVC.instantiate(fromAppStoryboard: .Upgrade)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
                return
            }
            
        })
        
    }
  
    
    
    fileprivate func swipeUser(userID: Int, status: SwipeType) {
        

        showHUD()
        
        let param = [
            "status": status.rawValue,
            "user_id": userID
        ] as [String : Any]
        
        NetworkManager.Discover.swipeProfiles(param: param, { (details) in
            self.hideHUD()
            
            if let matchDetails = details {
                let vc = MatchUserVC.instantiate(fromAppStoryboard: .Discover)
                vc.matchDetails = matchDetails
                let nvc = UINavigationController(rootViewController: vc)
                nvc.modalPresentationStyle = .fullScreen
                nvc.modalTransitionStyle = .crossDissolve
                nvc.isNavigationBarHidden = true
                self.present(nvc, animated: true, completion: nil)
            }
//
//            if status == .rewind {
//                self.bottomStack.isHidden = false
//                self.imgNoProfile.isHidden = true
//                self.kolodaView.isHidden = false
//            }
            
            guard status == .like else { return }
            
            if AppSupport.isLikeLimited == "yes" && AppSupport.remainingLikes == 0 {
                let vc = UpdateNowVC.instantiate(fromAppStoryboard: .Upgrade)
                vc.txtTitle.text = "OOPS"
                vc.txtMessage.text = "You have run out of your likes limit. Buy new likes now."
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
                return
            }
            

        }, { (error) in
            
            self.hideHUD()
            self.showToast(error)
        })
        
    }
    
//    fileprivate func addBoostUser() {
//        
//        showHUD()
//        
//        NetworkManager.Discover.boostProfile { (message) in
//            self.hideHUD()
//            let alert = UIAlertController(title: "Success!!!", message: message)
//            self.present(alert, animated: true, completion: nil)
//        } _: { (error) in
//            self.hideHUD()
//            self.showToast(error)
//        }
//        
//    }
    
    fileprivate func setupNoProfileView() {
        bottomStack.isHidden = self.arrUser.count == 0
        imgNoProfile.isHidden = arrUser.count != 0
        kolodaView.isHidden = arrUser.count == 0
    }
    
    
}



extension DiscoverVC {
    
    @IBAction func onLikeBtnTap(_ sender: UIButton) {
        guard arrUser.count > 0 else { return }
        if AppSupport.isLikeLimited == "yes" && AppSupport.remainingLikes == 0 {
            let vc = UpdateNowVC.instantiate(fromAppStoryboard: .Upgrade)
            vc.header = "OOPS!!"
            vc.message = "You have run out of your likes limit. Buy new likes now."
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.onreloadColl = {
                self.setupUI()
            }
            self.present(vc, animated: true, completion: nil)
            return


        }
        kolodaView?.swipe(.right)
        AppSupport.remainingLikes -= 1
    }
    
    @IBAction func onDisLikeBtnTap(_ sender: UIButton) {
        guard arrUser.count > 0 else { return }
        kolodaView?.swipe(.left)
    }
    
//    @IBAction func onRewindBtnTap(_ sender: UIButton) {
//
//        guard isPurchase else {
//            let vc = UpgradeVC.instantiate(fromAppStoryboard: .Upgrade)
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true, completion: nil)
//            return
//        }
//
//        guard arrRewind.count > 0 else {
//            showToast("No result found")
//            return
//        }
//        self.kolodaView?.revertAction()
//    }
    
    @IBAction func onSuperLikeBtnTap(_ sender: UIButton) {
        guard arrUser.count > 0 else { return }
        
        if AppSupport.isLikeLimited == "yes" && AppSupport.reviewLater == 0 {
            let vc = UpdateNowVC.instantiate(fromAppStoryboard: .Upgrade)
            vc.header = "OOPS!!"
            vc.message = "You have exhausted your review limit. Buy more credits."
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.onreloadColl = {
                self.setupUI()
            }
            self.present(vc, animated: true, completion: nil)
            return
        }
        kolodaView?.swipe(.down)
        AppSupport.reviewLater -= 1
    }
    
//    @objc fileprivate func onRewindBtnTap(_ sender: UIButton) {
//        self.kolodaView?.revertAction()
//    }
//
//    @IBAction func onBoostBtnTap(_ sender: UIButton) {
//        if AppSupport.remainingBoost == 0 {
//            let vc = UpgradeVC.instantiate(fromAppStoryboard: .Upgrade)
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true, completion: nil)
//            return
//        }
//        AppSupport.remainingBoost -= 1
//        addBoostUser()
//    }
//
//    @IBAction func onProfileLikedBtnTap(_ sender: UIButton) {
//        let vc = MatchUserVC.instantiate(fromAppStoryboard: .Discover)
//        let nvc = UINavigationController(rootViewController: vc)
//        nvc.modalPresentationStyle = .fullScreen
//        nvc.modalTransitionStyle = .crossDissolve
//        nvc.isNavigationBarHidden = true
//        self.present(nvc, animated: true, completion: nil)
//    }
    
    @IBAction func onFilterBtnTap(_ sender: UIButton) {
        let vc = FilterTVC.instantiate(fromAppStoryboard: .Discover)
//        
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        nvc.modalTransitionStyle = .crossDissolve
        self.present(nvc, animated: true, completion: nil)
    }
    
}



// MARK: KolodaViewDelegate

extension DiscoverVC: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        bottomStack.isHidden = true
        imgNoProfile.isHidden = false
        kolodaView.isHidden = true
    }
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right, .up, .down]
    }
    
//    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
//        let vc = UserDetailsTVC.instantiate(fromAppStoryboard: .Discover)
//        vc.user = arrUser[index]
//        vc.onLikeUser = {
//            koloda.swipe(.right)
//        }
//
//        vc.onDisLikeUser = {
//            koloda.swipe(.left)
//        }
//
//        vc.onReviewLater = {
//            koloda.swipe(.down)
//            self.swipeUser(userID: self.arrUser[index].id, status: .reviewLater)
//        }
//
//        let nvc = UINavigationController(rootViewController: vc)
//        nvc.modalPresentationStyle = .fullScreen
//        nvc.modalTransitionStyle = .crossDissolve
//        self.present(nvc, animated: true, completion: nil)
//    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        print(direction)
//        arrRewind.append(arrUser[index])
//        return
        switch direction {
            case .right:
                if AppSupport.isLikeLimited == "yes" && AppSupport.remainingLikes == 0 {
                    let vc = UpdateNowVC.instantiate(fromAppStoryboard: .Upgrade)
                    vc.header = "OOPS!!"
                    vc.message = "You have run out of your likes limit. Buy new likes now."
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.modalTransitionStyle = .crossDissolve
                    vc.onreloadColl = {
                        self.setupUI()
                    }
                    self.present(vc, animated: true, completion: nil)
                    return

                }
                
                AppSupport.remainingLikes -= 1
                self.swipeUser(userID: arrUser[index].id, status: .like)
            case .left:
                self.swipeUser(userID: arrUser[index].id, status: .nope)
            case .up:
                
                let vc = UserDetailsTVC.instantiate(fromAppStoryboard: .Discover)
                vc.user = arrUser[index]
//                vc.onLikeUser = {
//                    koloda.swipe(.right)
//                    self.swipeUser(userID: self.arrUser[index].id, status: .like)
//                }
//
//                vc.onDisLikeUser = {
//                    koloda.swipe(.left)
//                    self.swipeUser(userID: self.arrUser[index].id, status: .nope)
//                }
//
//                vc.onReviewLater = {
//                    koloda.swipe(.down)
//                    self.swipeUser(userID: self.arrUser[index].id, status: .reviewLater)
//                }
//
//               let nvc = UINavigationController(rootViewController: vc)
                vc.modalPresentationStyle = .fullScreen
//                nvc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
                
               
        case .down:
            if AppSupport.isLikeLimited == "yes" && AppSupport.reviewLater == 0 {
                let vc = UpdateNowVC.instantiate(fromAppStoryboard: .Upgrade)
                vc.header = "OOPS!!"
                vc.message = "You have exhausted your review limit. Buy more credits."
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                vc.onreloadColl = {
                    self.setupUI()
                }
                self.present(vc, animated: true, completion: nil)
                return
            }
            AppSupport.reviewLater -= 1
            self.swipeUser(userID: arrUser[index].id, status: .reviewLater)
            default:
                break
        }
    }
    
//    func koloda(_ koloda: KolodaView, didRewindTo index: Int) {
//        if arrRewind.count > index {
//           print(arrRewind[index].id)
//            self.swipeUser(userID: arrRewind[index].id, status: .re)
//            arrRewind.remove(at: index)
//        }
 //   }
    
    
    
}


// MARK: KolodaViewDataSource

extension DiscoverVC: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return arrUser.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .slow
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        guard index < arrUser.count else { return UIView.init() }
        
        let user = arrUser[index]
        
        let userView = UserView(frame: koloda.bounds)
//        userView.imgSuperLike.isHidden = !user.isSuperLike
        if user.userSetting.showmyAge == 1{
        userView.lblInfo.text = "\(user.firstName)" + ", " + "\(user.age)"
        }
        else {
            userView.lblInfo.text = "\(user.firstName)"
        }
        if user.userSetting.distanceVisible == 1{
        userView.lbladdress.text = "\(user.distance)" + ", " + "\(user.address)"
        }
        else {
        userView.lbladdress.text = "\(user.address)"
        }
        //userView.btnRewind.tag = index
        //userView.btnRewind.addTarget(self, action: #selector(self.onRewindBtnTap(_:)), for: .touchUpInside)
        if let url = URL(string: user.image1) {
            userView.imgUser.kf.setImage(with: url)
        }
//        if let url = URL(string: user.sunSignId.getActiveSignIconURL) {
//            userView.imgSign.kf.setImage(with: url)
//        }
        
        return userView
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}


extension DiscoverVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
            self.getUserList()
        } else {
            self.getUserList()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            //            Filter.longitude = "\(location.coordinate.longitude)"
            //            Filter.latitude = "\(location.coordinate.latitude)"
        }
    }
}


extension DiscoverVC {
    
  
    
    func getUserStatus() {
        
        let timeStamp = "\(Date().timeIntervalSince1970)".components(separatedBy: ".").first ?? ""
        let param = [
            "time": timeStamp
        ] as [String : Any]
        
        NetworkManager.Chat.checkUserStatus(param: param) { (response) in
        } _: { (error) in
        }

    }

    
    
    
    
}
