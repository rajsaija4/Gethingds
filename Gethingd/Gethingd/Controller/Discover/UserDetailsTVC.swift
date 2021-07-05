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

class UserDetailsTVC: UITableViewController, TagListViewDelegate {
    
    //MARK:- VARIABLE
    @IBOutlet weak var tagListView: TagListView!
    
    var onLikeUser: (() -> Void)?
    var onSuperLikeUser: (() -> Void)?
    var onDisLikeUser: (() -> Void)?
    
    var user: UserProfile = UserProfile(JSON.null)
    var isFromNotification = false
    var isFromProfile = false
    var userId = 0
    fileprivate var arrInstaMedia: [InstaMedia] = []
    
    //MARK:- OUTLET
    
    @IBOutlet weak var lblInstgramCount: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionInsta: UICollectionView!{
        didSet{
            collectionInsta.registerCell(InstaCollectionCell.self)
            collectionInsta.delegate = self
            collectionInsta.dataSource = self
        }
    }
    @IBOutlet fileprivate var arrImgView: [UIImageView]!
    @IBOutlet fileprivate var arrImgSignView: [UIImageView]!
    @IBOutlet fileprivate var arrLblSignName: [UILabel]!
    @IBOutlet fileprivate weak var lblAge: UILabel!
    @IBOutlet fileprivate weak var lblHeight: UILabel!
    @IBOutlet fileprivate weak var lblLocation: UILabel!
    @IBOutlet fileprivate weak var lblUserDetails: UILabel!
    @IBOutlet fileprivate weak var lblUserInfo: UILabel!
   
    
    
    //MARK:- LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagListView.delegate = self
        tagListView.textFont = AppFonts.Poppins_Medium.withSize(17)
        tagListView.alignment = .leading
        tagListView.addTags(["Biking","Walking","Beauty","Golf","German Hip"])
        navigationController?.addBackButtonWithTitle(title: "User Profile", action: #selector(self.onBackBtnTap))
        navigationController?.addBackButtonWithTitle(title: "User Profile", action: #selector(self.onBackBtnTap), reportAction: #selector(self.onReportBtnTap))
        
        if isFromNotification || isFromProfile{
            getUserDetails()
        } else {
            setupUI()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    @IBAction func onDislikeBtnTap(_ sender: UIButton) {
        if self.isFromNotification {
            swipeUser(userID: userId, status: .nope)
            return
        }
        onDisLikeUser?()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onLikeBtnTap(_ sender: UIButton) {
        if self.isFromNotification {
            swipeUser(userID: userId, status: .like)
            return
        }
        onLikeUser?()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func onSuperLikeBtnTap(_ sender: UIButton) {
        if self.isFromNotification {
            swipeUser(userID: userId, status: .superLike)
            return
        }
        onSuperLikeUser?()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func onReportBtnTap() {
        
        let alert = UIAlertController(title: "Report User", message: "Do you want to report this user?", actionNames: ["Report"]) { (action) in
            guard let actionName = action.title else { return }
            let vc = ReportVC.instantiate(fromAppStoryboard: .Report)
            vc.modalPresentationStyle = .overCurrentContext
            vc.reportType = actionName
            vc.selectedUserId = self.user.id
            self.present(vc, animated: true, completion: nil)
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
   
}

extension UserDetailsTVC {
    
    fileprivate func setupUI() {
        
        
        
        for (i, image) in user.arrImage.enumerated() {
            if let url = URL(string: image) {
                self.arrImgView[i].kf.setImage(with: url)
            }
        }
        
//        lblUserInfo.text = user.firstName + " " + user.lastName


        let feet = (Int(user.userHeight) ?? 0) / 12
        let inches = (Int(user.userHeight) ?? 0) % 12
        
        let userHeight = "\(feet)'\(inches)''"
        
        
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
        
        tableView.reloadData()
        
//        arrImgView[0].addGradientLayer()
        
    }
}


extension UserDetailsTVC {
    
    fileprivate func getUserDetails() {
        
        showHUD()
        
        let param = ["user_id": userId]
        
        NetworkManager.Profile.getOtherUserProfile(param: param, { (userProfile) in
            self.hideHUD()
            self.user = userProfile
            self.setupUI()
        }, { (error) in
            self.hideHUD()
            self.showToast(error)
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
                return
            }
            if self.isFromNotification {
                APPDEL?.setupMainTabBarController()
                return
            }
            
        }, { (error) in
            self.hideHUD()
            self.showAlert(error)
        })
        
    }
    
}


/*
extension UserDetailsTVC {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = SCREEN_WIDTH - 40
        let height = width * 16/11
        
        switch indexPath.section {
            case 0:
                return height
            case 2:
                return user.arrImage.count > 1 ? height : 0
            case 4:
                return user.arrImage.count > 2 ? height : 0
            case 6:
                return user.arrImage.count > 3 ? height : 0
            case 8:
                return user.arrImage.count > 4 ? height : 0
            case 1:
                return 150
            case 5:
//                if user.moonSignId == "0", user.risingSignId == "0" {
//                    return 0
//                }
                return 150
            case 7:
                return user.instaToken.count == 0 ? 0 : 300
            case 9:
                return user.isButtonHide ? 0 : 80
            default:
                return UITableView.automaticDimension
        }
    }
}

*/

extension UserDetailsTVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrInstaMedia.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: InstaCollectionCell = collectionView.dequequReusableCell(for: indexPath)
        cell.setupInstaMedia(media: arrInstaMedia[indexPath.row])
        cell.cornerRadius = 9
        cell.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = Int(indexPath.row / 6)
    }
}



extension UserDetailsTVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.width - 20) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}



extension UserDetailsTVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc: InstagramFeedVC = InstagramFeedVC.instantiate(fromAppStoryboard: .Discover)
        vc.arrInstaMedia = arrInstaMedia
        vc.indexPath = indexPath
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)

        /*
        if arrInstaMedia[indexPath.row].mediaType == MediaType.CAROUSEL_ALBUM.rawValue {
            let vc: InstagramFeedVC = InstagramFeedVC.instantiate(fromAppStoryboard: .Discover)
            vc.arrInstaMedia = arrInstaMedia[indexPath.row].arrChildren
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            return
        } else if arrInstaMedia[indexPath.row].mediaType == MediaType.VIDEO.rawValue {
            guard let videoURL = URL(string: arrInstaMedia[indexPath.row].mediaURL) else { return }
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player?.play()
            }
            return
        } else {
            let vc: InstagramFeedVC = InstagramFeedVC.instantiate(fromAppStoryboard: .Discover)
            vc.arrInstaMedia = arrInstaMedia
            vc.indexPath = indexPath
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        */
    }
}



extension UserDetailsTVC {
    
    @objc fileprivate func onBackBtnTap() {
        if isFromNotification {
            APPDEL?.setupMainTabBarController()
            return
        }
        self.dismiss(animated: true, completion: nil)
    }
}


extension UserDetailsTVC {
    
    func showAlert(_ alert: String) {
        let alert = UIAlertController(title: "Oops!", message: alert)
        self.present(alert, animated: true, completion: nil)
    }
}
