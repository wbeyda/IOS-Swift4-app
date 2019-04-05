//
//  ThirdViewController.swift
//  blink
//
//  Created by Deedcoin Office on 3/28/19.
//  Copyright © 2019 Deedcoin Office. All rights reserved.
//

import UIKit

protocol createQRDelegate {
    func didCreateQRImage(image: UIImage)
}

class ThirdViewController: UIViewController {
    
    var delegate: createQRDelegate? = nil
    
    @IBOutlet weak var fName: UITextField!
    
    @IBOutlet weak var lName: UITextField!
    
    @IBOutlet weak var mPosition: UITextField!
    
    @IBOutlet weak var mCompany: UITextField!
    
    @IBOutlet weak var mEmail: UITextField!
    
    @IBOutlet weak var mPhone: UITextField!
    
    @IBOutlet weak var qrImage: UIImageView!
    
    var smsImage = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tabbar = tabBarController as! BaseTabBarController
        qrImage.image = tabbar.baseImage!
        smsImage = tabbar.messageImage!
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        qrImage.image? = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let tabbar = tabBarController as! BaseTabBarController
        tabbar.baseImage = qrImage.image!
        tabbar.messageImage = smsImage
    }
    
    @IBAction func generateQRCodeButton(_ sender: UIButton) {
        /*
            BEGIN:VCARD
            VERSION:2.1
            FN:John Peter
            N:Peter;John
            TITLE:Admin
            TEL;CELL:+91 431 524 2345
            TEL;WORK;VOICE:+91 436 542 8374
            EMAIL;WORK;INTERNET:John@ommail.in
            URL:www.facebook.com
            ADR;WORK:;;423 ofce sales Center;Newark;DE;3243;USA
            ORG:xxx Private limited
            END:VCARD
         */
        //SMSTO:5551231234:other message stuff
        let vCard = "BEGIN:VCARD\nVERSION:2.1\nFN:\(fName.text!))\nN:\(fName.text!));\(lName.text!))\nTITLE:\(mPosition.text!)\nTEL;CELL:\(mPhone.text!)\nEMAIL;WORK;INTERNET:\(mEmail.text!)\nEND:VCARD"
        let smsMessage = "SMSTO:\(mPhone.text!):Thanks for using Blink. Download the app at https://ledgerleap.com/apps/blink/IOS/"
        
        //print(vCard);
        // let data = vCard.data(using: .utf8)
        //print("\nutf8 formatted\n", data?.first!)
        let image = generateQRCode(from: vCard)
        let sms = generateQRCode(from: smsMessage)
        smsImage = sms!
        qrImage.image = image!
        //qrImage.image = sms!
        //myGeneratedQR.didCreateQRImage(image: image!)
        //dismiss(animated: true, completion: nil)
        if delegate != nil{
            if qrImage.image != nil {
                let data = qrImage.image
                delegate?.didCreateQRImage(image: data!)
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
}

