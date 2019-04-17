//
//  ThirdViewController.swift
//  blink
//
//  Created by Deedcoin Office on 3/28/19.
//  Copyright © 2019 Deedcoin Office. All rights reserved.
//

import UIKit
import Contacts
import CoreTelephony

class ThirdViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var lName: UITextField!
    @IBOutlet weak var mPosition: UITextField!
    @IBOutlet weak var mCompany: UITextField!
    @IBOutlet weak var mEmail: UITextField!
    @IBOutlet weak var mPhone: UITextField!
    @IBOutlet weak var txtBusineessPhone: UITextField!
    @IBOutlet weak var txtBusineessEmail: UITextField!
    @IBOutlet weak var btnGenerate : UIButton!
    @IBOutlet weak var mFacebook: UITextField!
    @IBOutlet weak var mTwitter: UITextField!
    @IBOutlet weak var mInstagram: UITextField!
    @IBOutlet weak var btnEdit : UIButton!
    @IBOutlet weak var profileView : UIView!
    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var txtName : UITextField!
    @IBOutlet weak var imgCam : UIImageView!
    @IBOutlet weak var lblEdit : UILabel!
    @IBOutlet weak var shadowView : UIView!
    @IBOutlet weak var btnUpload : UIButton!
    @IBOutlet weak var backView : UIView!
    @IBOutlet weak var lblMyCard : UILabel!
    
    var profileImage : UIImage? = nil
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        btnGenerate.layer.cornerRadius = 10
        btnGenerate.setupShadow()
        
        self.setupTextField(textField: fName)
        self.setupTextField(textField: lName)
        self.setupTextField(textField: mPosition)
        self.setupTextField(textField: mCompany)
        self.setupTextField(textField: mEmail)
        self.setupTextField(textField: mPhone)
        self.setupTextField(textField: txtBusineessPhone)
        self.setupTextField(textField: txtBusineessEmail)
        self.setupTextField(textField: mFacebook)
        self.setupTextField(textField: mTwitter)
        self.setupTextField(textField: mInstagram)
        
        if appDelegate.dicLoginDetails.count > 0{
            
            fName.text = appDelegate.dicLoginDetails.value(forKey: "firstName") as? String
            lName.text = appDelegate.dicLoginDetails.value(forKey: "lastName") as? String
            mEmail.text = appDelegate.dicLoginDetails.value(forKey: "email") as? String
            txtName.text = "\(fName.text!) \(lName.text!)"
        }
        
        btnUpload.isUserInteractionEnabled = false
        self.setupTextField(isEnable: false)
        self.setUserDetails()
        
        profileView.layer.borderWidth = 1
        profileView.layer.borderColor = UIColor.darkGray.cgColor
        profileView.layer.cornerRadius = profileView.frame.size.height/2
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setUserDetails()
    {
        
        if UserDefaults.standard.object(forKey: "UserDetails") != nil{
            
            let dicUserDetails = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "UserDetails") as! Data) as! NSMutableDictionary
            
            if dicUserDetails.value(forKey: "Profile") != nil{
                imgProfile.image = (dicUserDetails.value(forKey: "Profile") as! UIImage)
                lblEdit.isHidden = true
                shadowView.isHidden = true
                imgCam.isHidden = true
            }
            
            fName.text = dicUserDetails.value(forKey: "FirstName") as? String
            lName.text = dicUserDetails.value(forKey: "LastName") as? String
            mPosition.text = dicUserDetails.value(forKey: "Position") as? String
            mCompany.text = dicUserDetails.value(forKey: "Company") as? String
            mEmail.text = dicUserDetails.value(forKey: "Email") as? String
            mPhone.text = dicUserDetails.value(forKey: "Phone") as? String
            txtBusineessPhone.text = dicUserDetails.value(forKey: "BusinessPhone") as? String
            txtBusineessEmail.text = dicUserDetails.value(forKey: "BusinessEmail") as? String
            mFacebook.text = dicUserDetails.value(forKey: "Facebook") as? String
            mTwitter.text = dicUserDetails.value(forKey: "Twitter") as? String
            mInstagram.text = dicUserDetails.value(forKey: "Instagram") as? String
            
        }
    }
    
    func setupTextField(isEnable:Bool)
    {
        fName.isUserInteractionEnabled = isEnable
        lName.isUserInteractionEnabled = isEnable
        mPosition.isUserInteractionEnabled = isEnable
        mCompany.isUserInteractionEnabled = isEnable
        mEmail.isUserInteractionEnabled = isEnable
        mPhone.isUserInteractionEnabled = isEnable
        txtBusineessPhone.isUserInteractionEnabled = isEnable
        txtBusineessEmail.isUserInteractionEnabled = isEnable
        mFacebook.isUserInteractionEnabled = isEnable
        mTwitter.isUserInteractionEnabled = isEnable
        mInstagram.isUserInteractionEnabled = isEnable
        
    }
    
    func setupTextField(textField:UITextField)
    {
        let layer = CALayer()
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        layer.frame = CGRect.init(x: 0, y: 34, width: textField.frame.size.width, height: 1)
        textField.layer.addSublayer(layer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if appDelegate.isFromLogin{
            
            appDelegate.isFromLogin = false
            self.openWelcome()
        }
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isTranslucent  = false
    }
    
    @IBAction func clickOnBack(sender:UIButton)
    {
        self.backView.isHidden = true
        self.lblMyCard.isHidden = false
        btnEdit.setTitle("Edit", for: UIControl.State.normal)
        self.setupTextField(isEnable: false)
        btnUpload.isUserInteractionEnabled = false
        
    }
    
    @IBAction func clickOnEdit(sender:UIButton)
    {
        if sender.titleLabel?.text == "Edit"{
            
            sender.setTitle("Done", for: UIControl.State.normal)
            
            btnUpload.isUserInteractionEnabled = true
            self.setupTextField(isEnable: true)
            
            self.backView.isHidden = false
            self.lblMyCard.isHidden = true
            
        }
        else{
            
            self.backView.isHidden = true
            self.lblMyCard.isHidden = false
            sender.setTitle("Edit", for: UIControl.State.normal)
            
            var dicUserDetails = NSMutableDictionary()
            
            if UserDefaults.standard.object(forKey: "UserDetails") != nil{
                
                dicUserDetails = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "UserDetails") as! Data) as! NSMutableDictionary
            }
            
            dicUserDetails.setValue(fName.text!, forKey: "FirstName")
            dicUserDetails.setValue(lName.text!, forKey: "LastName")
            dicUserDetails.setValue(mPosition.text!, forKey: "Position")
            dicUserDetails.setValue(mCompany.text!, forKey: "Company")
            dicUserDetails.setValue(mEmail.text!, forKey: "Email")
            dicUserDetails.setValue(mPhone.text!, forKey: "Phone")
            dicUserDetails.setValue(txtBusineessPhone.text!, forKey: "BusinessPhone")
            dicUserDetails.setValue(txtBusineessEmail.text!, forKey: "BusinessEmail")
            dicUserDetails.setValue(mFacebook.text!, forKey: "Facebook")
            dicUserDetails.setValue(mTwitter.text!, forKey: "Twitter")
            dicUserDetails.setValue(mInstagram.text!, forKey: "Instagram")
            if profileImage != nil{
                dicUserDetails.setValue(profileImage, forKey: "Profile")
            }
            
            let data = NSKeyedArchiver.archivedData(withRootObject: dicUserDetails)
            
            UserDefaults.standard.setValue(data, forKey: "UserDetails")
            UserDefaults.standard.synchronize()
            
            
            self.setupTextField(isEnable: false)
            
        }
    }
    
    func openWelcome()
    {
        let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        
        welcomeVC.modalTransitionStyle = .crossDissolve
        
        if (UIDevice.current.systemVersion as! NSString).floatValue >= 8.0{
            
            welcomeVC.modalPresentationStyle = .overCurrentContext
            welcomeVC.definesPresentationContext = true
        }
        else{
            welcomeVC.modalPresentationStyle = .currentContext
        }
        
        self.present(welcomeVC, animated: true, completion: nil)
    }
    
    @IBAction func clickOnUploadImage(sender:UIButton)
    {
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
        imgProfile.image = selectedImage
        imgCam.isHidden = true
        lblEdit.isHidden = true
        shadowView.isHidden = true
        
        self.profileImage = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
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
            
            //X-SOCIALPROFILE;type=twitter;x-user=twitteruser:http://twitter.com/twitteruser
            //X-SOCIALPROFILE;type=facebook;x-user=facebookuser:http://www.facebook.com/facebookuser
            //X-SOCIALPROFILE;TYPE=instagram:ekspressperevozki
            
            var emptyStringArray: [String] = []
            
            if mFacebook.text != "" {
                emptyStringArray.append("X-SOCIALPROFILE;type=facebook;x-user=facebookuser:http://www.facebook.com/\(mFacebook.text!)\n")
            }
            if mTwitter.text != "" {
                emptyStringArray.append("X-SOCIALPROFILE;type=twitter;x-user=twitteruser:http://twitter.com/\(mTwitter.text!)\n")
            }
            if mInstagram.text != "" {
                emptyStringArray.append("X-SOCIALPROFILE;TYPE=instagram:\(mInstagram.text!)\n")
            }
            
           
            
            if txtBusineessEmail.text != "" || txtBusineessPhone.text != ""
            {
                var vCard = ""
                vCard += "BEGIN:VCARD\nVERSION:2.1\nFN:\(fName.text!)\nN:\(fName.text!);\(lName.text!)\nTITLE:\(mPosition.text!)\nTEL;CELL:\(txtBusineessPhone.text!)\nEMAIL;WORK;INTERNET:\(txtBusineessEmail.text!)\n"
                
                for i in emptyStringArray{
                    vCard.append("\(i)")
                }
                
                vCard.append("END:VCARD")
                print(vCard)
                
                let smsMessage = "SMSTO:\(txtBusineessPhone.text!):Thanks for using Gotcha Contact. Download the app at https://ledgerleap.com/apps/iKontact/IOS/"
                
                let image = generateQRCode(from: vCard)
                let sms = generateQRCode(from: smsMessage)
                
                let dicQRCode = NSMutableDictionary()
                dicQRCode.setValue(image, forKey: "vCard")
                dicQRCode.setValue(sms, forKey: "SMS")
                
                do{
                    let data = try NSKeyedArchiver.archivedData(withRootObject: dicQRCode, requiringSecureCoding: true)
                    
                    UserDefaults.standard.setValue(data, forKey: "QRCodeDetailsBusiness")
                    UserDefaults.standard.synchronize()
                    
                }catch{
                    
                }
            }
           
            var newvCard = ""
            
            newvCard.append("BEGIN:VCARD\nVERSION:2.1\nFN:\(fName.text!)\nN:\(fName.text!);\(lName.text!)\nTITLE:\(mPosition.text!)\nTEL;CELL:\(mPhone.text!)\nEMAIL;WORK;INTERNET:\(mEmail.text!)\n")
            for i in emptyStringArray{
                newvCard.append("\(i)")
            }
            newvCard.append("END:VCARD")
            
            let smsMessage = "SMSTO:\(mPhone.text!):Thanks for using iKontact. Download the app at https://ledgerleap.com/apps/iKontact/IOS/"
            
            let image = generateQRCode(from: newvCard)
            let sms = generateQRCode(from: smsMessage)
            
            let dicQRCode = NSMutableDictionary()
            dicQRCode.setValue(image, forKey: "vCard")
            dicQRCode.setValue(sms, forKey: "SMS")
            
            do{
                let data = try NSKeyedArchiver.archivedData(withRootObject: dicQRCode, requiringSecureCoding: true)
                
                UserDefaults.standard.setValue(data, forKey: "QRCodeDetails")
                UserDefaults.standard.synchronize()
                
            }catch{
                
            }
            
            self.tabBarController?.selectedIndex = 0
            
            /*
            let newDict = NSMutableDictionary()
            newDict.setValue(fName.text!, forKey: "FirstName")
            newDict.setValue(lName.text!, forKey: "LastName")
            newDict.setValue(mPosition.text!, forKey: "Position")
            newDict.setValue(mCompany.text!, forKey: "Company")
            newDict.setValue(mEmail.text!, forKey: "email")
            newDict.setValue(mPhone.text!, forKey: "phoneNumber")
            newDict.setValue(imgProfile.image, forKey: "Profile")

            let contactVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactsViewController") as! ContactsViewController
            contactVC.isFromGenerateCode = true
            contactVC.dicDetail = newDict
            self.navigationController?.pushViewController(contactVC, animated: true)
              */
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

