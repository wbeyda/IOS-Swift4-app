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
       
        //self.setupSplash()
        
        self.setupRootVC()
        
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

