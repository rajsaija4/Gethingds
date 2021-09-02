//
//  MatchesVC.swift
//  Gethingd
//
//  Created by GT-Raj on 01/07/21.
//

import UIKit

class MatchesVC: UIViewController, UISearchBarDelegate {
    
    var arrMatchesList:[MatchConversation] = []
    var searchActive : Bool = false
    var filtered:[MatchConversation] = []
    var isFromNotification = false



    @IBOutlet weak var lblNomessageFound: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collMatches: UICollectionView!{
        didSet {
            collMatches.registerCell(FreshMatchesCell.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MessageVC1.dismissKeyboard))
//            view.addGestureRecognizer(tap)
//        getConversation()
        searchBar.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchActive = false
        getConversation()
//        collMatches.reloadData()
    }
  
    
    
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchActive = true;
        }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            searchActive = false;
        }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchActive = false;
        }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

            searchActive = false;
        }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count > 0 {
            filtered = arrMatchesList.filter({$0.name.contains(searchText)})
            searchActive = true
           self.collMatches.reloadData()
        }
        else {
            searchActive = false
            self.collMatches.reloadData()
        }
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


extension MatchesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(searchActive){
            return filtered.count
        }
        return arrMatchesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FreshMatchesCell", for: indexPath) as! FreshMatchesCell
        if(searchActive){
            cell.setupMatchesList(user: filtered[indexPath.row])
        }
        else {
        cell.setupMatchesList(user: arrMatchesList[indexPath.row])
        }
        return cell
        
    }
    
    
}

extension MatchesVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MessageVC.instantiate(fromAppStoryboard: .Chat)
        vc.hidesBottomBarWhenPushed = true
        vc.userImage = arrMatchesList[indexPath.row].userImage
        vc.hidesBottomBarWhenPushed = true
        vc.selectedUserId = arrMatchesList[indexPath.row].userId
        vc.oppositeUserName = arrMatchesList[indexPath.row].name
        vc.match_Id = arrMatchesList[indexPath.row].matchId
        (ROOTVC as? UINavigationController)?.pushViewController(vc, animated: true)
        
    }
    
    
}


extension MatchesVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 40) / 3
        let height = width / 0.7
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}


extension MatchesVC {
    func getConversation() {
    
            showHUD()
    
            NetworkManager.Chat.getMatchDetails { (conversation) in
               
                self.arrMatchesList.removeAll()
                for data in conversation.conversationNotStartedArray {
                    self.arrMatchesList.append(data)
                }
                if self.arrMatchesList.count > 0 {
                    self.searchBar.isHidden = false
                    self.lblNomessageFound.isHidden = true
                }
                self.collMatches.reloadData()
                self.hideHUD()
    
//                self.tabBarController?.tabBar.items?.last?.badgeValue = conversation.unReadCount > 0 ? "\(conversation.unReadCount)" : nil
    
    
            } _: { (error) in
    
                self.hideHUD()
                self.showToast(error)
            }
        }
    
}
