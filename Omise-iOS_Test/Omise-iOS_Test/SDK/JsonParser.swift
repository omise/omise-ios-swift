//
//  JsonParser.swift
//  Omise-iOS_SDK
//
//  Created by Anak Mirasing on 6/13/2558 BE.
//  Copyright (c) 2558 omise. All rights reserved.
//

import UIKit

class JsonParser: NSObject {
    func parseOmiseToken(json: NSString)->Token? {
        
        var jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(json.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.AllowFragments, error: nil)
        
        if let jsonDict = jsonObject as? NSDictionary {
            var obj = jsonDict.objectForKey("object") as? String
            if obj == "error" {
                return nil
            }
            
            var token = Token()
            token.tokenId = jsonDict.objectForKey("id") as? String
            token.livemode = jsonDict.objectForKey("livemode") as? Bool
            token.location = jsonDict.objectForKey("location") as? String
            token.used = jsonDict.objectForKey("used") as? Bool
            token.created = jsonDict.objectForKey("created") as? String
            
            if let cardObject = jsonDict.objectForKey("card") as? NSDictionary {

                token.card?.cardId = cardObject.objectForKey("id") as? String
                token.card?.livemode = cardObject.objectForKey("livemode") as? Bool
                token.card?.country = cardObject.objectForKey("country") as? String
                token.card?.city = cardObject.objectForKey("city") as? String
                token.card?.postalCode = cardObject.objectForKey("postal_code") as? String
                token.card?.financing = cardObject.objectForKey("financing") as? String
                token.card?.lastDigits = cardObject.objectForKey("last_digits") as? String
                token.card?.brand = cardObject.objectForKey("brand") as? String
                token.card?.expirationMonth = String(format: "%d", (cardObject.objectForKey("expiration_month") as! NSNumber))
                token.card?.expirationYear = String(format: "%d", (cardObject.objectForKey("expiration_year") as! NSNumber))
                token.card?.fingerprint = cardObject.objectForKey("fingerprint") as? String
                token.card?.name = cardObject.objectForKey("name") as? String
                token.card?.created = cardObject.objectForKey("created") as? String
                token.card?.securityCodeCheck = cardObject.objectForKey("security_code_check") as? Bool
                
                
                return token
            }
        }
        
        return nil
    }
}
