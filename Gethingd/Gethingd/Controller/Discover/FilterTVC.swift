//
//  FilterTVC.swift
//  Zodi
//
//  Created by AK on 15/09/20.
//  Copyright © 2020 Gurutechnolabs. All rights reserved.
//


import UIKit
import RangeSeekSlider
import GooglePlaces

class FilterTVC: UITableViewController {
    
    //MARK:- VARIABLE
    
    var selectedGender =  -1
    var gender = ""

    fileprivate var latitude: String = ""
//    fileprivate var place:String = ""
    @IBOutlet weak var location: UIControl!
    fileprivate var longitude: String = ""
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
        rangeAge.minDistance = 1
        rangeKidsCount.minDistance = 1
        rangeAge.minValue = CGFloat(Filter.defaultMinAge)
        rangeAge.maxValue = CGFloat(Filter.defaultMaximumAge)
        rangeAge.selectedMinValue = CGFloat(Filter.minAge)
        rangeAge.selectedMaxValue = CGFloat(Filter.maxAge)
        rangeKidsCount.minValue = CGFloat(Filter.defaultMinKids)
        rangeKidsCount.maxValue = CGFloat(Filter.defaultMaxKids)
        rangeKidsCount.selectedMinValue = CGFloat(Filter.minKid)
        lbl_location.text = Filter.place
        
        rangeKidsCount.selectedMaxValue = CGFloat(Filter.maxKid)
        if Filter.lookingFor == "male" {
            btn_gender[0].isSelected = true
            
        }
        if Filter.lookingFor == "female"{
            btn_gender[1].isSelected = true
            
        }
        if Filter.lookingFor == "both"  {
            btn_gender[2].isSelected = true
            
        }
        
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func btnGenderonPress(_ sender: UIButton) {
        
        for btn in btn_gender {
            if btn.tag == sender.tag {
                btn.isSelected = true
                selectedGender = btn.tag
                if selectedGender == 0 {
                   gender = "male"
                }
                
                else if selectedGender == 1 {
                    gender = "female"
                }
                
                else if selectedGender == 2 {
                    gender = "both"
                }
                
                else {
                    print("No gender Selected")
                }
            } else {
                btn.isSelected = false
            }
        }
        
    }
    @IBAction func locationOnPress(_ sender: UIControl) {
        
        let gmsACVC = GMSAutocompleteViewController()
        gmsACVC.delegate = self
        gmsACVC.modalPresentationStyle = .fullScreen
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        gmsACVC.autocompleteFilter = filter
        present(gmsACVC, animated: true, completion: nil)
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
        
        rangeKidsCount.tag = 2
        rangeKidsCount.delegate = self
        
        
  
        rangeAge.selectedMinValue = CGFloat(Filter.minAge)
        rangeAge.selectedMaxValue = CGFloat(Filter.maxAge)
        rangeDistance.selectedMaxValue = CGFloat(Filter.distance)
        rangeKidsCount.selectedMinValue = CGFloat(Filter.minKid)
        rangeKidsCount.selectedMaxValue = CGFloat(Filter.maxKid)
        
       

        lblAge.text = "\(Filter.minAge)-\(Filter.maxAge)"
        lbl_Distance.text = "\(Filter.distance) miles"
        lbl_kidsCount.text = "\(Filter.minKid)-\(Filter.maxKid)"
        
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
        Filter.minKid = Int(rangeKidsCount.selectedMinValue)
        Filter.maxKid = Int(rangeKidsCount.selectedMaxValue)
        if gender == "male" {
            Filter.lookingFor = "male"
        }
        if gender == "female" {
            Filter.lookingFor = "female"
        }
        if gender == "both" {
            Filter.lookingFor = "both"
        }
        Filter.latitude = latitude
        Filter.longitude = longitude
      
    
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
                self.lbl_kidsCount.text = "\(miniValue)-\(maxiValue)"
                
              
                
        
                
              
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


extension FilterTVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        //        txtAddress.text = place.name
        let latitude = "\(place.coordinate.latitude)"
        let longitude = "\(place.coordinate.longitude)"
        var locationName = ""
        var country = ""
        var state = ""
        var city = ""
        var postalCode = ""
        
        let placeName = place.name ?? ""
        Filter.place = placeName
        let address = place.formattedAddress ?? ""
        
        var addArray:[String] = []
        for component in place.addressComponents ?? [] {
            if component.types.contains("locality") {
                locationName = component.name
            }
            if component.types.contains("administrative_area_level_2") {
                city = component.name
                if city.count > 0 {
                    addArray.append(city)
                }
            }
            if component.types.contains("administrative_area_level_1") {
                state = component.name
                if state.count > 0 {
                    addArray.append(state)
                }
            }
            if component.types.contains("country") {
                country = component.name
            }
            if component.types.contains("postal_code") {
                postalCode = component.name
            }
        }
        
        let addressString = addArray.joined(separator: ", ")
        //getAddressFromCenterCoordinate(centerCoordinate: place.coordinate)
        self.latitude = latitude
       
        self.longitude = longitude
     
        self.lbl_location.text = addressString
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
