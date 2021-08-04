//
//  UserDetailsTVC.swift
//  Zodi
//
//  Created by AK on 15/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVKit
import TagListView
import CHIPageControl

class UserDetailsTVC: UITableViewController, TagListViewDelegate {
    
    //MARK:- VARIABLE
    @IBOutlet weak var pageControl: CHIPageControlJaloro!
    @IBOutlet weak var viewAdolescent: UIView!
    //    @IBOutlet var mainKidsTag: [UIStackView]!
    @IBOutlet var kidMainStack: [UIStackView]!
//    @IBOutlet weak var btnReviewLater: UIButton!
    @IBOutlet var kidView: [UIView]!
    @IBOutlet var kidsStack: [UIStackView]!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lbluserName: UILabel!
    @IBOutlet weak var txtAbout: UITextView!
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet var btnChild: [UIButton]!
    @IBOutlet weak var collectionUserdetails: UICollectionView! {
        didSet {
            collectionUserdetails.registerCell(ProfilePhotoCollectionCell.self)
            collectionUserdetails.delegate = self
            collectionUserdetails.dataSource = self
        }
    }
 
    @IBOutlet weak var tagListView: TagListView!
    
//    var onLikeUser: (() -> Void)?
//    var onReviewLater: (() -> Void)?
//    var onDisLikeUser: (() -> Void)?
    var collImage:[String] = []
    var infant = 0
    var arrTags:[TagList] = []
    var arrPassion:[String] = []
    var isfromWhoLikedMe:Bool = false
    var newborn = 0
    var toddler = 0
    var preschooler = 0
    var schoolagechild = 0
    var adolescent = 0
    var user: UserProfile = UserProfile(JSON.null)
    var isFromNotification = false
    var isFromProfile = false
    var userId = 0
//    fileprivate var arrInstaMedia: [InstaMedia] = []
    
    //MARK:- OUTLET
    
//    @IBOutlet weak var lblInstgramCount: UILabel!
   
//    @IBOutlet weak var collectionInsta: UICollectionView!{
//        didSet{
//            collectionInsta.registerCell(InstaCollectionCell.self)
//            collectionInsta.delegate = self
//            collectionInsta.dataSource = self
//        }
//    }
//    @IBOutlet fileprivate var arrImgView: [UIImageView]!
//    @IBOutlet fileprivate var arrImgSignView: [UIImageView]!
//    @IBOutlet fileprivate var arrLblSignName: [UILabel]!
//    @IBOutlet fileprivate weak var lblAge: UILabel!
//    @IBOutlet fileprivate weak var lblHeight: UILabel!
//    @IBOutlet fileprivate weak var lblLocation: UILabel!
//    @IBOutlet fileprivate weak var lblUserDetails: UILabel!
//    @IBOutlet fileprivate weak var lblUserInfo: UILabel!
   
    
    
    //MARK:- LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        userId = user.id
        self.navigationController?.navigationBar.isHidden = true
        let angle = CGFloat.pi/2
                pageControl.transform = CGAffineTransform(rotationAngle: angle)
                
                pageControl.numberOfPages = 6
                
                
                pageControl.progress = 3

        tagListView.delegate = self
        tagListView.textFont = AppFonts.Poppins_Medium.withSize(17)
        tagListView.alignment = .leading
       
    
        
        if isFromNotification || isFromProfile{
//            getUserDetails()
        } else {
            setupUI()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @IBAction func onPressbackbtn(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDislikeBtnTap(_ sender: UIButton) {
        if self.isFromNotification {
            swipeUser(userID: userId, status: .nope)
            return
        }
        swipeUser(userID: userId, status: .nope)
//        onDisLikeUser?()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onLikeBtnTap(_ sender: UIButton) {
        if self.isFromNotification {
            swipeUser(userID: userId, status: .like)
            return
        }
        if AppSupport.isLikeLimited == "yes" && AppSupport.remainingLikes == 0 {
            let vc = UpdateNowVC.instantiate(fromAppStoryboard: .Upgrade)
            vc.header = "OOPS!!"
            vc.message = "You have run out of your likes limit. Buy new likes now."
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
//            vc.onreloadColl = {
//                self.setupUI()
//            }
            self.present(vc, animated: true, completion: nil)
            return
        }
        swipeUser(userID: userId, status: .like)
        AppSupport.remainingLikes -= 1
//        onLikeUser?()
        if isfromWhoLikedMe == false {
        self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onSuperLikeBtnTap(_ sender: UIButton) {
        if self.isFromNotification {
            swipeUser(userID: userId, status: .reviewLater)
            return
        }
        if AppSupport.isLikeLimited == "yes" && AppSupport.remainingLikes == 0 {
            let vc = UpdateNowVC.instantiate(fromAppStoryboard: .Upgrade)
            vc.header = "OOPS!!"
            vc.message = "You have exhausted your review limit. Buy more credits."
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
//            vc.onreloadColl = {
//                self.setupUI()
//            }
            self.present(vc, animated: true, completion: nil)
            return
        }

     
        swipeUser(userID: userId, status: .reviewLater)
//        onReviewLater?()
        AppSupport.reviewLater -= 1
        self.dismiss(animated: true, completion: nil)
    }
    
//    @objc fileprivate func onReportBtnTap() {
//
//        let alert = UIAlertController(title: "Report User", message: "Do you want to report this user?", actionNames: ["Report"]) { (action) in
//            guard let actionName = action.title else { return }
//            let vc = ReportVC.instantiate(fromAppStoryboard: .Report)
//            vc.modalPresentationStyle = .overCurrentContext
//            vc.reportType = actionName
//            vc.selectedUserId = self.user.id
//            self.present(vc, animated: true, completion: nil)
//        }
//
//        self.present(alert, animated: true, completion: nil)
//
//    }
   
}

extension UserDetailsTVC {
    
    fileprivate func setupUI() {
        getPassion()
        collImage.append(user.image1)
        collImage.append(user.image2)
        collImage.append(user.image3)
        collImage.append(user.image4)
        collImage.append(user.image5)
        collImage.append(user.image6)
        
        lblWork.text = user.jobTitle
        print(user.userKids)
        for kids in user.userKids {
            if kids == "New born" {
                newborn += 1
            }
            else if kids == "Infrant" {
                infant += 1
            }
            else if kids == "Toddler" {
                toddler += 1
            }
            else if kids == "Preschooler" {
                preschooler += 1
            }
            else if kids == "School-aged Child" {
                schoolagechild += 1
            }
            else  if kids == "Adolescent" {
                adolescent += 1
            }
        }
       
        btnChild[0].setTitle("\(newborn)", for: .normal)
        btnChild[1].setTitle("\(infant)", for: .normal)
        btnChild[2].setTitle("\(toddler)", for: .normal)
        btnChild[3].setTitle("\(preschooler)", for: .normal)
        btnChild[4].setTitle("\(schoolagechild)", for: .normal)
        btnChild[5].setTitle("\(adolescent)", for: .normal)
        if newborn == 0 {
            kidView[0].isHidden = true
        }
        if infant == 0 {
            kidView[1].isHidden = true
        }
       
        if toddler == 0 {
            kidView[2].isHidden = true
        }
       
        if preschooler == 0 {
            kidView[3].isHidden = true
        }
       
        if schoolagechild == 0 {
            kidView[4].isHidden = true
        }
       
        if adolescent == 0 {
            kidView[5].isHidden = true
        }
       
        if newborn == 0 && infant == 0 && toddler == 0 {
            kidMainStack[0].isHidden = true
        }
        if preschooler == 0 && schoolagechild == 0 {
            kidMainStack[1].isHidden = true
        }
        if adolescent == 0 {
            viewAdolescent.isHidden = true
            
        }
       
        txtAbout.text = "\(user.about)"
        txtAbout.isEditable = false
       
        if user.userSetting.showmyAge == 1{
        lbluserName.text = "\(user.firstName)" + ", " + "\(user.age)"
        }
        else {
            lbluserName.text = "\(user.firstName)"
        }
        if user.userSetting.distanceVisible == 1{
        lblAddress.text = "\(user.distance)" + ", " + "\(user.address)"
        }
        else {
        lblAddress.text = "\(user.address)"
        }
        
       
//        for i in user.userKids {
//        }
//        for (i, image) in user.arrImage.enumerated() {
//            if let url = URL(string: image) {
//                self.arrImgView[i].kf.setImage(with: url)
//            }
//        }
        
//        lblUserInfo.text = user.firstName + " " + user.lastName


//        let feet = (Int(user.userHeight) ?? 0) / 12
//        let inches = (Int(user.userHeight) ?? 0) % 12
        
//        let userHeight = "\(feet)'\(inches)''"
        
        
//        lblHeight.text = userHeight
//        lblAge.text = "\(user.age)"
//        lblLocation.text = user.address
//
//        lblUserDetails.text = user.about
       
        
//        arrImgSignView[0].setImage(user.sunSignId.getActiveSignURL)
//        arrImgSignView[1].setImage(user.moonSignId.getActiveSignURL)
//        arrImgSignView[2].setImage(user.risingSignId.getActiveSignURL)
//
//
//        arrLblSignName[0].text = user.sunSignId.signName
//        arrLblSignName[1].text = user.moonSignId.signName
//        arrLblSignName[2].text = user.risingSignId.signName
        
        self.collectionUserdetails.reloadData()
        self.tableView.reloadData()
        
//        arrImgView[0].addGradientLayer()
        
    }
}


extension UserDetailsTVC {
    
//    fileprivate func getUserDetails() {
//
//        showHUD()
//
//        let param = ["user_id": userId]
//
//        NetworkManager.Profile.getOtherUserProfile(param: param, { (userProfile) in
//            self.hideHUD()
//            self.user = userProfile
//            self.setupUI()
//        }, { (error) in
//            self.hideHUD()
//            self.showToast(error)
//        })
//    }
    
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
                vc.header = "OOPS!!"
                vc.message = "You have run out of your likes limit. Buy new likes now."
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
//                vc.onreloadColl = {
//                    self.setupUI()
//                }
                self.present(vc, animated: true, completion: nil)
                return

            }
            

        }, { (error) in
            
            self.hideHUD()
            self.showToast(error)
        })
        
    }
    
}



extension UserDetailsTVC {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = SCREEN_WIDTH - 40
        let height = width * 16/11
        
        switch indexPath.section {
            case 0:
                return 500
            case 1:
                return 148
                
            case 2:
            return 60
            
//            case 3:
//                
//                return 200
//                if mainKidsTag[0].isHidden == true && mainKidsTag[1].isHidden == true && mainKidsTag[2].isHidden == true {
//                    return 50
//                }
//
//                else if mainKidsTag[0].isHidden || true && mainKidsTag[1].isHidden || true && mainKidsTag[2].isHidden || true {
//                    return 155
//                }
//
//                else {
//                    return 200
//                }
            
            case 4:
              
                return  CGFloat(tagListView.subviews.count * 48) + 56
                
                
            case 5:
                return  80

            default:
                return UITableView.automaticDimension
        }
    }
}


extension UserDetailsTVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collImage.count
//        return arrInstaMedia.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfilePhotoCollectionCell", for: indexPath) as! ProfilePhotoCollectionCell
        cell.setImage(string: collImage[indexPath.row])
//        cell.imgProfiles.kf.setImage(with: URL(string: collImage[indexPath.row]))
        cell.cornerRadius = 9
        cell.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.progress = Double(indexPath.row)
    }
}



extension UserDetailsTVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let width = (view.frame.width - 20)
        return CGSize(width: collectionUserdetails.bounds.width, height: collectionUserdetails.bounds.height)
    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}



//extension UserDetailsTVC: UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let vc: InstagramFeedVC = InstagramFeedVC.instantiate(fromAppStoryboard: .Discover)
//        vc.arrInstaMedia = arrInstaMedia
//        vc.indexPath = indexPath
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
//
//        /*
//        if arrInstaMedia[indexPath.row].mediaType == MediaType.CAROUSEL_ALBUM.rawValue {
//            let vc: InstagramFeedVC = InstagramFeedVC.instantiate(fromAppStoryboard: .Discover)
//            vc.arrInstaMedia = arrInstaMedia[indexPath.row].arrChildren
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true, completion: nil)
//            return
//        } else if arrInstaMedia[indexPath.row].mediaType == MediaType.VIDEO.rawValue {
//            guard let videoURL = URL(string: arrInstaMedia[indexPath.row].mediaURL) else { return }
//            let player = AVPlayer(url: videoURL)
//            let playerViewController = AVPlayerViewController()
//            playerViewController.player = player
//            self.present(playerViewController, animated: true) {
//                playerViewController.player?.play()
//            }
//            return
//        } else {
//            let vc: InstagramFeedVC = InstagramFeedVC.instantiate(fromAppStoryboard: .Discover)
//            vc.arrInstaMedia = arrInstaMedia
//            vc.indexPath = indexPath
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true, completion: nil)
//        }
//        */
//    }
//}



extension UserDetailsTVC {
    
    @objc fileprivate func onBackBtnTap() {
//        onReviewLater?()
        self.dismiss(animated: true, completion: nil)
    }
}


extension UserDetailsTVC {
    
    func showAlert(_ alert: String) {
        let alert = UIAlertController(title: "Oops!", message: alert)
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func getPassion() {
         showHUD()
         NetworkManager.getPassion { (PassionSetting) in
             self.arrTags.append(contentsOf: PassionSetting.passion)
             print(self.arrTags)
            self.arrPassion.removeAll()
            for id in self.user.passion {
                if let pas = self.arrTags.first(where: {$0.id == Int(id)})?.passion {
                    self.arrPassion.append(pas)
                }
                
            }
            for pas in self.arrPassion {
                self.tagListView.addTag(pas)
                
            }
            self.tableView.reloadData()
             self.hideHUD()
         } _: { (error) in
             self.hideHUD()
             self.showToast(error)
         }
       
     }
    
    
    
}
