//
//  ContactsViewController.swift
//  blink
//
//  Created by Deedcoin Office on 4/8/19.
//  Copyright © 2019 Deedcoin Office. All rights reserved.
//

import UIKit
import Contacts

class ContactsViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstLastText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var positionText: UITextField!
    @IBOutlet weak var companyText: UITextField!
    @IBOutlet weak var rateView: HCSStarRatingView!
    
    var contact : Contact!
    var isFromGenerateCode : Bool = false
    var dicDetail = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstLastText.delegate = self
        phoneText.delegate = self
        emailText.delegate = self
        companyText.delegate = self
        
        let btnDone = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(clickOnDone))
        
        self.navigationItem.rightBarButtonItem = btnDone
        
        if self.isFromGenerateCode{
            
            self.rateView.value = 0.0
            firstLastText.text = "\(dicDetail.value(forKey: "FirstName") as! String) \(dicDetail.value(forKey: "LastName") as! String)"
            
            phoneText.text = "\(dicDetail.value(forKey: "phoneNumber") as! String)"
            companyText.text = "\(dicDetail.value(forKey: "Company") as! String)"
            positionText.text = "\(dicDetail.value(forKey: "Position") as! String)"
            emailText.text = "\(dicDetail.value(forKey: "email") as! String)"

        }
        else{
            self.setupContactDetails()
        }
        
        self.setupTextField(textField: phoneText)
        self.setupTextField(textField: companyText)
        self.setupTextField(textField: positionText)
        self.setupTextField(textField: emailText)
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setupContactDetails()
    {
        if contact.profileImage != nil{
            profileImage.image = contact.profileImage
        }
        
        firstLastText.text = "\(contact.firstName) \(contact.lastName)"
        phoneText.text = contact.phoneNumbers[0].phoneNumber
        if contact.emails.count > 0{
            emailText.text = contact.emails[0].email
        }
        companyText.text = contact.company
        self.rateView.value = CGFloat((contact.rating as! NSString).floatValue)
    }
    
    func setupTextField(textField:UITextField!)
    {
        let layer = CALayer()
        layer.borderWidth = 1
        layer.frame = CGRect.init(x: 0, y: textField.frame.size.height-1, width: textField.frame.size.width, height: 1)
        layer.borderColor = UIColor.gray.cgColor
        
        textField.layer.addSublayer(layer)
    }
    
    /*let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(URLResponse.self))
     profileImage.addGestureRecognizer(tapGestureRecognizer)
     profileImage.isUserInteractionEnabled = true
     */
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectContactImageGesture(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        
        firstLastText.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        profileImage.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    func setupContactImage()
    {
        if UserDefaults.standard.object(forKey: "ImageContact") != nil
        {
             let dic = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "ImageContact") as! Data) as! NSMutableDictionary
            
            if dic.value(forKey: phoneText.text!) != nil{
                
                let newDic = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "ImageContact") as! Data) as! NSMutableDictionary
                
                newDic.setValue(profileImage.image, forKey: phoneText.text!)
                
                let data = NSKeyedArchiver.archivedData(withRootObject: newDic)
                
                UserDefaults.standard.setValue(data, forKey: "ImageContact")
                UserDefaults.standard.synchronize()
            }
            else{
                
                let dic = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "ImageContact") as! Data) as! NSMutableDictionary

                dic.setValue(profileImage.image, forKey: phoneText.text!)
                
                let data = NSKeyedArchiver.archivedData(withRootObject: dic)

                UserDefaults.standard.setValue(data, forKey: "ImageContact")
                UserDefaults.standard.synchronize()
            }
            
            
        }
        else{
            
            let dic = NSMutableDictionary()
          
            dic.setValue(profileImage.image, forKey: phoneText.text!)
            let data = NSKeyedArchiver.archivedData(withRootObject: dic)

            UserDefaults.standard.setValue(data, forKey: "ImageContact")
            UserDefaults.standard.synchronize()
            
        }
    }
    
    func setupNewQRcode()
    {
        let arrName = firstLastText.text?.components(separatedBy: " ")
        
        var vCard  : String!
        
        if (arrName?.count)! > 1{
            vCard = "BEGIN:VCARD\nVERSION:2.1\nFN:\(arrName![0])\nN:\(arrName![0]);\(arrName![1])\nTITLE:\(positionText.text!)\nTEL;CELL:\(phoneText.text!)\nEMAIL;WORK;INTERNET:\(emailText.text!)\nEND:VCARD"
        }
        else{
            vCard = "BEGIN:VCARD\nVERSION:2.1\nFN:\(arrName![0])\nN:\(arrName![0]);\(arrName![0])\nTITLE:\(positionText.text!)\nTEL;CELL:\(phoneText.text!)\nEMAIL;WORK;INTERNET:\(emailText.text!)\nEND:VCARD"
        }
        
        let smsMessage = "SMSTO:\(phoneText.text!):Thanks for using iKontact. Download the app at https://ledgerleap.com/apps/iKontact/IOS/"
        
        let image = generateQRCode(from: vCard)
        let sms = generateQRCode(from: smsMessage)
        
        let dicQRCode = NSMutableDictionary()
        dicQRCode.setValue(image, forKey: "vCard")
        dicQRCode.setValue(sms, forKey: "SMS")
        
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: dicQRCode, requiringSecureCoding: true)
            
            UserDefaults.standard.setValue(data, forKey: "QRCodeDetails")
            UserDefaults.standard.synchronize()
        }
        catch{
            
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
    
    @objc func clickOnDone()
    {
        self.setupNewQRcode()
        
        contact.rating = "\(rateView.value)"
        
        if UserDefaults.standard.object(forKey: "rateDetails") != nil
        {
            let dic = UserDefaults.standard.object(forKey: "rateDetails") as! NSMutableDictionary
            
            if dic.value(forKey: phoneText.text!) != nil{
                
                let newDic = NSMutableDictionary.init(dictionary: UserDefaults.standard.object(forKey: "rateDetails") as! [AnyHashable:Any])
                newDic.setValue("\(rateView.value)", forKey: phoneText.text!)
                
                UserDefaults.standard.setValue(newDic, forKey: "rateDetails")
                UserDefaults.standard.synchronize()
            }
            else{
                let dic = NSMutableDictionary.init(dictionary: UserDefaults.standard.object(forKey: "rateDetails") as! [AnyHashable:Any])
                dic.setValue("\(rateView.value)", forKey: phoneText.text!)
                UserDefaults.standard.setValue(dic, forKey: "rateDetails")
                UserDefaults.standard.synchronize()
            }
            
           
        }
        else{
            
            let dic = NSMutableDictionary()
            dic.setValue("\(rateView.value)", forKey: phoneText.text!)
            UserDefaults.standard.setValue(dic, forKey: "rateDetails")
            UserDefaults.standard.synchronize()
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadContact"), object: nil, userInfo: nil)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.setupContactImage()
    }
}
