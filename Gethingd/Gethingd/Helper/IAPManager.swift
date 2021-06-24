//
//  IAPManager.swift
//
//  Created by Ashish on 08/05/20.
//  Copyright © 2020 AK Inc. All rights reserved.
//

import Foundation
import SwiftyStoreKit

var isPurchase: Bool {
    get {
        UserDefaults.standard.bool(forKey: "isPurchase")
    }
    set {
        UserDefaults.standard.setValue(newValue, forKey: "isPurchase")
        UserDefaults.standard.synchronize()
    }
}


class IAPManager {
    
    static let inAppSharedSecrete = "fc5f1eacf8aa472bb7aa57de375869f9"
    
    //com.zodi.astro.like
    //com.zodi.premium.plan
    //gurutechnolabs.zodiap@inapp.com
    //Zodiap@Test13

    static let productIdAstroLike = "com.zodi.astro.like"
    static let productIdMonth = "com.zodi.premium.plan"
    
        
    static func setup() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break
                }
            }
        }

        
        SwiftyStoreKit.retrieveProductsInfo([productIdAstroLike, productIdMonth]) { result in
            
//            var arrPlan: [UpgradePlan] = []
            for product in result.retrievedProducts {
                print(product.localizedTitle)
                
//                    let type = String(product.localizedTitle.split(separator: " ")[1])
//                    arrPlan.append(UpgradePlan(name: "1 \(type)", price: product.localizedPrice ?? "", info: "renews \(product.localizedPrice ?? "")/\(type) after trial ends", type: type))
                
                
            }
            
            
//            if arrPlan.count > 0 {
//                if let plan1 = arrPlan.filter({ $0.type == "Week" }).first {
//                    arrUpgradePlan.append(plan1)
//                }
//
//                if let plan2 = arrPlan.filter({ $0.type == "Month" }).first {
//                    arrUpgradePlan.append(plan2)
//                }
//
//                if let plan3 = arrPlan.filter({ $0.type == "Year" }).first {
//                    arrUpgradePlan.append(plan3)
//                }
//            }
            if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else if let error = result.error {
                print("Error: \(error.localizedDescription)")
            }
        }
        
        /*
        guard isPurchase else { return }
        
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: inAppSharedSecrete)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
                case .success(let receipt):
                    
                    guard let lastPurchase = (receipt["latest_receipt_info"] as? [[String: Any]])?.last else { return }
                    
                    guard let lastProductID = lastPurchase["product_id"] as? String else { return }
                    
                    // Verify the purchase of a Subscription
                    let purchaseResult = SwiftyStoreKit.verifySubscription(
                        ofType: .nonRenewing(validDuration: 3600 * 24 * 30), // or .nonRenewing (see below)
                        productId: lastProductID,
                        inReceipt: receipt)
                    
                    
                    switch purchaseResult {
                        case .purchased(let expiryDate, let items):
                            print("\(lastProductID) is valid until \(expiryDate)\n\(items)\n")
                            
                        case .expired(let expiryDate, let items):
                            print("\(lastProductID) is expired since \(expiryDate)\n\(items)\n")
                            isPurchase = false
                        case .notPurchased:
                            print("The user has never purchased \(lastProductID)")
                            isPurchase = false
                    }
                    
                    
                case .error(let error):
                    print("Receipt verification failed: \(error)")
            }
        }
 
        */
    }
    
    static func purchaseProduct(forID id: String, _ handler: @escaping ((success: Bool, transactionId: String?)) -> ()) {
        SwiftyStoreKit.purchaseProduct(id, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                handler((true, purchase.transaction.transactionIdentifier))
                ROOTVC?.view.makeToast("Purchase Success")
                print("Purchase Success: \(purchase.productId)")
            case .error(let error):
                handler((false, nil))
                ROOTVC?.view.makeToast(error.localizedDescription)
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
    }
    
    static func purchaseAddOnProduct(forID id: String, _ handler: @escaping ((success: Bool, transactionId: String?)) -> ()) {
        SwiftyStoreKit.purchaseProduct(id, quantity: 1, atomically: true) { result in
            switch result {
                case .success(let purchase):
                    
                    handler((true, purchase.transaction.transactionIdentifier))
                    ROOTVC?.view.makeToast("Purchase Success")
                    print("Purchase Success: \(purchase.productId)")
                case .error(let error):
                    handler((false, nil))
                    ROOTVC?.view.makeToast(error.localizedDescription)
                    switch error.code {
                        case .unknown: print("Unknown error. Please contact support")
                        case .clientInvalid: print("Not allowed to make the payment")
                        case .paymentCancelled: break
                        case .paymentInvalid: print("The purchase identifier was invalid")
                        case .paymentNotAllowed: print("The device is not allowed to make the payment")
                        case .storeProductNotAvailable: print("The product is not available in the current storefront")
                        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                        case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                        case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                        default: print((error as NSError).localizedDescription)
                    }
            }
        }
    }
    
    static func restorePurchase(_ handler: @escaping (_ success: Bool) -> ()) {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                handler(false)
                ROOTVC?.view.makeToast("Restore Failed")
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                handler(true)
//                ROOTVC?.view.makeToast("Restore Success")
//                print("Restore Success: \(results.restoredPurchases)")
                let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: inAppSharedSecrete)
                SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
                    switch result {
                    case .success(let receipt):
                        
                        guard let lastPurchase = (receipt["latest_receipt_info"] as? [[String: Any]])?.last else { return }
                        
                        guard let lastProductID = lastPurchase["product_id"] as? String else { return }
                        
                        // Verify the purchase of a Subscription
                        let purchaseResult = SwiftyStoreKit.verifySubscription(
                            ofType: .autoRenewable, // or .nonRenewing (see below)
                            productId: lastProductID,
                            inReceipt: receipt)
                        

                        switch purchaseResult {
                        case .purchased(let expiryDate, let items):
                            print("\(lastProductID) is valid until \(expiryDate)\n\(items)\n")
                            isPurchase = true
                            ROOTVC?.view.makeToast("Restore Success")
                        case .expired(let expiryDate, let items):
                            print("\(lastProductID) is expired since \(expiryDate)\n\(items)\n")
                            isPurchase = false
                            ROOTVC?.view.makeToast("Your in-app Purchase is expired since \(expiryDate)")
                        case .notPurchased:
                            print("The user has never purchased \(lastProductID)")
                            isPurchase = false
                        }
                            

                    case .error(let error):
                        print("Receipt verification failed: \(error)")
                    }
                }}
            else {
                handler(false)
                ROOTVC?.view.makeToast("Nothing to Restore")
                print("Nothing to Restore")
            }
        }
    }
}
