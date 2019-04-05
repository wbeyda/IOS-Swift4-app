//
//  FirstViewController.swift
//  blink
//
//  Created by Deedcoin Office on 3/28/19.
//  Copyright © 2019 Deedcoin Office. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var headerText: UILabel!
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tabbar = tabBarController as! BaseTabBarController
        qrCodeImage.image = tabbar.baseImage
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("FIRST VIEW APPEARED\n")
        let tabbar = tabBarController as! BaseTabBarController
        qrCodeImage.image = tabbar.baseImage
        
        let height = qrCodeImage.image?.size.height
        let width = qrCodeImage.image?.size.width

        
        if(height! == 0 && width! == 0) {
            print("QR HEIGHT: \(height!)\n")
            print("QR WIDTH: \(width!)\n")
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let settingsVC = sb.instantiateViewController(withIdentifier: "ThirdViewController")
            let homeVC = sb.instantiateViewController(withIdentifier: "FirstViewController")
            self.navigationController?.pushViewController(settingsVC, animated: true)
            self.navigationController?.popToViewController(homeVC, animated: true)
            //self.present(thirdVC, animated: false, completion: nil)
            print("Changed View From VC1")
        }else{
            qrCodeImage.image = tabbar.baseImage
        }

    }
    
    @IBAction func swapQRCodesButton(_ sender: UIButton) {
        let tabbar = tabBarController as! BaseTabBarController
        if(qrCodeImage.image == tabbar.baseImage){
            qrCodeImage.image = tabbar.messageImage
            headerText.text = "Text Me Back Bruh And Then Download The App"
        }else if(qrCodeImage.image == tabbar.messageImage){
            qrCodeImage.image = tabbar.baseImage
            headerText.text = "Scan With Camera To Add Contacts In A Blink"
        }
    }
    
    
    
}
