//
//  ThirdViewController.swift
//  blink
//
//  Created by Deedcoin Office on 3/28/19.
//  Copyright © 2019 Deedcoin Office. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var lName: UITextField!
    @IBOutlet weak var mPosition: UITextField!
    @IBOutlet weak var mCompany: UITextField!
    @IBOutlet weak var mEmail: UITextField!
    @IBOutlet weak var mPhone: UITextField!
    @IBOutlet weak var btnGenerate : UIButton!
    
    var smsImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        btnGenerate.layer.cornerRadius = 10
        btnGenerate.setupShadow()
    }
    
    @IBAction func generateQRCodeButton(_ sender: UIButton) {
        
        if fName.text == ""
        {
            self.showAlertMessage(strMessage: "Please enter first name!")
        }
        else if lName.text == ""
        {
            self.showAlertMessage(strMessage: "Please enter last name!")
            
        }
        else if mPhone.text == ""
        {
            self.showAlertMessage(strMessage: "Please enter phone number!")
        }
        else{
        
        
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
        let vCard = "BEGIN:VCARD\nVERSION:2.1\nFN:\(fName.text!)\nN:\(fName.text!);\(lName.text!)\nTITLE:\(mPosition.text!)\nTEL;CELL:\(mPhone.text!)\nEMAIL;WORK;INTERNET:\(mEmail.text!)\nEND:VCARD"
        let smsMessage = "SMSTO:\(mPhone.text!):Thanks for using iKontact. Download the app at https://ledgerleap.com/apps/iKontact/IOS/"
        
        let image = generateQRCode(from: vCard)
        let sms = generateQRCode(from: smsMessage)
        
        let dicQRCode = NSMutableDictionary()
        dicQRCode.setValue(image, forKey: "vCard")
        dicQRCode.setValue(sms, forKey: "SMS")
        
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: dicQRCode, requiringSecureCoding: true)
            
            UserDefaults.standard.setValue(data, forKey: "QRCodeDetails")
            UserDefaults.standard.synchronize()
            
            self.tabBarController?.selectedIndex = 0
            
        }catch{
            
        }
            
        }
        
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            
            filter.setValue(data, forKey: "inputMessage")
            
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            let image = filter.outputImage?.transformed(by: transform)
            let somImage = self.convert(cmage: image!)
            
            return somImage
        }
        return nil
    }
    
    func convert(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func showAlertMessage(strMessage:String)
    {
        let controller = UIAlertController.init(title: "Message", message: strMessage, preferredStyle: .alert)
        
        let actionYes = UIAlertAction.init(title: "Ok", style: .default) { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        controller.addAction(actionYes)
        
        self.present(controller, animated: true, completion: nil)
    }
}

