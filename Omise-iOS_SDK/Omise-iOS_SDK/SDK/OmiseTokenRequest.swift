//
//  TokenRequest.swift
//  Omise-iOS_SDK
//
//  Created by Anak Mirasing on 6/13/2558 BE.
//  Copyright (c) 2558 omise. All rights reserved.
//

import Foundation

public class OmiseTokenRequest: NSObject {
    public var card: Card?
    public var publicKey: String?
    
    public override init() {
        card = Card()
    }
}
