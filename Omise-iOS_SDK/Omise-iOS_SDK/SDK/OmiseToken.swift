//
//  Token.swift
//  Omise-iOS_SDK
//
//  Created by Anak Mirasing on 6/13/2558 BE.
//  Copyright (c) 2558 omise. All rights reserved.
//

import Foundation

public class OmiseToken: NSObject {
    public var tokenId: String?
    public var livemode: Bool?
    public var location: String?
    public var used: Bool?
    public var card: Card?
    public var created: String?
    
    public override init() {
        card = Card()
    }
}
