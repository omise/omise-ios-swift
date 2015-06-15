//
//  Omise.swift
//  Omise-iOS_SDK
//
//  Created by Anak Mirasing on 6/13/2558 BE.
//  Copyright (c) 2558 omise. All rights reserved.
//

import Foundation

protocol OmiseRequestDelegate {
    func omiseOnSucceededToken(token: Token?)
    func omiseOnFailed(error: NSError?)
}

enum OmiseApi: Int {
    case OmiseToken = 1
}


class Omise: NSObject, NSURLConnectionDelegate {
    
    var delegate: OmiseRequestDelegate?
    var data: NSMutableData?
    var mTokenRequest: TokenRequest?
    var isConnecting: Bool = false
    var requestingApi: Int?
    
    override init() {
        isConnecting = false
    }
    
    func requestToken(tokenRequest: TokenRequest?) {

        if isConnecting {
            var omiseError = NSError(domain: OmiseErrorDomain, code:OmiseErrorCode.OmiseServerConnectionError.rawValue , userInfo: ["Connection error": "Running other request."])
            delegate?.omiseOnFailed(omiseError)
        }
        
        isConnecting = true
        requestingApi = OmiseApi.OmiseToken.rawValue
        
        data = NSMutableData()
        mTokenRequest = tokenRequest
        
        var url = NSURL(string: "https://vault.omise.co/tokens")
        var req = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        req.HTTPMethod = "POST"
        
        if let mTokenRequest = mTokenRequest {
            if let card = mTokenRequest.card {
                var body = "card[name]=\(card.name!)&card[city]=\(card.city!)&card[postal_code]=\(card.postalCode!)&card[number]=\(card.number!)&card[expiration_month]=\(card.expirationMonth!)&card[expiration_year]=\(card.expirationYear!)&card[security_code]=\(card.securityCode!)"
                
                req.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                
                var loginString = "\(mTokenRequest.publicKey!):"
                var plainData = loginString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                var base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(0))
                var base64LoginData = "Basic \(base64String!)"
                req.setValue(base64LoginData, forHTTPHeaderField: "Authorization")
                
                var connection = NSURLConnection(request: req, delegate: self, startImmediately: false)
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
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        var omiseError = NSError()
        if error.code == NSURLErrorTimedOut {
            omiseError = NSError(domain: OmiseErrorDomain, code: OmiseErrorCode.OmiseTimeoutError.rawValue, userInfo: ["Request timeout": "Request timeout"])
        }else{
            omiseError = NSError(domain: OmiseErrorDomain, code: OmiseErrorCode.OmiseServerConnectionError.rawValue, userInfo: ["Can not connect Omise server": "Check your parameter and internet connection."])
        }
        
        isConnecting = false
        delegate?.omiseOnFailed(omiseError)
    }
    
    func connection(connection: NSURLConnection, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge) {
        
        if challenge.previousFailureCount > 0 {
            challenge.sender.cancelAuthenticationChallenge(challenge)
            var error = NSError(domain: "error", code: Int.min, userInfo: nil)
            self.connection(connection, didFailWithError: error)
            
            var omiseError = NSError(domain: OmiseErrorDomain, code: OmiseErrorCode.OmiseServerConnectionError.rawValue, userInfo: ["Connection error": "Authentication failed."])
            delegate?.omiseOnFailed(omiseError)
            return
        }
        
        if requestingApi == OmiseApi.OmiseToken.rawValue {
            if let mTokenRequest = mTokenRequest {
                var credential = NSURLCredential(user: mTokenRequest.publicKey!, password: "", persistence: NSURLCredentialPersistence.ForSession)
                challenge.sender.useCredential(credential, forAuthenticationChallenge: challenge)
            }
        }
    }
    
    func connection(connection: NSURLConnection, canAuthenticateAgainstProtectionSpace protectionSpace: NSURLProtectionSpace) -> Bool {
        return true
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        if let data = data {
            var responseText = NSString(data: data, encoding:NSUTF8StringEncoding)
            
            var jsonParser = JsonParser()
            var token: Token?
            
            if let requestingApi = requestingApi {
                switch (requestingApi) {
                case OmiseApi.OmiseToken.rawValue:
                    token = jsonParser.parseOmiseToken(responseText!)
                    if (token != nil) {
                        delegate?.omiseOnSucceededToken(token)
                    }else{
                        var omiseError = NSError(domain: OmiseErrorDomain, code: OmiseErrorCode.OmiseBadRequestError.rawValue, userInfo: ["Invalid param": "Invalid public key or parameters."])
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
