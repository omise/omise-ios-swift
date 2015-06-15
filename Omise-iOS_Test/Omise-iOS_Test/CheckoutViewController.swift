//
//  CheckoutViewController.swift
//  Omise-iOS_Test
//
//  Created by Anak@Omise on 6/15/15.
//  Copyright (c) 2015 omise. All rights reserved.
//

import UIKit

var islandNum = 0
var isClosing = false

class CheckoutViewController: UIViewController {
    
    @IBOutlet weak var labelIslandNum: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    
    class func setIslandNum(_islandNum:Int) {
        islandNum = _islandNum
    }
    
    class func setIsClosing(_isClosing:Bool) {
        isClosing = _isClosing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if isClosing {
            self.dismissViewControllerAnimated(true, completion: nil)
            isClosing = false
            return
        }
        
        labelIslandNum.text = "\(islandNum)"
        labelPrice.text = "\(islandNum*2)m USD"
        
    }
    
    // MARK: - Action

    @IBAction func cancelBtnTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
