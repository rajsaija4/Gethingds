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
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     
        setupSubViewControllers()
     
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
        pagingViewController.didMove(toParent: self)
      
        
    }

    
    
    
    
    
}

  

