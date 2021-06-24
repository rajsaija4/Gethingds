//
//  ReportReasonCell.swift
//  Zodi
//
//  Created by AK on 14/10/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//

import UIKit

class ReportReasonCell: UITableViewCell {

    @IBOutlet weak var imgReason: UIImageView!
    @IBOutlet weak var lblReport: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(reason: ReportReason) {
        if let imgURL = URL(string: reason.icon) {
            imgReason.kf.setImage(with: imgURL)
        }
        lblReport.text = reason.message
    }
    
}
