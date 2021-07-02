//
//  FilterTVC.swift
//  Zodi
//
//  Created by AK on 15/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//


import UIKit
import RangeSeekSlider

class FilterTVC: UITableViewController {
    
    //MARK:- VARIABLE
   
    var onFilter: (() -> Void)?
    
    @IBOutlet var btn_gender: [UIButton]!
    //    @IBOutlet weak var btnGender: UIButton!
    //MARK:- OUTLET
    @IBOutlet weak var rangeDistance: RangeSeekSlider!
    
    @IBOutlet weak var rangeKidsCount: RangeSeekSlider!
    @IBOutlet weak var rangeAge: RangeSeekSlider!
    @IBOutlet weak var lbl_location: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lbl_Distance: UILabel!
    
    @IBOutlet weak var lbl_kidsCount: UILabel!
    //    @IBOutlet weak var lbl_Distance: UILabel!

    
    //MARK:- LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func btnGenderonPress(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
    }
    @IBAction func conLocationOnPress(_ sender: Any) {
    }

    @IBAction func conSexualOrientationPress(_ sender: Any) {
    }
    @IBAction func onPressbtnSubmit(_ sender: Any) {
    }
}


extension FilterTVC {
    
    fileprivate func setupUI() {
       
        rangeAge.tag = 0
        rangeAge.delegate = self
        
        rangeDistance.tag = 1
        rangeDistance.delegate = self
        
  
        rangeAge.selectedMinValue = CGFloat(Filter.minAge)
        rangeAge.selectedMaxValue = CGFloat(Filter.maxAge)
        rangeDistance.selectedMaxValue = CGFloat(Filter.distance)
       

        lblAge.text = "\(Filter.minAge)-\(Filter.maxAge)"
        lbl_Distance.text = "\(Filter.distance) miles"
        
        if Filter.distance == 0 || Filter.distance == 1 {
            self.lbl_Distance.text = "\(Filter.distance) mile"
        }
        
        if Filter.distance == 100 {
            self.lbl_Distance.text = "\(Filter.distance)+ miles"
        }
        
      


 
    }
}


extension FilterTVC {
    
    @IBAction func onCloseBtnTap(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
   
    
    @IBAction func onApplyBtnTap(_ sender: UIButton) {
        Filter.distance = Int(rangeDistance.selectedMaxValue)
        Filter.minAge = Int(rangeAge.selectedMinValue)
        Filter.maxAge = Int(rangeAge.selectedMaxValue)
    
        onFilter?()
        self.dismiss(animated: true, completion: nil)
    }
}




extension FilterTVC: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        
        let miniValue = Int(minValue)
        let maxiValue = Int(maxValue)
        
        switch slider.tag {
            case 0:
                self.lblAge.text = "\(miniValue)-\(maxiValue)"
            case 1:
                self.lbl_Distance.text = "\(maxiValue) miles"
                if maxiValue == 0 || maxiValue == 1 {
                    self.lbl_Distance.text = "\(maxiValue) mile"
                }
                if maxiValue == 100 {
                    self.lbl_Distance.text = "\(maxiValue)+ miles"
                }
            case 2:
                
                let minFeet = miniValue / 12
                let minInches = miniValue % 12
                
                let maxFeet = maxiValue / 12
                let maxInches = maxiValue % 12
                
        
                
              
            default:
            break
        }
    }
}



extension FilterTVC {
    
    fileprivate func showAlert(alert: String) {
        
        let alert = UIAlertController(title: "Oops!", message: alert)
        self.present(alert, animated: true, completion: nil)
    }
}
