//
//  ViewController.swift
//  Omise-iOS_Test
//
//  Created by Anak Mirasing on 6/13/2558 BE.
//  Copyright (c) 2558 omise. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var labelIsland: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var stepperIsland: UIStepper!
    
    override func viewWillAppear(animated: Bool) {
        CheckoutViewController.setIsClosing(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stepperValueChanged(stepperIsland)
    }
    
    // MARK: - Action
    @IBAction func stepperValueChanged(sender: UIStepper) {
        labelIsland.text = "\(Int(sender.value))"
        labelPrice.text = "$ \(Int(sender.value * 2.0))m"
        
        CheckoutViewController.setIslandNum(Int(sender.value))
    }
    
    
    
}

