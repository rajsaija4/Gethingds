//
//  MainchatVC.swift
//  Gethingd
//
//  Created by GT-Raj on 01/07/21.
//

import UIKit
import Parchment

class MainchatVC: UIViewController {

    @IBOutlet weak var contentView: UIView!
    var pagingViewController: PagingViewController!
    
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    //MARK:- VARIABLE
    fileprivate var arrFreshMatches: [Conversation] = []
    fileprivate var arrAstroLike: [Conversation] = []
    fileprivate var arrMatchesMessage: [Conversation] = []
    var isFromNotifications = false
    var isFromPushnotifications = false
    var selectedIndex  = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromNotifications {
            lblTitle.isHidden = true
            btnBack.isHidden = false
        }
        
        if isFromPushnotifications {
            lblTitle.isHidden = true
            btnBack.isHidden = false
        }
        
        setupSubViewControllers()
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .recieveMatch, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onRecieveLike(_:)), name: .recieveLike, object: nil)
            
        NotificationCenter.default.addObserver(self, selector: #selector(onRecieveMsg(_:)), name: .recieveMsg, object: nil)
        
    }
    
    @IBAction func onPressBackbtn(_ sender: Any) {
        if isFromPushnotifications {
            APPDEL?.setupMainTabBarController()
        }
        else {
        self.navigationController?.popViewController(animated: true)
        }
        
    }
    @objc func onDidReceiveData(_ notifications:NSNotification){
    let vc = MainchatVC.instantiate(fromAppStoryboard: .Chat)
    vc.modalPresentationStyle = .fullScreen
    vc.modalTransitionStyle = .flipHorizontal
    vc.present(vc, animated: true, completion: nil)
    
        
    }
    
    @objc func onRecieveLike(_ notifications:NSNotification){
     let vc = WholikedVC.instantiate(fromAppStoryboard: .Chat)
     vc.modalPresentationStyle = .fullScreen
     vc.modalTransitionStyle = .flipHorizontal
     vc.present(vc, animated: true, completion: nil)
     
         
     }
    
    @objc func onRecieveMsg(_ notifications:NSNotification){
     let vc = MatchesVC.instantiate(fromAppStoryboard: .Chat)
     vc.modalPresentationStyle = .fullScreen
     vc.modalTransitionStyle = .flipHorizontal
     vc.present(vc, animated: true, completion: nil)
     
         
     }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .recieveMatch, object: nil)
        NotificationCenter.default.removeObserver(self, name: .recieveLike, object: nil)
        NotificationCenter.default.removeObserver(self, name: .recieveMsg, object: nil)


    }
}


extension MainchatVC {
    
    fileprivate func setupSubViewControllers() {
        
        self.navigationController?.navigationBar.isHidden = true
        
//        title = "Chat"
        
//        navigationController?.navigationBar.isTranslucent = false
//
//            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
//            titleLabel.text = "Chat"
//            titleLabel.textColor = COLOR.App
//            titleLabel.font = UIFont.systemFont(ofSize: 20)
//            navigationItem.titleView = titleLabel
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: COLOR.App]
        
        let messageVC1 = MessageVC1.instantiate(fromAppStoryboard: .Chat)
        messageVC1.title = "Message"
        
        let matchesVC = MatchesVC.instantiate(fromAppStoryboard: .Chat)
        matchesVC.title = "Matches"
//        historyVC.onShowStatement = { isShowStatement in
//            historyVC.title = isShowStatement ? "STATEMENTS" : "HISTORY"
//        }
        let wholikedmeVC = WholikedVC.instantiate(fromAppStoryboard: .Chat)
        wholikedmeVC.title = "Who Liked"
//        wholikedmeVC.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "LeagueGothic-Regular", size: 30.0)]
        
      
        
        pagingViewController = PagingViewController(viewControllers: [messageVC1, matchesVC,wholikedmeVC])
        pagingViewController.font = AppFonts.Poppins_Medium.withSize(15)
        
        pagingViewController.selectedFont = AppFonts.Poppins_Medium.withSize(15)
        pagingViewController.menuItemSize = .sizeToFit(minWidth: 0, height: 50)
        pagingViewController.backgroundColor = .white
        pagingViewController.indicatorOptions = .visible(height: 1, zIndex: Int.max, spacing: .zero, insets: .init(top: 0, left: 8, bottom: 0, right: 8))
        pagingViewController.menuBackgroundColor = .white
        pagingViewController.selectedBackgroundColor = .white
        pagingViewController.indicatorColor = COLOR.App
        pagingViewController.textColor = .darkGray
        pagingViewController.selectedTextColor = COLOR.App
        addChild(pagingViewController)
        contentView.addSubview(pagingViewController.view)
        contentView.constrainToEdges(pagingViewController.view)
        pagingViewController.select(index: selectedIndex)
        pagingViewController.didMove(toParent: self)
      
        
    }

    
    
    
    
    
}


extension MainchatVC {
//    
//    func getConversation() {
//        
//        showHUD()
//        
//        NetworkManager.Chat.getMatchDetails { (conversation) in
//            self.hideHUD()
//            self.arrFreshMatches.removeAll()
//            self.arrAstroLike.removeAll()
//            self.arrMatchesMessage.removeAll()
//            self.arrFreshMatches.append(contentsOf: conversation.arrConversationNotStarted)
//            self.arrMatchesMessage.append(contentsOf: conversation.arrConversationStarted)
//            self.arrAstroLike.append(contentsOf: conversation.arrAstroLikeUser)
//   
//            self.tabBarController?.tabBar.items?.last?.badgeValue = conversation.unReadCount > 0 ? "\(conversation.unReadCount)" : nil
//         
//            
//        } _: { (error) in
//          
//            self.hideHUD()
//            self.showToast(error)
//        }
//    }
//    
}

  

