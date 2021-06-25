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
    case like = "Like"
    case nope = "Nope"
    case superLike = "Super Like"
    case rewind = "Rewind"
}


class DiscoverVC: UIViewController {
    
    //MARK:- VARIABLE
    
    fileprivate var arrUser: [UserProfile] = []
    fileprivate var arrRewind: [UserProfile] = []
    fileprivate var locationManager: CLLocationManager?
    
    
    //MARK:- OUTLET
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var imgNoProfile: UIImageView!
    @IBOutlet weak var btnRewind: UIButton!
    @IBOutlet weak var bottomStack: UIStackView!
    
    //MARK:- LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewHeader.roundCorners(corners: .bottomRight, radius: 40)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
}



extension DiscoverVC {
    
    fileprivate func setupUI() {
        kolodaView.dataSource = self
        kolodaView.delegate = self
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        locationManager?.requestAlwaysAuthorization()
        
        getUserList()
    }
}



extension DiscoverVC {
    
    func getUserList() {
        
        showHUD()
        
        let param = [
            "min_age": Filter.minAge,
            "max_age": Filter.maxAge,
            "distance": Filter.distance,
            "min_height": Filter.minHeight,
            "max_height": Filter.maxHeight,
            "sun_zodiac_sign_id": Filter.sunSignId,
            "moon_zodiac_sign_id": Filter.moonSignId,
            "rising_zodiac_sign_id": Filter.risingSignId
        ] as [String : Any]
        
        /*
        let param = [
            "min_age": Filter.minAge,
            "max_age": Filter.maxAge,
            "distance": Filter.distance,
            "min_height": Filter.minHeight,
            "max_height": Filter.maxHeight,
            "sun_zodiac_sign_id": Filter.sunSignId,
            "moon_zodiac_sign_id": Filter.moonSignId,
            "rising_zodiac_sign_id": Filter.risingSignId,
            "latitude": "\(locationManager?.location?.coordinate.latitude ?? 0)",
            "longitude": "\(locationManager?.location?.coordinate.longitude ?? 0)"
        ] as [String : Any]
        */
        
        NetworkManager.Discover.discoverUser(param: param, { (users) in
            self.hideHUD()
            
            self.tabBarController?.tabBar.items?.last?.badgeValue = AppSupport.unreadCount > 0 ? "\(AppSupport.unreadCount)" : nil
            
            
            if AppSupport.version > APP_VERSION {
                let vc = UpdateNowVC.instantiate(fromAppStoryboard: .Upgrade)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
                return
            }
            
            
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
        })
        
    }
    
    
    
    fileprivate func swipeUser(userID: Int, status: SwipeType) {
        

        showHUD()
        
        let param = [
            "status": status.rawValue,
            "user_id": userID,
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
            
            if status == .rewind {
                self.bottomStack.isHidden = false
                self.imgNoProfile.isHidden = true
                self.kolodaView.isHidden = false
            }
            
            guard status == .like else { return }
            
            if AppSupport.isLikeLimited && AppSupport.remainingLikes == 0 {
                let alert = UIAlertController(title: "Oops!", message: "You have reached your daily limit of Likes. Please upgrade to enjoy unlimited Likes.")
                self.present(alert, animated: true, completion: nil)
                return
            }
            

        }, { (error) in
            
            self.hideHUD()
            self.showToast(error)
        })
        
    }
    
    fileprivate func addBoostUser() {
        
        showHUD()
        
        NetworkManager.Discover.boostProfile { (message) in
            self.hideHUD()
            let alert = UIAlertController(title: "Success!!!", message: message)
            self.present(alert, animated: true, completion: nil)
        } _: { (error) in
            self.hideHUD()
            self.showToast(error)
        }
        
    }
    
    fileprivate func setupNoProfileView() {
        bottomStack.isHidden = self.arrUser.count == 0
        imgNoProfile.isHidden = arrUser.count != 0
        kolodaView.isHidden = arrUser.count == 0
    }
    
    
}



extension DiscoverVC {
    
    @IBAction func onLikeBtnTap(_ sender: UIButton) {
        guard arrUser.count > 0 else { return }
        if AppSupport.isLikeLimited && AppSupport.remainingLikes == 0 {
            let vc = UpgradeVC.instantiate(fromAppStoryboard: .Upgrade)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            return
        }
        kolodaView?.swipe(.right)
    }
    
    @IBAction func onDisLikeBtnTap(_ sender: UIButton) {
        guard arrUser.count > 0 else { return }
        kolodaView?.swipe(.left)
    }
    
    @IBAction func onRewindBtnTap(_ sender: UIButton) {
        
        guard isPurchase else {
            let vc = UpgradeVC.instantiate(fromAppStoryboard: .Upgrade)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            return
        }
        
        guard arrRewind.count > 0 else {
            showToast("No result found")
            return
        }
        self.kolodaView?.revertAction()
    }
    
    @IBAction func onSuperLikeBtnTap(_ sender: UIButton) {
        guard arrUser.count > 0 else { return }
        
        if AppSupport.remainingSuperLikes == 0 {
            let vc = SuperLikeAddVC.instantiate(fromAppStoryboard: .Upgrade)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            return
        }
        kolodaView?.swipe(.up)
    }
    
//    @objc fileprivate func onRewindBtnTap(_ sender: UIButton) {
//        self.kolodaView?.revertAction()
//    }
    
    @IBAction func onBoostBtnTap(_ sender: UIButton) {
        if AppSupport.remainingBoost == 0 {
            let vc = UpgradeVC.instantiate(fromAppStoryboard: .Upgrade)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            return
        }
        AppSupport.remainingBoost -= 1
        addBoostUser()
    }
    
    @IBAction func onProfileLikedBtnTap(_ sender: UIButton) {
        let vc = MatchUserVC.instantiate(fromAppStoryboard: .Discover)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        nvc.modalTransitionStyle = .crossDissolve
        nvc.isNavigationBarHidden = true
        self.present(nvc, animated: true, completion: nil)
    }
    
    @IBAction func onFilterBtnTap(_ sender: UIButton) {
        let vc = FilterTVC.instantiate(fromAppStoryboard: .Discover)
        vc.onFilter = {
            self.getUserList()
        }
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
        return [.left, .right, .up]
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        let vc = UserDetailsTVC.instantiate(fromAppStoryboard: .Discover)
        vc.user = arrUser[index]
        vc.onLikeUser = {
            koloda.swipe(.right)
        }
        
        vc.onDisLikeUser = {
            koloda.swipe(.left)
        }
        
        vc.onSuperLikeUser = {
            koloda.swipe(.up)
//            self.swipeUser(userID: self.arrUser[index].id, status: .superLike)
        }
        
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        nvc.modalTransitionStyle = .crossDissolve
        self.present(nvc, animated: true, completion: nil)
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        print(direction)
        arrRewind.append(arrUser[index])
//        return
        switch direction {
            case .right:
                if AppSupport.isLikeLimited && AppSupport.remainingLikes == 0 {
                    let vc = UpgradeVC.instantiate(fromAppStoryboard: .Upgrade)
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                    return
                }
                
                AppSupport.remainingLikes -= 1
                self.swipeUser(userID: arrUser[index].id, status: .like)
            case .left:
                self.swipeUser(userID: arrUser[index].id, status: .nope)
            case .up:
                if AppSupport.remainingSuperLikes == 0 {
                    let vc = SuperLikeAddVC.instantiate(fromAppStoryboard: .Upgrade)
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true, completion: nil)
                    return
                }
                AppSupport.remainingSuperLikes -= 1
                self.swipeUser(userID: arrUser[index].id, status: .superLike)
            default:
                break
        }
    }
    
    func koloda(_ koloda: KolodaView, didRewindTo index: Int) {
        if arrRewind.count > index {
//            print(arrRewind[index].id)
            self.swipeUser(userID: arrRewind[index].id, status: .rewind)
            arrRewind.remove(at: index)
        }
    }
    
    
    
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
        userView.imgSuperLike.isHidden = !user.isSuperLike
        userView.lblInfo.text = "\(user.nickName)" + ", " + "\(user.age)"
        //userView.btnRewind.tag = index
        //userView.btnRewind.addTarget(self, action: #selector(self.onRewindBtnTap(_:)), for: .touchUpInside)
        if let url = URL(string: user.arrImage.first ?? "") {
            userView.imgUser.kf.setImage(with: url)
        }
        if let url = URL(string: user.sunSignId.getActiveSignIconURL) {
            userView.imgSign.kf.setImage(with: url)
        }
        
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
