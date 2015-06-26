omise-ios-swift
=========

Omise-iOS-Swift is a Swift 1.2 library for managing token with Omise API.

By using the token produced by this library, you will be able to securely process credit card without letting sensitive information pass through your server. This token can also be used to create customer card data which will allow re-using of card data for the next payment without entering it again.

All data are transmitted via HTTPS to our PCI-DSS certified server.

## Setup

Please copy all files in {repo root}/Omise-iOS_SDK/SDK into your project.

## Installation

Omise-iOS-Swift is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod 'Omise-iOS-Swift', '~> 1.0'

## Primary classes

### Card

A class representing a card information.

### TokenRequest

A class encapsulating parameters for requesting token. You will have to set card information as a parameter for this class.

### Token

A class representing token. This class is what will be passed to the delegate if the request is successful.

### Omise

A class for requesting token. See also sample code below.

### Test app

By opening Omise-iOS_Test.xcodeproj and building it on Xcode, the sample application will launch and create a charge token to test.

## Request a token

AccessOmiseViewController.swift
```swift

-(void)viewDidLoad
{
    [super viewDidLoad];

    //set parameters
    let tokenRequest = TokenRequest()
    tokenRequest.publicKey = "pkey_test_4y7dh41kuvvawbhslxw" //required
    tokenRequest.card!.name = "JOHN DOE" //required
    tokenRequest.card!.city = "Bangkok" //required
    tokenRequest.card!.postalCode = "10320" //required
    tokenRequest.card!.number = "4242424242424242" //required
    tokenRequest.card!.expirationMonth = "11" //required
    tokenRequest.card!.expirationYear = "2016" //required
    tokenRequest.card!.securityCode = "123" //required
    
    //request
    let omise = Omise()
    omise.delegate = self
    omise.requestToken(tokenRequest)
}


// MARK: - OmiseTokenDelegate
extension AccessOmiseViewController: OmiseRequestDelegate {
    
    func omiseOnFailed(error: NSError?) {
        //handle error
    }
    
    func omiseOnSucceededToken(token: Token?) {
        //handle success
        if let token = token {
            //your code here
        }
    }
}

```
