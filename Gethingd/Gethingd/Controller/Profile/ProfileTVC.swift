//
//  ProfileTVC.swift
//  Zodi
//
//  Created by AK on 11/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleSignIn
import Kingfisher

class ProfileTVC: UITableViewController {

    //MARK:- VARIABLE
    fileprivate var isGalaxyPassOpen = false
    fileprivate var isActiveAccount = true
    fileprivate var isAccountTabOpen = false
    fileprivate var stackGalaxyPassBottomConstrain: NSLayoutConstraint!
    fileprivate var arrPassLocation: [PassLocation] = []
    
    //MARK:- OUTLET
    @IBOutlet var arrLocationCloseBtn: [UIButton]!
    @IBOutlet var arrLocationPinBtn: [UIButton]!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var btnAccountDropDown: UIButton!
    @IBOutlet var arrLocationStack: [UIStackView]!
    @IBOutlet weak var stackAddNewLocation: UIStackView!
    @IBOutlet var arrLocationName: [UIButton]!
    @IBOutlet weak var btnDropDownConstrain: NSLayoutConstraint!
    @IBOutlet weak var lblFreelike: UILabel!
    @IBOutlet weak var lblReviewLater: UILabel!
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var lblPremium: UILabel!
    @IBOutlet weak var imgPause: UIImageView!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var stackPause: UIStackView!
    @IBOutlet weak var stackDelete: UIStackView!
    @IBOutlet weak var btnAccountDropDownWidth: NSLayoutConstraint!
    @IBOutlet weak var btnResume: UIButton!
    
    //MARK:- LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onRecieveCustom(_:)), name: .recieveCustom, object: nil)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    @objc func onRecieveCustom(_ notifications:NSNotification){
     let vc = NotificationVC.instantiate(fromAppStoryboard: .Notification)
     vc.modalPresentationStyle = .fullScreen
     vc.modalTransitionStyle = .flipHorizontal
     vc.present(vc, animated: true, completion: nil)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .recieveCustom, object: nil)

    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblName.text = User.details.firstName
        lblAddress.text = User.details.address
        if AppSupport.isOrder == "no" {
        lblFreelike.text = "FREE LIKES : \(AppSupport.remainingLikes)"
        lblReviewLater.text = "REVIEW LATER : \(AppSupport.reviewLater)"
        }
        if AppSupport.isOrder == "yes" {
            lblFreelike.text = "FREE LIKES : UNLIMITED"
            lblReviewLater.text = "REVIEW LATER : UNLIMITED"
        }
        
//        if let url = URL(string: User.details.image1) {
//            self.imgUser.kf.setImage(with: url)
//        }
        if let imageUrl = URL(string: User.details.image1) {
        imgUser.kf.indicatorType = .activity
        imgUser.kf.indicator?.startAnimatingView()
            imgUser.kf.setImage(with: imageUrl, placeholder: UIImage(named: "img_profile"), options: nil, progressBlock: nil) { (_) in
            self.imgUser.kf.indicator?.stopAnimatingView()
        }
     }
//        setupDataUI()
//        getProfile()
        
    }

    //    @IBAction func onLocationCloseBtnTap(_ sender: UIButton) {
//        print(sender.tag)
//        deleteLocation(param: ["location_id": arrPassLocation[sender.tag].id])
//    }
//
//    @IBAction func onLocationBtnTap(_ sender: UIButton) {
//        setDefaultLocation(param: ["location_id": arrPassLocation[sender.tag].id])
//    }
//
//    @IBAction func onAddNewLocationTap(_ sender: UIControl) {
//
//        guard isPurchase else {
//            let vc = UpgradeVC.instantiate(fromAppStoryboard: .Upgrade)
//            vc.onPurchasePlan = {
//                self.setupDataUI()
//            }
//            vc.hidesBottomBarWhenPushed = true
//            navigationController?.pushViewController(vc, animated: false)
//            return
//        }
//
//
//        print("Add New Location")
//            let gmsACVC = GMSAutocompleteViewController()
//            gmsACVC.delegate = self
//            gmsACVC.modalPresentationStyle = .fullScreen
//            present(gmsACVC, animated: true, completion: nil)
//    }
//
//    @IBAction func onPauseAccountTap(_ sender: UIButton) {
//
//        let alert = UIAlertController(title: "Pause Account", message: "Are you sure you want to pause this account?", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
//
//        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
//            self.pauseProfile()
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    @IBAction func onDeleteAccountTap(_ sender: UIButton) {
//
//        let alert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete this account?", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
//
//        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
//            self.deleteProfile()
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    @IBAction func onResumeBtnTap(_ sender: UIButton) {
//        let alert = UIAlertController(title: "Resume Account", message: "Are you sure you want to resume this account?", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
//
//        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
//            self.resumeProfile()
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
}



//extension ProfileTVC {
//
//    fileprivate func setupDataUI() {
//        lblPremium.isHidden = isPurchase
//        isGalaxyPassOpen = false
//
//        lblAstroLike.text = "ASTRO LIKES : \(AppSupport.remainingSuperLikes)"
//        lblMoonBoosts.text = "MOON BOOSTS : \(AppSupport.remainingBoost)"
//
//        let user = User.details
//        if let imgURL = URL(string: user.arrImage.first ?? "") {
//            imgUser.kf.setImage(with: imgURL)
//        }
//        lblName.text = user.firstName + " " + user.lastName
//        lblAddress.text = user.address
//        getPassLocaions()
//
//    }
//
//    fileprivate func setupUI() {
//        navigationController?.isNavigationBarHidden = false
//
//        setupNavigationBar()
//
//        lblVersion.text = Bundle.main.releaseVersionNumberPretty
//        isGalaxyPassOpen = false
//        setupGalaxyPassCell()
//    }
//
//    fileprivate func setupAccountCell() {
//        btnPause.isHidden = !isActiveAccount
//        btnResume.isHidden = isActiveAccount
//        stackPause.alignment = isActiveAccount ? .top : .fill
//        imgPause.image = isActiveAccount ? UIImage(named: "img_pause") : UIImage(named: "img_resume")
//        tableView.reloadData()
//    }
//
//    fileprivate func setupGalaxyPassCell() {
//
//        let location = arrPassLocation.filter( { $0.isActive == true } ).first?.location ?? ""
//
//        if location == "Default Address" {
//            lblAddress.text = User.details.address
//        } else {
//            lblAddress.text = location
//        }
//
//
//        btnDropDown.setImage(UIImage(named: isGalaxyPassOpen ? "img_dropdown" : "img_next"), for: .normal)
////        stackAddNewLocation.isHidden = !isGalaxyPassOpen
//
//        if arrPassLocation.count == 6 {
//            stackAddNewLocation.isHidden = true
//        } else {
//            stackAddNewLocation.isHidden = !isGalaxyPassOpen
//        }
//
//
//
//        for stackLocation in arrLocationStack {
//            stackLocation.isHidden = true
//        }
//
//        if arrLocationStack.count >= arrPassLocation.count {
//
//            for i in 0..<arrPassLocation.count {
//                arrLocationStack[i].isHidden = !isGalaxyPassOpen
//                arrLocationName[i].setTitle(arrPassLocation[i].location, for: .normal)
//                if arrPassLocation[i].isActive {
//                    arrLocationName[i].setTitleColor(COLOR.App, for: .normal)
//                    arrLocationPinBtn[i].setImage(UIImage(named: "img_pin_app"), for: .normal)
//                    arrLocationCloseBtn[i].tintColor = COLOR.App
//                } else {
//                    arrLocationName[i].setTitleColor(.darkGray, for: .normal)
//                    arrLocationPinBtn[i].setImage(UIImage(named: "img_pin"), for: .normal)
//                    arrLocationCloseBtn[i].tintColor = .darkGray
//                }
//            }
//
//
//        }
//
//        btnDropDownConstrain.constant = isGalaxyPassOpen ? 16 : 10
//
//        tableView.reloadData()
//
//    }
//
//    fileprivate func setupNavigationBar() {
//        navigationController?.addBackButtonWithTitle(title: "Profile")
//    }
//}



extension ProfileTVC {
//
//    fileprivate func getProfile() {
//
//        NetworkManager.Profile.getMyProfile({ (profile) in
//            self.isActiveAccount = profile.isActiveAccount
//            self.setupAccountCell()
//        }) { (error) in
//            print(error)
//        }
//    }
//
//    fileprivate func insertLocation(param: [String: String]) {
//        showHUD()
//
//        NetworkManager.Location.insertLocation(param: param, { (locations) in
//            self.hideHUD()
//            self.arrPassLocation.removeAll()
//            self.arrPassLocation.append(contentsOf: locations)
//            self.setupGalaxyPassCell()
//        }, { (error) in
//            self.hideHUD()
//            self.showToast(error)
//        })
//    }
//
//    fileprivate func getPassLocaions() {
//        showHUD()
//
//        NetworkManager.Location.getLocation({ (locations) in
//            self.hideHUD()
//            self.arrPassLocation.removeAll()
//            self.arrPassLocation.append(contentsOf: locations)
//            self.setupGalaxyPassCell()
//        }, { (error) in
//            self.hideHUD()
//            self.showToast(error)
//        })
//    }
//
//    fileprivate func setDefaultLocation(param: [String: Int]) {
//        showHUD()
//
//        NetworkManager.Location.setDefaultLocation(param: param, { (locations) in
//            self.hideHUD()
//            self.arrPassLocation.removeAll()
//            self.arrPassLocation.append(contentsOf: locations)
//            self.setupGalaxyPassCell()
//        }, { (error) in
//            self.hideHUD()
//            self.showToast(error)
//        })
//    }
//
//    fileprivate func deleteLocation(param: [String: Int]) {
//        showHUD()
//
//        NetworkManager.Location.deleteLocation(param: param, { (locations) in
//            self.hideHUD()
//            self.arrPassLocation.removeAll()
//            self.arrPassLocation.append(contentsOf: locations)
//            self.setupGalaxyPassCell()
//        }, { (error) in
//            self.hideHUD()
//            self.showToast(error)
//        })
//    }
//
    fileprivate func logoutProfile() {

        showHUD()
        NetworkManager.Profile.logoutProfile { (message) in
            self.hideHUD()
            
            User.details.delete()
            UserDefaults.standard.removeObject(forKey: "btoken")
            
            APPDEL?.setupLogin()
        } _: { (error) in
            self.hideHUD()
            self.showToast(error)
        }
    }
//
//    fileprivate func deleteProfile() {
//
//        showHUD()
//        NetworkManager.Profile.deleteProfile { (message) in
//            self.hideHUD()
//            User.details.delete()
//            APPDEL?.setupLogin()
//        } _: { (error) in
//            self.hideHUD()
//            self.showToast(error)
//        }
//    }
//
//    fileprivate func pauseProfile() {
//
//        showHUD()
//        NetworkManager.Profile.pauseProfile { (message) in
//            self.hideHUD()
//            self.showRootToast("Pause Account")
//            self.getProfile()
//        } _: { (error) in
//            self.hideHUD()
//            self.showToast(error)
//        }
//    }
//
//    fileprivate func resumeProfile() {
//
//        showHUD()
//        NetworkManager.Profile.resumeProfile { (message) in
//            self.hideHUD()
//            self.showRootToast("Resume Account")
//            self.getProfile()
//        } _: { (error) in
//            self.hideHUD()
//            self.showToast(error)
//        }
//    }
//
}
//
//
extension ProfileTVC {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 {
            return 0
        }
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
            case 1:
                let vc = EditProfileVC.instantiate(fromAppStoryboard: .Profile)
                
                vc.hidesBottomBarWhenPushed = true
            
                self.navigationController?.pushViewController(vc, animated: true)
            break
            case 2:
                let vc = SettingVC.instantiate(fromAppStoryboard: .Setting)
                vc.hidesBottomBarWhenPushed = true
//                vc.userId = User.details.id
//                vc.isFromProfile = true
//                let nvc = UINavigationController(rootViewController: vc)
//                vc.modalPresentationStyle = .fullScreen
//                nvc.modalTransitionStyle = .crossDissolve
              self.navigationController?.pushViewController(vc, animated: true)
                break
                
        case 3:
            let vc = NotificationVC.instantiate(fromAppStoryboard: .Notification)
            vc.hidesBottomBarWhenPushed = true
//                vc.userId = User.details.id
//                vc.isFromProfile = true
//                let nvc = UINavigationController(rootViewController: vc)
//                vc.modalPresentationStyle = .fullScreen
//                nvc.modalTransitionStyle = .crossDissolve
          self.navigationController?.pushViewController(vc, animated: true)
            break
            
            case 4:
                let vc = SubscribeVC.instantiate(fromAppStoryboard: .Upgrade)
//                vc.onPopView = { [weak self] in
//                    self?.setupNavigationBar()
//                }
                vc.hidesBottomBarWhenPushed = true
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
            break
//            case 4:
//                guard isPurchase else {
//                    let vc = UpgradeVC.instantiate(fromAppStoryboard: .Upgrade)
//                    vc.onPurchasePlan = {
//                        self.setupDataUI()
//                    }
//                    vc.hidesBottomBarWhenPushed = true
//                    navigationController?.pushViewController(vc, animated: false)
//                    return
//                }
//                isGalaxyPassOpen = !isGalaxyPassOpen
//                setupGalaxyPassCell()
//            break
//            case 5:
//                let vc = UpgradeVC.instantiate(fromAppStoryboard: .Upgrade)
//                vc.onPurchasePlan = {
//                    self.setupDataUI()
//                }
//                vc.hidesBottomBarWhenPushed = true
//                navigationController?.pushViewController(vc, animated: false)
//                break
            case 5:
                let vc = ChangePasVC.instantiate(fromAppStoryboard: .Login)
                self.navigationController?.pushViewController(vc, animated: true)
            break
            case 6:
                let alert = UIAlertController(title: "Gethingd", message: "Are You Sure Want to Logout?", preferredStyle: UIAlertController.Style.alert)

                       // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: { _ in
                    guard let mainTVC = ((ROOTVC as? UINavigationController)?.viewControllers.first as? UITabBarController) else {
                        return
                    }
                    
                    guard let discoverVC = (mainTVC.viewControllers?[1] as? UINavigationController)?.viewControllers.first as? DiscoverVC else { return }
                    discoverVC.timer.invalidate()
                    
                    self.logoutProfile()
                }))
                       alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel, handler: nil))

                       // show the alert
                       self.present(alert, animated: true, completion: nil)
//                let vc = DiscoverVC.init()
//                vc.timer.invalidate()
                
                break
//            case 8:
//
//                isAccountTabOpen = !isAccountTabOpen
//
//                stackPause.isHidden = !isAccountTabOpen
//                stackDelete.isHidden = !isAccountTabOpen
//
//                btnAccountDropDown.setImage(UIImage(named: isAccountTabOpen ? "img_dropdown" : "img_next"), for: .normal)
//
//                btnAccountDropDownWidth.constant = isAccountTabOpen ? 16 : 10
//
//                tableView.reloadData()
//                break
            default:
            break
        }
    }
}
//
//
//
//extension ProfileTVC: GMSAutocompleteViewControllerDelegate {
//
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print(place.name)
//
//        let latitude = "\(place.coordinate.latitude)"
//        let longitude = "\(place.coordinate.longitude)"
//        var locationName = ""
//        var country = ""
//        var state = ""
//        var city = ""
//        var postalCode = ""
//
//        let placeName = place.name ?? ""
//        let address = place.formattedAddress ?? ""
//
//        var addArray:[String] = []
//        for component in place.addressComponents ?? [] {
//            if component.types.contains("locality") {
//                locationName = component.name
//            }
//            if component.types.contains("administrative_area_level_2") {
//                city = component.name
//                if city.count > 0 {
//                    addArray.append(city)
//                }
//            }
//            if component.types.contains("administrative_area_level_1") {
//                state = component.name
//                if state.count > 0 {
//                    addArray.append(state)
//                }
//            }
//            if component.types.contains("country") {
//                country = component.name
//            }
//            if component.types.contains("postal_code") {
//                postalCode = component.name
//            }
//        }
//
//        let addressString = addArray.joined(separator: ", ")
//        let param = [
//            "latitude": latitude,
//            "longitude": longitude,
//            "type": "insert",
//            "location": addressString,
//            "state": state,
//            "city": city
//        ]
//
//        dismiss(animated: true, completion: nil)
//        self.insertLocation(param: param)
//    }
//    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//        print("Error: ", error.localizedDescription)
//    }
//    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        dismiss(animated: true, completion: nil)
//    }
//}
//
//
//
//extension ProfileTVC {
//
//    func getAddressFromCenterCoordinate(centerCoordinate : CLLocationCoordinate2D){
//
//        var latitude = "\(centerCoordinate.latitude)"
//        var longitude = "\(centerCoordinate.longitude)"
//        var locationName = ""
//        var country = ""
//        var state = ""
//        var city = ""
//        var postalCode = ""
//
//        let location: CLLocation = CLLocation(latitude:centerCoordinate.latitude, longitude: centerCoordinate.longitude)
//
//
//        CLGeocoder().reverseGeocodeLocation(location, completionHandler:
//                                                {(placemarks, error) in
//                                                    if (error != nil)
//                                                    {
//                                                        print("reverse geodcode fail: \(error?.localizedDescription ?? "Error")")
//                                                    }
//                                                    guard let place = placemarks, place.count > 0 else {
//                                                        return
//
//                                                    }
//
//                                                    let pm = place[0]
//
//                                                    var addArray:[String] = []
////                                                    if let name = pm.name {
////                                                        addArray.append(name)
////                                                    }
//                                                    if let locality = pm.locality {
//                                                        addArray.append(locality)
//                                                        city = locality
//                                                    } else {
//                                                        addArray.append("")
//                                                        city = ""
//                                                    }
//
//                                                    if let administrativeArea = pm.administrativeArea {
//                                                        addArray.append(administrativeArea)
//                                                        state = administrativeArea
//                                                    }
//
//                                                    if let countryName = pm.country {
//                                                        addArray.append(countryName)
//                                                        country = countryName
//                                                    }
////                                                    if let postalCodeValue = pm.postalCode {
////                                                        addArray.append(postalCodeValue)
////                                                        postalCode = postalCodeValue
////                                                    }
//
//                                                    let addressString = addArray.joined(separator: ", ")
//                                                    locationName = addressString
//
//                                                    let param = [
//                                                        "latitude": latitude,
//                                                        "longitude": longitude,
//                                                        "type": "insert",
//                                                        "location": locationName,
//                                                        "country": country,
//                                                        "state": state,
//                                                        "city": city
//                                                    ]
//
//                                                    self.insertLocation(param: param)
//                                                })
//
//    }
//}


