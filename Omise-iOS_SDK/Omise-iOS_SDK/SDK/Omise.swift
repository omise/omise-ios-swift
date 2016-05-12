//
//  Omise.swift
//  Omise-iOS_SDK
//
//  Created by Anak Mirasing on 6/13/2558 BE.
//  Copyright (c) 2558 omise. All rights reserved.
//

import Foundation

public protocol OmiseRequestDelegate {
    func omiseOnSucceededToken(token: OmiseToken?)
    func omiseOnFailed(error: NSError?)
}

public enum OmiseApi: Int {
    case OmiseToken = 1
}


public class Omise: NSObject, NSURLConnectionDelegate {
    
    public var delegate: OmiseRequestDelegate?
    var data: NSMutableData?
    var mTokenRequest: OmiseTokenRequest?
    var isConnecting: Bool = false
    var requestingApi: Int?
    
    override init() {
        isConnecting = false
    }
    
    public func requestToken(tokenRequest: OmiseTokenRequest?) {

        if isConnecting {
            let omiseError = NSError(domain: OmiseErrorDomain, code:OmiseErrorCode.OmiseServerConnectionError.rawValue , userInfo: ["Connection error": "Running other request."])
            delegate?.omiseOnFailed(omiseError)
        }
        
        isConnecting = true
        requestingApi = OmiseApi.OmiseToken.rawValue
        
        data = NSMutableData()
        mTokenRequest = tokenRequest
        
        let url = NSURL(string: "https://vault.omise.co/tokens")
        let OMISE_IOS_VERSION = "2.0.1"
        let req = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        req.HTTPMethod = "POST"
        
        if let mTokenRequest = mTokenRequest {
            if let card = mTokenRequest.card {
                
                var city = ""
                var postalCode = ""
                
                if let userCity = card.city {
                    city = userCity
                }
                
                if let userPostalCode = card.postalCode {
                    postalCode = userPostalCode
                }
                
                let body = "card[name]=\(card.name!)&card[city]=\(city)&card[postal_code]=\(postalCode)&card[number]=\(card.number!)&card[expiration_month]=\(card.expirationMonth!)&card[expiration_year]=\(card.expirationYear!)&card[security_code]=\(card.securityCode!)"
                
                req.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                
                let loginString = "\(mTokenRequest.publicKey!):"
                let plainData = loginString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                let base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
                let base64LoginData = "Basic \(base64String!)"
                let userAgentData = "OmiseIOSSwift/\(OMISE_IOS_VERSION)"
                req.setValue(base64LoginData, forHTTPHeaderField: "Authorization")
                req.setValue(userAgentData, forHTTPHeaderField: "User-Agent")
                let connection = NSURLConnection(request: req, delegate: self, startImmediately: false)
                connection?.start()
                
            }
        }
    }
    
    // MARK: - NSURLConnectionDelegate
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        data?.length = 0
    }
    
    func connection(connection: NSURLConnection!, didReceiveData conData: NSData!) {
        data?.appendData(conData)
    }
    
    public func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        var omiseError:NSError!
        if error.code == NSURLErrorTimedOut {
            omiseError = NSError(domain: OmiseErrorDomain, code: OmiseErrorCode.OmiseTimeoutError.rawValue, userInfo: ["Request timeout": "Request timeout"])
        }else{
            omiseError = NSError(domain: OmiseErrorDomain, code: OmiseErrorCode.OmiseServerConnectionError.rawValue, userInfo: ["Can not connect Omise server": "Check your parameter and internet connection."])
        }
        
        isConnecting = false
        delegate?.omiseOnFailed(omiseError)
    }
    
    public func connection(connection: NSURLConnection, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge) {
        
        if challenge.previousFailureCount > 0 {
            challenge.sender!.cancelAuthenticationChallenge(challenge)
            let error = NSError(domain: "error", code: Int.min, userInfo: nil)
            self.connection(connection, didFailWithError: error)
            
            let omiseError = NSError(domain: OmiseErrorDomain, code: OmiseErrorCode.OmiseServerConnectionError.rawValue, userInfo: ["Connection error": "Authentication failed."])
            delegate?.omiseOnFailed(omiseError)
            return
        }
        
        if requestingApi == OmiseApi.OmiseToken.rawValue {
            if let mTokenRequest = mTokenRequest {
                let credential = NSURLCredential(user: mTokenRequest.publicKey!, password: "", persistence: NSURLCredentialPersistence.ForSession)
                challenge.sender!.useCredential(credential, forAuthenticationChallenge: challenge)
            }
        }
    }
    
    public func connection(connection: NSURLConnection, canAuthenticateAgainstProtectionSpace protectionSpace: NSURLProtectionSpace) -> Bool {
        return true
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        if let data = data {
            let responseText = NSString(data: data, encoding:NSUTF8StringEncoding)
            
            let jsonParser = OmiseJsonParser()
            var token: OmiseToken?
            
            if let requestingApi = requestingApi {
                switch (requestingApi) {
                case OmiseApi.OmiseToken.rawValue:
                    token = jsonParser.parseOmiseToken(responseText!)
                    if (token != nil) {
                        delegate?.omiseOnSucceededToken(token)
                    }else{
                        let omiseError = NSError(domain: OmiseErrorDomain, code: OmiseErrorCode.OmiseBadRequestError.rawValue, userInfo: ["Invalid param": "Invalid public key or parameters."])
                        delegate?.omiseOnFailed(omiseError)
                    }
                    break
                    
                default:
                    break
                }
            }
        }
        isConnecting = false
    }
}
