//
//  TokenRequest.swift
//  Omise-iOS_SDK
//
//  Created by Anak Mirasing on 6/13/2558 BE.
//  Copyright (c) 2558 omise. All rights reserved.
//

import Foundation

public class OmiseTokenRequest: NSObject {
    var card: Card?
    var publicKey: String?
    
    override init() {
        card = Card()
    }
}
