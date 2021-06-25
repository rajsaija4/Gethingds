//
//  InstagramApi.swift
//  InstaApp Storyboard
//
//  Created by Tushar Gusain on 02/12/19.
//  Copyright © 2019 Hot Cocoa Software. All rights reserved.
//


import UIKit

struct InstagramTestUser: Codable {
    var access_token: String
    var user_id: Int
}

struct InstagramUser: Codable {
    var id: String
    var username: String
}

//MARK:- Instagram Feed
struct Feed: Codable {
    var data: [MediaData]
    var paging : PagingData
}

struct MediaData: Codable {
    var id: String
    var caption: String?
}

struct PagingData: Codable {
    var cursors: CursorData
    //    var next: String
}

struct CursorData: Codable {
    var before: String
    var after: String
}

struct InstagramMedia: Codable {
    var id: String
    
    var media_url: String
    var username: String
    var timestamp: String //"2017-08-31T18:10:00+0000"
}


class InstagramApi {
    
    //MARK:- Member variables
    static let shared = InstagramApi()
    
    
    private let instagramAppID = "456059652338775"
    
    private let redirectURIURLEncoded = "https://httpstat.us/200"
    
    private let redirectURI = "https://httpstat.us/200"
    
    private let app_secret = "8be3e910f0e9aad9b656879018e0ff38"
    
    private let boundary = "boundary=\(NSUUID().uuidString)"
    
    let feedURL = "\(BaseURL.graphApi.rawValue)me/media?fields=id,caption,media_url,media_type,thumbnail_url,children{media_url,media_type,thumbnail_url}&access_token="

    //"https://graph.instagram.com/me/media?fields=id,caption,media_url,media_type,thumbnail_url,children{media_url,media_type,thumbnail_url}&access_token=IGQVJXZAUcwUkF4bHRzbkJKdkNXZAzh4VlZAhdzAtZADJMbDNnbUJuME4zd3Y0dmhVaTBRU2x3MGlmaHRfdTNBSnU0S0JieVktdXRsYmJoYXBXWmFQYzMwX1diRXpBckNSMmpHNTV1el9YVzUxV1o0M082RQZDZD"
    
    //MARK:- Enums
    private enum BaseURL: String {
        case displayApi = "https://api.instagram.com/"
        case graphApi = "https://graph.instagram.com/"
    }
    
    private enum Method: String {
        case authorize = "oauth/authorize"
        case access_token = "oauth/access_token"
    }
    
    //MARK:- Constructor
    private init() {}
    
    //MARK:- Private Methods
    private func getFormBody(_ parameters: [[String : String]], _ boundary: String) -> Data {
        var body = ""
        let error: NSError? = nil
        for param in parameters {
            let paramName = param["name"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if let filename = param["fileName"] {
                let contentType = param["content-type"]!
                var fileContent: String = ""
                do { fileContent = try String(contentsOfFile: filename, encoding: String.Encoding.utf8)}
                catch {
                    print(error)
                }
                if (error != nil) {
                    print(error!)
                }
                body += "; filename=\"\(filename)\"\r\n"
                body += "Content-Type: \(contentType)\r\n\r\n"
                body += fileContent
            } else if let paramValue = param["value"] {
                body += "\r\n\r\n\(paramValue)"
            }
        }
        return body.data(using: .utf8)!
    }
    
    private func getTokenFromCallbackURL(request: URLRequest) -> String? {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.starts(with: "\(redirectURI)?code=") {
            
            print("Response uri:",requestURLString)
            if let range = requestURLString.range(of: "\(redirectURI)?code=") {
                return String(requestURLString[range.upperBound...].dropLast(2))
            }
        }
        return nil
    }
    
    private func getMediaData(testUserData: InstagramTestUser, completion: @escaping (Feed) -> Void) {
        let urlString = "\(BaseURL.graphApi.rawValue)me/media?fields=id,caption&access_token=\(testUserData.access_token)"
        
        let request = URLRequest(url: URL(string: urlString)!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let response = response {
                print(response)
            }
            do { let jsonData = try JSONDecoder().decode(Feed.self, from: data!)
                print(jsonData)
                completion(jsonData)
            }
            catch let error as NSError {
                print(error)
            }
        })
        task.resume()
    }
    
    //MARK:- Public Methods
    
    func authorizeApp(completion: @escaping (_ url: URL?) -> Void ) {
        let urlString = "\(BaseURL.displayApi.rawValue)\(Method.authorize.rawValue)?app_id=\(instagramAppID)&redirect_uri=\(redirectURIURLEncoded)&scope=user_profile,user_media&response_type=code"
        
        let request = URLRequest(url: URL(string: urlString)!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let response = response {
                print(response)
                completion(response.url)
            }
        })
        task.resume()
    }
    
    func getTestUserIDAndToken(request: URLRequest, completion: @escaping (InstagramTestUser) -> Void){
        
        guard let authToken = getTokenFromCallbackURL(request: request) else {
            return
        }
        
        let headers = [
            "content-type": "multipart/form-data; boundary=\(boundary)"
        ]
        let parameters = [
            [
                "name": "app_id",
                "value": instagramAppID
            ],
            [
                "name": "app_secret",
                "value": app_secret
            ],
            [
                "name": "grant_type",
                "value": "authorization_code"
            ],
            [
                "name": "redirect_uri",
                "value": redirectURI
            ],
            [
                "name": "code",
                "value": authToken
            ]
        ]
        
        var request = URLRequest(url: URL(string: BaseURL.displayApi.rawValue + Method.access_token.rawValue)!)
        
        let postData = getFormBody(parameters, boundary)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if (error != nil) {
                print(error!)
            } else {
                do { let jsonData = try JSONDecoder().decode(InstagramTestUser.self, from: data!)
                    print(jsonData)
                    completion(jsonData)
                }
                catch let error as NSError {
                    print(error)
                }
                
            }
        })
        dataTask.resume()
    }
    
    
    func getInstagramUser(testUserData: InstagramTestUser, completion: @escaping (InstagramUser) -> Void) {
        let urlString = "\(BaseURL.graphApi.rawValue)\(testUserData.user_id)?fields=id,username,media_count&access_token=\(testUserData.access_token)"
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!)
            }
            do { let jsonData = try JSONDecoder().decode(InstagramUser.self, from: data!)
                completion(jsonData)
            }
            catch let error as NSError {
                print(error)
            }
        })
        dataTask.resume()
    }
    
    
    
}



