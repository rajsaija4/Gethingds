//
//  MessageVC1.swift
//  Gethingd
//
//  Created by GT-Raj on 01/07/21.
//

import UIKit

class MessageVC1: UIViewController, UISearchBarDelegate {
    
    var arrMessagesList:[ChatMessages] = []
    var searchActive : Bool = false
    var filtered:[ChatMessages] = []

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblChat: UITableView! {
        didSet {
            tblChat.register(UserChatCell.self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        getAllMessageList()
        searchBar.delegate = self
       

        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchActive = false
        getAllMessageList()
           
    }
   
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
            searchActive = false;
        }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count > 0 {
            filtered = arrMessagesList.filter({$0.userName.contains(searchText)})
            searchActive = true
           self.tblChat.reloadData()
        }
        else {
            searchActive = false
            self.tblChat.reloadData()
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
extension MessageVC1: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
                   return filtered.count
               }
        return arrMessagesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserChatCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if(searchActive){
            cell.setupCell(user: filtered[indexPath.row])
            
        }
        else {
        cell.setupCell(user: arrMessagesList[indexPath.row])
        }
        return cell
    }
}



extension MessageVC1: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = MessageVC.instantiate(fromAppStoryboard: .Chat)
        vc.hidesBottomBarWhenPushed = true
//        vc.onPopView = { [weak self] in
//            self?.getConversation()
//        }
//        vc.conversation = arrMatchesMessage[indexPath.row]
        vc.match_Id = arrMessagesList[indexPath.row].matchId
        vc.userImage = arrMessagesList[indexPath.row].userImage
        vc.oppositeUserName = arrMessagesList[indexPath.row].userName
        (ROOTVC as? UINavigationController)?.pushViewController(vc, animated: true)
//        self.parent?.navigationController?.pushViewController(vc, animated: false)
    
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
        return 80
    }
    

    
}


extension MessageVC1 {
    
    func getAllMessageList() {
        showHUD()
        NetworkManager.Chat.getAllMessageConversation { (response) in
            self.arrMessagesList.removeAll()
            self.arrMessagesList.append(contentsOf: response)
            self.tblChat.reloadData()
            self.hideHUD()
        } _: { (error) in
            self.hideHUD()
            self.showToast(error)
        }

    }

        
    }
    

