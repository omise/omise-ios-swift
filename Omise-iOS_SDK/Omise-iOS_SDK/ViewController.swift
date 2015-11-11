//
//  ViewController.swift
//  Omise-iOS_SDK
//
//  Created by Anak Mirasing on 6/13/2558 BE.
//  Copyright (c) 2558 omise. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textFieldPublicKey: UITextField!
    @IBOutlet weak var textViewJson: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldPublicKey.delegate = self
        
        self.test(1)
    }
    
    // MARK: - Action
    @IBAction func onConnectTapped(sender: AnyObject) {
        self.test(1)
        textFieldPublicKey.resignFirstResponder()
    }
    
    // MARK: - Test
    func test(api:Int) {
        let omise = Omise()
        omise.delegate = self
        
        let tokenRequest = TokenRequest()
        
        if textFieldPublicKey.text!.isEmpty {
            tokenRequest.publicKey = "pkey_test_4ya6kkbjfporhk3gwnt"
        }else{
            tokenRequest.publicKey = textFieldPublicKey.text
        }
        
        if let card = tokenRequest.card {
            card.name = "JOHN DOE"
            card.city = "Bangkok"
            card.postalCode = "10320"
            card.number = "4242424242424242"
            card.expirationMonth = "11"
            card.expirationYear = "2016"
            card.securityCode = ""
        }
        
        
        omise.requestToken(tokenRequest)
    }
    
}

// MARK: - TextField Delegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - OmiseTokenDelegate
extension ViewController: OmiseRequestDelegate {
    
    func omiseOnFailed(error: NSError?) {
        if let error = error {
            print("Error : \(error.description)")
            textViewJson.text = "Failed... : \(error.description)"
        }
    }
    
    func omiseOnSucceededToken(token: Token?) {
        print("Success")
        
        if let token = token {
            
            textViewJson.text = "token:{\n\ttokenId:\(token.tokenId!)\n\tlivemode:\(token.livemode!)\n\tlocation:\(token.location!)\n\tused:\(token.used!)\n\tcard:{\n\t\t"
            
            if let card = token.card {
                let output = "cardId:\(card.cardId!)\n\t\tlivemode:\(card.livemode!)\n\t\tcountry:\(card.country!)\n\t\tcity:\(card.city!)\n\t\tpostal_code:\(card.postalCode!)\n\t\tfinancing:\(card.financing!)\n\t\tlast_digits:\(card.lastDigits!)\n\t\tbrand:\(card.brand!)\n\t\texpiration_month:\(card.expirationMonth!)\n\t\texpiration_year:\(card.expirationYear!)\n\t\tfingerprint:\(card.fingerprint!)\n\t\tname:\(card.name!)\n\t\tcreated:\(card.created!)\n\t\tbank:\(card.bank)\n\t}\n\t"
                
                textViewJson.text = textViewJson.text + output
            }
            
            textViewJson.text = textViewJson.text + "created:\(token.created!)\n}"
            
            let omise = Omise()
            omise.delegate = self
        }
        
    }
}

