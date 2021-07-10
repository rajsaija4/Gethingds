//
//  NetworkCaller.swift
//
//  Created by Ashish on 20/08/20.
//  Copyright © 2020 Ashish. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class NetworkCaller: NSObject {
    
    class func requestURL(urlString: String, _ success:@escaping (JSON) -> Void, failure:@escaping (AFError) -> Void) {
        
        guard let url = URL(string: urlString) else {
            failure(.invalidURL(url: urlString))
            return
        }
        
        AF.request(URLRequest(url: url)).responseJSON { (response) in
            
            switch response.result {
                case .success(let value):
                    let resJson = JSON(value)
                    if resJson.isAuthenticationFailed {
                        User.details.delete()
                        APPDEL?.setupLogin()
                        return
                    }
                    success(resJson)
                    break
                case .failure(let error):
                    failure(error)
                    break
            }
        }
    }
    
    class func postRequest(url : String, params : Parameters?, headers : HTTPHeaders?, _ success:@escaping (JSON) -> Void, failure:@escaping (AFError) -> Void) {
        
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        AF.request(encodedURL!, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result {
                case .success(let value):
                    let resJson = JSON(value)
                    if resJson.isAuthenticationFailed {
                        User.details.delete()
                        APPDEL?.setupLogin()
                        return
                    }
                    success(resJson)
                    break
                case .failure(let error):
                    failure(error)
                    break
            }
        }
    }
    
    class func getRequest(url : String, params: Parameters?, headers : HTTPHeaders?, _ success:@escaping (JSON) -> Void, failure:@escaping (AFError) -> Void) {
        
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        AF.request(encodedURL!, method: .get, parameters: params, encoding:  URLEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result {
                case .success(let value):
                    let resJson = JSON(value)
                    if resJson.isAuthenticationFailed {
                        User.details.delete()
                        APPDEL?.setupLogin()
                        return
                    }
                    success(resJson)
                    break
                case .failure(let error):
                    failure(error)
                    break
            }
        }
    }
    
    class func uploadRequest(_ url: String, source: [String: Data?], params: [String: String], headers : HTTPHeaders?,  _ success:@escaping (JSON) -> Void, _ failure:@escaping (AFError) -> Void) {
        
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        _ = AF.upload(multipartFormData: { (multipleData) in
            
            for (key, value) in params {
                if let data = value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                    multipleData.append(data, withName: key)
                }
            }
            
            for (key, value) in source {
                multipleData.append(value ?? Data(capacity: 0), withName: key, fileName: "\(Date().timeIntervalSince1970)"+".jpeg", mimeType: "image/*")
            }
            
            //            for (i, data) in source.enumerated() {
            //                multipleData.append(data, withName: "image\(i)", fileName: "\(Date().timeIntervalSince1970)"+".jpeg", mimeType: "image/*")
            //            }
            
            
            //            multipleData.append(path, withName: "file", fileName: path.lastPathComponent, mimeType: "*/*")
            
        }, to: encodedURL!, method: .post, headers: headers).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                case .success(let value):
                    if let result = value as? [String: Any] {
                        let resJson = JSON(result)
                        if resJson.isAuthenticationFailed {
                            User.details.delete()
                            APPDEL?.setupLogin()
                            return
                        }
                        success(resJson)
                    } else {
                        failure(.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
                    }
                    break
                case .failure(let error):
                    failure(error)
                    break
            }
        })
    }
}



extension JSON {
    
    var isSuccess: Bool {
        return self["status"].intValue == 1
    }
    
    var isAuthenticationFailed: Bool {
        return self["status"].intValue == -1
    }
    
    var errorMessage: String {
        return self["message"].stringValue
    }
    
    var message: String {
        return self["message"].stringValue
    }
}
