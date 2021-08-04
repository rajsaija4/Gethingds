//
//  ReportVC.swift
//  Zodi
//
//  Created by AK on 14/10/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit

class ReportVC: UIViewController {

    //MARK:- VARIABLE
    var reportType = "UnMatch"
    fileprivate var arrReason: [ReportReason] = []
    var selectedUserId: Int = 0
    fileprivate var selectedReportId: Int = 0
    fileprivate var selectedIndex: Int = 0
    
    //MARK:- OUTLET
    @IBOutlet weak var tblReportReason: UITableView!{
        didSet{
            tblReportReason.register(ReportReasonCell.self)
        }
    }
    @IBOutlet weak var lblType: UILabel!
    
    //MARK:- LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblType.text = reportType
        getReasons()
    }
    
    @IBAction func onDismissBtnTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onReportBtnTap(_ sender: UIControl) {
        selectedReportId = arrReason[selectedIndex].id
        reportUser()
    }
    

}


extension ReportVC {
    
    fileprivate func getReasons() {
        showHUD()
        let param = ["report_type": reportType]
        NetworkManager.Report.getReasons(param: param){ (reasons) in
            self.hideHUD()
            self.arrReason.removeAll()
            self.arrReason.append(contentsOf: reasons)
            self.tblReportReason.reloadData()
        } _: { (error) in
            self.hideHUD()
            self.showToast(error)
        }
    }
    
    
    fileprivate func reportUser() {
        showHUD()
        let param = ["report_id": selectedReportId, "user_id": selectedUserId, "type": reportType] as [String : Any]
        
        
        
        NetworkManager.Report.actionAccount(param: param) { (message) in
            self.hideHUD()
            let alert = UIAlertController(title: "Success", message: message) { (_) in
                APPDEL?.setupMainTabBarController()
            }
            self.present(alert, animated: true, completion: nil)
        } _: { (error) in
            self.hideHUD()
            
            let alert = UIAlertController(title: "Error", message: error)
            self.present(alert, animated: true, completion: nil)

        }
        
    }
    
}



extension ReportVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReason.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReportReasonCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setupCell(reason: arrReason[indexPath.row])
        if indexPath.row == selectedIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
}



extension ReportVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tblReportReason.reloadData()
    }
    
}
