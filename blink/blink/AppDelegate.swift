//
//  AppDelegate.swift
//  blink
//
//  Created by Deedcoin Office on 3/28/19.
//  Copyright © 2019 Deedcoin Office. All rights reserved.
// com.deedcoin.blink.blink

import UIKit
import IQKeyboardManagerSwift
import Contacts
import GoogleSignIn

typealias ContactsHandler = (_ contacts : [CNContact] , _ error : NSError?) -> Void


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var arrContacts : [CNContact] = []
    var contactsStore: CNContactStore?
    var isFromLogin : Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        IQKeyboardManager.shared.enable = true
        
        GIDSignIn.sharedInstance().clientID = "1014056272592-a8pvvbt2ncm7uoa5s1gv32vv46nsd9dn.apps.googleusercontent.com"
       
        self.reloadContacts()

        self.setupSplash()
        
        return true
    }
    
    func setupSplash()
    {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let splashVC = storyBoard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        
        let navigation = UINavigationController.init(rootViewController: splashVC)
        navigation.navigationBar.isHidden  = true
        self.window?.rootViewController = navigation
    }
    
    func setupRootVC()
    {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        let navigation = UINavigationController.init(rootViewController: loginVC)
        navigation.navigationBar.isHidden  = true
        self.window?.rootViewController = navigation
    }
    
    open func reloadContacts() {
        getContacts( {(contacts, error) in
            if (error == nil) {
                DispatchQueue.main.async(execute: {
                    
                    self.arrContacts = contacts
                })
            }
        })
    }
    
    func getContacts(_ completion:  @escaping ContactsHandler) {
        if contactsStore == nil {
            //ContactStore is control for accessing the Contacts
            contactsStore = CNContactStore()
        }
        let error = NSError(domain: "EPContactPickerErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "No Contacts Access"])
        
        switch CNContactStore.authorizationStatus(for: CNEntityType.contacts) {
        case CNAuthorizationStatus.denied, CNAuthorizationStatus.restricted:
            //User has denied the current app to access the contacts.
            
            let productName = Bundle.main.infoDictionary!["CFBundleName"]!
            
            let alert = UIAlertController(title: "Unable to access contacts", message: "\(productName) does not have access to contacts. Kindly enable it in privacy settings ", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {  action in
                completion([], error)
                
                alert.dismiss(animated: true, completion: nil)
                
            })
            alert.addAction(okAction)
            self.window?.rootViewController!.present(alert, animated: true, completion: nil)
            
        case CNAuthorizationStatus.notDetermined:
            //This case means the user is prompted for the first time for allowing contacts
            contactsStore?.requestAccess(for: CNEntityType.contacts, completionHandler: { (granted, error) -> Void in
                //At this point an alert is provided to the user to provide access to contacts. This will get invoked if a user responds to the alert
                if  (!granted ){
                    DispatchQueue.main.async(execute: { () -> Void in
                        completion([], error! as NSError?)
                    })
                }
                else{
                    self.getContacts(completion)
                }
            })
            
        case  CNAuthorizationStatus.authorized:
            //Authorization granted by user for this app.
            var contactsArray = [CNContact]()
            
            let contactFetchRequest = CNContactFetchRequest(keysToFetch: allowedContactKeys())
            
            do {
                try contactsStore?.enumerateContacts(with: contactFetchRequest, usingBlock: { (contact, stop) -> Void in
                    //Ordering contacts based on alphabets in firstname
                    
                    contactsArray.append(contact)
                    
                })
                
                completion(contactsArray, nil)
                
            }
                //Catching exception as enumerateContactsWithFetchRequest can throw errors
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func allowedContactKeys() -> [CNKeyDescriptor]{
        //We have to provide only the keys which we have to access. We should avoid unnecessary keys when fetching the contact. Reducing the keys means faster the access.
        return [CNContactNamePrefixKey as CNKeyDescriptor,
                CNContactGivenNameKey as CNKeyDescriptor,
                CNContactFamilyNameKey as CNKeyDescriptor,
                CNContactOrganizationNameKey as CNKeyDescriptor,
                CNContactBirthdayKey as CNKeyDescriptor,
                CNContactImageDataKey as CNKeyDescriptor,
                CNContactThumbnailImageDataKey as CNKeyDescriptor,
                CNContactImageDataAvailableKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor,
                CNContactEmailAddressesKey as CNKeyDescriptor,
                CNContactPostalAddressesKey as CNKeyDescriptor
            
        ]
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
      
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
        
        
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

