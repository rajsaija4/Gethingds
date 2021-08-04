//
//  WholikedVC.swift
//  Gethingd
//
//  Created by GT-Raj on 01/07/21.
//

import UIKit

class WholikedVC: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var collWholike: UICollectionView! {
        didSet {
            collWholike.registerCell(FreshMatchesCell.self)
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    var arrUserData:[UserProfile] = []
    var searchActive : Bool = false
    var filtered:[UserProfile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchActive = false
        getWhoLikedMe()
        
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
            filtered = arrUserData.filter({$0.firstName.contains(searchText)})
            searchActive = true
            self.collWholike.reloadData()
        }
        else {
            searchActive = false
            self.collWholike.reloadData()
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

extension WholikedVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(searchActive){
            return filtered.count
        }
        return arrUserData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FreshMatchesCell", for: indexPath) as! FreshMatchesCell
        if(searchActive){
            cell.setupWhoLikedMe(user: filtered[indexPath.row])
        }
        else {
        cell.setupWhoLikedMe(user: arrUserData[indexPath.row])
        }
        return cell
        
    }
    
    
}

extension WholikedVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UserDetailsTVC.instantiate(fromAppStoryboard: .Discover)
        vc.user = arrUserData[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        vc.isfromWhoLikedMe = true
        self.present(vc, animated: true, completion: nil)
    }
    
    
}


extension WholikedVC: UICollectionViewDelegateFlowLayout {
    
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


extension WholikedVC {
    
    func getWhoLikedMe(){
        showHUD()
        NetworkManager.Chat.getWhoLikedMe { (response) in
            self.arrUserData.removeAll()
            self.arrUserData.append(contentsOf: response)
            self.collWholike.reloadData()
            self.hideHUD()
        } _: { (error) in
            self.hideHUD()
            print(error)
        }

    }
    
}
