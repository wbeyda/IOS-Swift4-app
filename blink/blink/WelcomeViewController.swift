//
//  WelcomeViewController.swift
//  blink
//
//  Created by Dharmesh Sonani on 12/04/19.
//  Copyright © 2019 Deedcoin Office. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet var btnGotIt : UIButton!
    @IBOutlet var mainView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mainView.layer.cornerRadius = 10
        
        btnGotIt.layer.cornerRadius = 10
        btnGotIt.setupShadow()
    }
    
    @IBAction func clickOnGotIt(sender:UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }


}
