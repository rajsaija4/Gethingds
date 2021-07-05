//
//  EditProfileVC.swift
//  Gethingd
//
//  Created by GT-Raj on 05/07/21.
//

import UIKit
import TagListView

class EditProfileVC: UITableViewController, TagListViewDelegate {

    @IBOutlet weak var selectedPassion: TagListView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedPassion.delegate = self
        selectedPassion.textFont = AppFonts.Poppins_Medium.withSize(17)
        selectedPassion.alignment = .leading
        selectedPassion.addTags(["Biking","Walking","Beauty","Golf","German Hip"])
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
//    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
//        print("Tag pressed: \(title), \(sender)")
//        tagView.isSelected = !tagView.isSelected
//    }
//
//    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
//        print("Tag Remove pressed: \(title), \(sender)")
//        sender.removeTagView(tagView)
//    }

    
    @IBAction func onPressEditPassion(_ sender: UIButton) {
        let vc = TagListVC.instantiate(fromAppStoryboard: .Profile)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
        
        
        
        
        
    }
}
