//
//  LoginViewController.swift
//  blink
//
//  Created by Dharmesh Sonani on 12/04/19.
//  Copyright © 2019 Deedcoin Office. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {

    @IBOutlet weak var btnSignIn : UIButton!
    @IBOutlet weak var btnSkip : UIButton!
    
    var dicResultGoogle : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        btnSignIn.layer.cornerRadius = 10
        
        btnSignIn.setupShadow()
    }
    
    @IBAction func clickOnSkip(sender:UIButton)
    {
       self.setupSetting()
    }
    
    @IBAction func clickOnSignIn(sender:UIButton)
    {
         GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            
            let userId = user.userID
            let email = user.profile.email
            
            let dic = NSMutableDictionary()
            dic.setValue(userId, forKey: "userID")
            dic.setValue(email, forKey: "email")
            
            self.showAlertMessage(strMessage: "login successfully!")
            
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func setupSetting()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "BaseTabBarController") as! UITabBarController
        
        // check if already QR code stored
        if UserDefaults.standard.object(forKey: "QRCodeDetails") != nil{
            
            tabBarController.selectedIndex = 0
            appDelegate.isFromLogin = false
        }
        else{
            tabBarController.selectedIndex = 2
            appDelegate.isFromLogin = true
        }
        
        
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
    
    func showAlertMessage(strMessage:String)
    {
        let controller = UIAlertController.init(title: "Message", message: strMessage, preferredStyle: .alert)
        
        let actionYes = UIAlertAction.init(title: "Ok", style: .default) { (action) in
            
            self.setupSetting()
            self.dismiss(animated: true, completion: nil)
        }
        
        controller.addAction(actionYes)
        
        self.present(controller, animated: true, completion: nil)
    }
}
