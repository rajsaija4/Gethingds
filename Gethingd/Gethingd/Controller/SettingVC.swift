//
//  SettingVC.swift
//  Gethingd
//
//  Created by GT-Raj on 06/07/21.
//

import UIKit

class SettingVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 4:
            switch indexPath.row {
            case 0:
                print("0")
            case 1:
                print("1")
            case 2:
                print("2")
            default:
                break
            }
        default:
            break
        }
    }
}


