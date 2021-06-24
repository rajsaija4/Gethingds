//
//  InstagramMedia.swift
//  Zodi
//
//  Created by GT-Ashish on 22/03/21.
//  Copyright © 2021 Gurutechnolabs. All rights reserved.
//

import Foundation
import SwiftyJSON

enum MediaType: String {
    case IMAGE
    case VIDEO
    case CAROUSEL_ALBUM
}


class InstaMedia {
    var id: String = ""
    var mediaURL: String = ""
    var thumbnailURL: String = ""
    var mediaType: String = ""
    var arrChildren: [InstaMedia] = []
    
    init(_ json: JSON) {
        
        id = json["id"].stringValue
        mediaURL = json["media_url"].stringValue
        mediaType = json["media_type"].stringValue
        thumbnailURL = json["thumbnail_url"].stringValue
        //        children = json["children"].stringValue
        for children in json["children"]["data"].arrayValue {
            if children["media_type"].stringValue != MediaType.VIDEO.rawValue {
                arrChildren.append(InstaMedia(children))
            }
            
        }
    }
    
    
}

