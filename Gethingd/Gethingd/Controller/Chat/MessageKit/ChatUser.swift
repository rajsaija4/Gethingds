//
//  ChatUser.swift
//
//  Created by AK on 16/09/20.
//  Copyright © 2020 AK. All rights reserved.
//

import UIKit
import MessageKit

struct ChatUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
