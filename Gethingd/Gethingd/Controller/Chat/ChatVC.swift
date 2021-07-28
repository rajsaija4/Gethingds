//
//  ChatVC.swift
//  Zodi
//
//  Created by AK on 10/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    
    
    //MARK:- VARIABLE
    fileprivate var arrFreshMatches: [Conversation] = []
    fileprivate var arrAstroLike: [Conversation] = []
    fileprivate var arrMatchesMessage: [Conversation] = []
    
    //MARK:- OUTLET
    @IBOutlet weak var viewAstroLike: UIView!
    @IBOutlet weak var viewFreshMatch: UIView!
    @IBOutlet weak var lblNoChat: UILabel!
    @IBOutlet weak var collectionAstroLikes: UICollectionView!{
        didSet{
            collectionAstroLikes.registerCell(FreshMatchesCell.self)
        }
    }
    @IBOutlet weak var collectionFreshMatch: UICollectionView!{
        didSet{
            collectionFreshMatch.registerCell(FreshMatchesCell.self)
        }
    }
    @IBOutlet weak var tblChat: UITableView!{
        didSet {
            tblChat.register(UserChatCell.self)
        }
    }
    
    //MARK:- LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    


}



extension ChatVC {
    
    fileprivate func setupUI() {
        setupNavigationBar()
        
    }
    
    fileprivate func setupNavigationBar() {
        setupNavigationBarBackBtn()
        navigationController?.addBackButtonWithTitle(title: "Chat")
    }
}



extension ChatVC {
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
//            self.tblChat.reloadData()
//            self.collectionFreshMatch.reloadData()
//            self.collectionAstroLikes.reloadData()
//            
//            
//            self.tabBarController?.tabBar.items?.last?.badgeValue = conversation.unReadCount > 0 ? "\(conversation.unReadCount)" : nil
//            
//            self.viewAstroLike.isHidden = self.arrAstroLike.count == 0
//            self.viewFreshMatch.isHidden = self.arrFreshMatches.count == 0
//            self.lblNoChat.isHidden = (self.arrMatchesMessage.count != 0 || self.arrFreshMatches.count != 0 || self.arrAstroLike.count != 0)
//            
//        } _: { (error) in
//            self.lblNoChat.isHidden = (self.arrMatchesMessage.count != 0 || self.arrFreshMatches.count != 0 || self.arrAstroLike.count != 0)
//            self.hideHUD()
//            self.showToast(error)
//        }
//    }
    
}



extension ChatVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMatchesMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserChatCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
//        cell.setupCell(user: arrMatchesMessage[indexPath.row])
        return cell
    }
}



extension ChatVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = MessageVC.instantiate(fromAppStoryboard: .Chat)
        vc.hidesBottomBarWhenPushed = true
        vc.onPopView = { [weak self] in
            self?.setupNavigationBar()
//            self?.getConversation()
        }
//        vc.conversation = arrMatchesMessage[indexPath.row]
        vc.userImage = arrMatchesMessage[indexPath.row].userImage
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    

    
}



extension ChatVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionAstroLikes {
            return arrAstroLike.count
        }
        return arrFreshMatches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionAstroLikes {
            let cell: FreshMatchesCell = collectionView.dequequReusableCell(for: indexPath)
            cell.setupCell(user: arrAstroLike[indexPath.item])
            return cell
        }
        let cell: FreshMatchesCell = collectionView.dequequReusableCell(for: indexPath)
        cell.setupCell(user: arrFreshMatches[indexPath.item])
        return cell
    }
}



extension ChatVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionAstroLikes {
            let vc = UserDetailsTVC.instantiate(fromAppStoryboard: .Discover)
            vc.isFromNotification = true
            vc.userId = arrAstroLike[indexPath.row].userId
            let nvc = UINavigationController(rootViewController: vc)
            nvc.isNavigationBarHidden = false
            APPDEL?.window?.rootViewController = nvc
            APPDEL?.window?.makeKeyAndVisible()
            return
        }
        let vc = MessageVC.instantiate(fromAppStoryboard: .Chat)
        vc.hidesBottomBarWhenPushed = true
        vc.onPopView = { [weak self] in
            self?.setupNavigationBar()
//            self?.getConversation()
        }
//        vc.conversation = arrFreshMatches[indexPath.item]
        vc.userImage = arrFreshMatches[indexPath.item].userImage
        
//        vc.userImageURL = arrFreshMatches[indexPath.item]
        navigationController?.pushViewController(vc, animated: false)
    }
}



extension ChatVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height
        return CGSize(width: height * 0.8, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
