//
//  Token.swift
//  Omise-iOS_SDK
//
//  Created by Anak Mirasing on 6/13/2558 BE.
//  Copyright (c) 2558 omise. All rights reserved.
//

import Foundation

class Token: NSObject {
    var tokenId: String?
    var livemode: Bool?
    var location: String?
    var used: Bool?
    var card: Card?
    var created: String?
    
    override init() {
        card = Card()
    }
}
