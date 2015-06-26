//
//  AccessOmiseViewController.swift
//  Omise-iOS_Test
//
//  Created by Anak@Omise on 6/15/15.
//  Copyright (c) 2015 omise. All rights reserved.
//

import UIKit

class AccessOmiseViewController: UIViewController {

    var succeeded = false
    
    @IBOutlet weak var btnToken: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.requestToOmise()
        
    }
    
    // MARK: - Make Request
    func requestToOmise() {
        
        self.startActivity()
        
        let tokenRequest = TokenRequest()
        tokenRequest.publicKey = "pkey_test_4y7dh41kuvvawbhslxw" //required
        tokenRequest.card!.name = "JOHN DOE" //required
        tokenRequest.card!.city = "Bangkok" //required
        tokenRequest.card!.postalCode = "10320" //required
        tokenRequest.card!.number = "4242424242424242" //required
        tokenRequest.card!.expirationMonth = "11" //required
        tokenRequest.card!.expirationYear = "2016" //required
        tokenRequest.card!.securityCode = "123" //required
        
        let omise = Omise()
        omise.delegate = self
        omise.requestToken(tokenRequest)
        
    }
    
    // MARK: - Action
    @IBAction func cancelBtnTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func resetBtnTapped(sender: AnyObject) {
        CheckoutViewController.setIsClosing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tokenBtnTapped(sender: AnyObject) {
        if !succeeded {
            self.requestToOmise()
            return
        }
        
        var pasteBoard = UIPasteboard.generalPasteboard()
        if let tokenKey = btnToken.titleLabel {
            pasteBoard.setValue(tokenKey.text!, forPasteboardType: "public.text")
            
            showAlert("copied to clipboard")
        }
        
    }
    
    func startActivity() {
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
    }
    
    func stopActivity() {
        activityIndicator.alpha = 0
        activityIndicator.stopAnimating()
    }
    
    func showAlert(message:String) {
        let alertView = UIAlertView()
        alertView.title = "Omise"
        alertView.addButtonWithTitle("Ok")
        alertView.message = message
        alertView.show()
    }
    
}

// MARK: - OmiseTokenDelegate
extension AccessOmiseViewController: OmiseRequestDelegate {
    
    func omiseOnFailed(error: NSError?) {
        println("Fail")
        btnToken.setTitle("Sorry, Please try again...", forState: UIControlState.Normal)
        succeeded = false
        
        self.stopActivity()
    }
    
    func omiseOnSucceededToken(token: Token?) {
        println("Success")
        if let token = token {
            btnToken.setTitle(token.tokenId, forState: UIControlState.Normal)
            succeeded = true
        }
        
        self.stopActivity()
    }
}
