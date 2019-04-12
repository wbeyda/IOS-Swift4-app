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
    @IBOutlet weak var btnMyContact : UIButton!
    @IBOutlet weak var btnTextMe : UIButton!
    @IBOutlet weak var btnDownload : UIButton!
    @IBOutlet weak var messageView : UIView!
    @IBOutlet weak var btnDailyReward : UIButton!
    @IBOutlet weak var btnUsePoints : UIButton!
    @IBOutlet weak var sw : UISwitch!
    @IBOutlet weak var lblStatus: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        btnMyContact.roundCorners(corners: [.topLeft,.bottomLeft], radius: 10.0)
        btnTextMe.roundCorners(corners: [.topLeft,.bottomLeft], radius: 10.0)
        btnDownload.roundCorners(corners: [.topLeft,.bottomLeft], radius: 10.0)
        
        btnDailyReward.layer.cornerRadius = 10
        btnUsePoints.layer.cornerRadius = 10
        
        btnDailyReward.setupShadow()
        btnUsePoints.setupShadow()
        
        btnMyContact.setupShadow()
        btnTextMe.setupShadow()
        btnDownload.setupShadow()

        sw.transform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
        sw.layer.cornerRadius = 16
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.object(forKey: "QRCodeDetails") != nil{
            
            messageView.isHidden = true
            
            let dicQRCode = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "QRCodeDetails") as! Data) as! NSDictionary
            
            qrCodeImage.image = (dicQRCode.value(forKey: "vCard") as! UIImage)
            headerText.text = "Scan with camera to add my contact!"
        }
        else{
           // messageView.isHidden = false
        }
        
    }
    
    @IBAction func clickOnMyContact(sender:UIButton)
    {
        let color = UIColor.init(red: 109.0/255.0, green: 203.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        let color2 = UIColor.init(red: 68.0/255.0, green: 91.0/255.0, blue: 167.0/255.0, alpha: 1.0)
        
        btnMyContact.backgroundColor = color2
        btnTextMe.backgroundColor = color
        btnDownload.backgroundColor = color

        let dicQRCode = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "QRCodeDetails") as! Data) as! NSDictionary

        
        qrCodeImage.image = (dicQRCode.value(forKey: "vCard") as! UIImage)
        headerText.text = "Scan with camera to add my contact!"
    }
    
    @IBAction func clickOnTextMe(sender:UIButton)
    {
        let color = UIColor.init(red: 109.0/255.0, green: 203.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        let color2 = UIColor.init(red: 68.0/255.0, green: 91.0/255.0, blue: 167.0/255.0, alpha: 1.0)
        
        btnMyContact.backgroundColor = color
        btnTextMe.backgroundColor = color2
        btnDownload.backgroundColor = color
        
        let dicQRCode = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "QRCodeDetails") as! Data) as! NSDictionary
        
        headerText.text = "Scan with camera to text me!"
        qrCodeImage.image = (dicQRCode.value(forKey: "SMS") as! UIImage)

    }
    
    @IBAction func clickOnDownload(sender:UIButton)
    {
        headerText.text = "Scan with camera to download the app!"
        
        let color = UIColor.init(red: 109.0/255.0, green: 203.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        let color2 = UIColor.init(red: 68.0/255.0, green: 91.0/255.0, blue: 167.0/255.0, alpha: 1.0)
        
        btnMyContact.backgroundColor = color
        btnTextMe.backgroundColor = color
        btnDownload.backgroundColor = color2
    }
    
    @IBAction func clickOnSwitch(sender:UISwitch)
    {
        if sender.isOn{
            
            lblStatus.text = "Business"
        }
        else{
            lblStatus.text = "Personal"

        }
    }
    
}
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIButton
{
    func setupShadow()
    {
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
    }
}
