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
    fileprivate var selectedSunSign = 0
    fileprivate var selectedMoonSign = 0
    fileprivate var selectedRisingSign = 0

   
    var onFilter: (() -> Void)?
    
    //MARK:- OUTLET
    @IBOutlet weak var ageSlider: RangeSeekSlider!
    @IBOutlet weak var distanceSlider: RangeSeekSlider!
    @IBOutlet weak var heightSlider: RangeSeekSlider!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    
    @IBOutlet weak var sunSignCollectionView: UICollectionView!{
        didSet{
            sunSignCollectionView.delegate = self
            sunSignCollectionView.dataSource = self
            sunSignCollectionView.registerCell(SignCell.self)
        }
    }
    
    @IBOutlet weak var moonSignCollectionView: UICollectionView!{
        didSet{
            moonSignCollectionView.delegate = self
            moonSignCollectionView.dataSource = self
            moonSignCollectionView.registerCell(SignCell.self)
        }
    }
    
    @IBOutlet weak var risingSignCollectionView: UICollectionView!{
        didSet{
            risingSignCollectionView.delegate = self
            risingSignCollectionView.dataSource = self
            risingSignCollectionView.registerCell(SignCell.self)
        }
    }
    
    //MARK:- LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}


extension FilterTVC {
    
    fileprivate func setupUI() {
        navigationController?.addBackButtonWithTitle(title: "Filters (Slide down to apply)", action: #selector(self.onBackBtnTap))
        
        ageSlider.tag = 0 
        ageSlider.delegate = self
        
        distanceSlider.tag = 1
        distanceSlider.delegate = self
        
        heightSlider.tag = 2
        heightSlider.delegate = self
        
        ageSlider.selectedMinValue = CGFloat(Filter.minAge)
        ageSlider.selectedMaxValue = CGFloat(Filter.maxAge)
        distanceSlider.selectedMaxValue = CGFloat(Filter.distance)
        heightSlider.selectedMinValue = CGFloat(Filter.minHeight)
        heightSlider.selectedMaxValue = CGFloat(Filter.maxHeight)
        
        selectedSunSign = Filter.sunSignId
        selectedMoonSign = Filter.moonSignId
        selectedRisingSign = Filter.risingSignId

        
        lblAge.text = "\(Filter.minAge)-\(Filter.maxAge)"
        lblDistance.text = "\(Filter.distance) miles"
        
        if Filter.distance == 0 || Filter.distance == 1 {
            self.lblDistance.text = "\(Filter.distance) mile"
        }
        
        if Filter.distance == 100 {
            self.lblDistance.text = "\(Filter.distance)+ miles"
        }
        
        let minFeet = Filter.minHeight / 12
        let minInches = Filter.minHeight % 12
        
        let maxFeet = Filter.maxHeight / 12
        let maxInches = Filter.maxHeight % 12
        
        let minHeight = "\(minFeet)"+"'"+"\(minInches)"+"\""
        let maxHeight = "\(maxFeet)"+"'"+"\(maxInches)"+"\""
        
        lblHeight.text = "\(minHeight)-\(maxHeight)"

        
        sunSignCollectionView.reloadData()
        moonSignCollectionView.reloadData()
        risingSignCollectionView.reloadData()
    }
}


extension FilterTVC {
    
    @objc fileprivate func onBackBtnTap() {
//        Filter.distance = Int(distanceSlider.selectedMaxValue)
//        Filter.minAge = Int(ageSlider.selectedMinValue)
//        Filter.maxAge = Int(ageSlider.selectedMaxValue)
//        Filter.minHeight = Int(heightSlider.selectedMinValue)
//        Filter.maxHeight = Int(heightSlider.selectedMaxValue)
//        Filter.sunSignId = selectedSunSign
//        Filter.moonSignId = selectedMoonSign
//        Filter.risingSignId = selectedRisingSign
//        
//        onFilter?()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func onLockBtnTap() {
        let vc = UpgradeVC.instantiate(fromAppStoryboard: .Upgrade)
        vc.modalPresentationStyle = .fullScreen
        vc.onPurchasePlan = {
            self.sunSignCollectionView.reloadData()
            self.moonSignCollectionView.reloadData()
            self.risingSignCollectionView.reloadData()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onApplyBtnTap(_ sender: UIControl) {
        Filter.distance = Int(distanceSlider.selectedMaxValue)
        Filter.minAge = Int(ageSlider.selectedMinValue)
        Filter.maxAge = Int(ageSlider.selectedMaxValue)
        Filter.minHeight = Int(heightSlider.selectedMinValue)
        Filter.maxHeight = Int(heightSlider.selectedMaxValue)
        Filter.sunSignId = selectedSunSign
        Filter.moonSignId = selectedMoonSign
        Filter.risingSignId = selectedRisingSign

        onFilter?()
        self.dismiss(animated: true, completion: nil)
    }
}



extension FilterTVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SignCell = collectionView.dequequReusableCell(for: indexPath)
        let index = indexPath.row + 1
        if collectionView == sunSignCollectionView {
            if index == selectedSunSign {
                cell.setupFilterCellSelected(name: "\(index)")
            } else {
                cell.setupFilterCell(name: "\(index)")
            }
            return cell
        }
        
        if collectionView == moonSignCollectionView {
            if index == selectedMoonSign {
                cell.setupFilterCellSelected(name: "\(index)")
            } else {
                cell.setupFilterCell(name: "\(index)")
            }
            
//            cell.btnLock.isHidden = isPurchase
            cell.btnLock.isHidden = true
            cell.btnLock.addTarget(self, action: #selector(self.onLockBtnTap), for: .touchUpInside)
            return cell
        }
        
        if collectionView == risingSignCollectionView {
            if index == selectedRisingSign {
                cell.setupFilterCellSelected(name: "\(index)")
            } else {
                cell.setupFilterCell(name: "\(index)")
            }
//            cell.btnLock.isHidden = isPurchase
            cell.btnLock.isHidden = true
            cell.btnLock.addTarget(self, action: #selector(self.onLockBtnTap), for: .touchUpInside)
            return cell
        }
        return cell
    }
}



extension FilterTVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == sunSignCollectionView {
            
            if selectedSunSign == indexPath.item + 1 {
                selectedSunSign = 0
            } else {
                selectedSunSign = indexPath.item + 1
            }
        }
        
        if collectionView == moonSignCollectionView {
            
            if selectedMoonSign == indexPath.item + 1 {
                selectedMoonSign = 0
            } else {
                selectedMoonSign = indexPath.item + 1
            }
        }
        
        if collectionView == risingSignCollectionView {
            
            if selectedRisingSign == indexPath.item + 1 {
                selectedRisingSign = 0
            } else {
                selectedRisingSign = indexPath.item + 1
            }
        }
        
        collectionView.reloadData()

    }
}



extension FilterTVC: UICollectionViewDelegateFlowLayout {
    
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



extension FilterTVC: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        
        let miniValue = Int(minValue)
        let maxiValue = Int(maxValue)
        
        switch slider.tag {
            case 0:
                self.lblAge.text = "\(miniValue)-\(maxiValue)"
            case 1:
                self.lblDistance.text = "\(maxiValue) miles"
                if maxiValue == 0 || maxiValue == 1 {
                    self.lblDistance.text = "\(maxiValue) mile"
                }
                if maxiValue == 100 {
                    self.lblDistance.text = "\(maxiValue)+ miles"
                }
            case 2:
                
                let minFeet = miniValue / 12
                let minInches = miniValue % 12
                
                let maxFeet = maxiValue / 12
                let maxInches = maxiValue % 12
                
                let minHeight = "\(minFeet)"+"'"+"\(minInches)"+"\""
                let maxHeight = "\(maxFeet)"+"'"+"\(maxInches)"+"\""
                
                self.lblHeight.text = "\(minHeight)-\(maxHeight)"
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
