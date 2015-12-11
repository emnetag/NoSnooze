//
//  ViewController.swift
//  NoSnooze
//
//  Created by user on 12/1/15.
//  Copyright © 2015 emnetg. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var loginButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var loginStatusLabel: UILabel!
    
    var currentUser: FAuthData!
    var ref = Firebase(url: "https://nosnooze.firebaseIO.com/")
    
    var facebookLogin: FBSDKLoginManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginStatusLabel.hidden = true
        self.loginStatusLabel.lineBreakMode = .ByWordWrapping
        self.loginStatusLabel.numberOfLines = 0
        
        //self.logoutButton.hidden = true
        
        //set FBSDKLoginManager
        if self.facebookLogin === nil {
            self.facebookLogin = FBSDKLoginManager()
        }
    }
    
    @IBAction func logoutDidTouch(sender: AnyObject?) {
        print("Logging Out")
        self.ref.unauth()
        self.facebookLogin.logOut()
        updateUIAndSetCurrentUser(nil)
    }
    
    func updateUIAndSetCurrentUser(currentUser: FAuthData?) -> Void {
        self.currentUser = currentUser
        
        if self.currentUser === nil {
            print("CurrentUser is nil")
            self.loginStatusLabel.hidden = true
            self.loginButton.hidden = false
            self.logoutButton.hidden = true
        } else {
            var statusText = ""
            
            if currentUser?.provider == "facebook" {
                statusText = "Logged in as \(currentUser?.providerData["displayName"]) (Facebook)"
            }
            
            self.loginStatusLabel.text = statusText
            self.loginStatusLabel.hidden = false
            
            //show the logout button
            self.logoutButton.hidden = false
            
            //hide the login button for now
            self.loginButton.hidden = true
        }
    }
    
    
    @IBAction func loginDidTouch(sender: UIButton) {
        print("Login Button Pressed")
        
        
        self.facebookLogin.logInWithReadPermissions(["email", "user_friends"], fromViewController: self) {
            (facebookResult, facebookError) -> Void in
            
            if facebookError != nil {
                print("Facebook login failed. \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                self.ref.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { (error, authData) -> Void in
                        
                        if error != nil {
                            print("Login failed. \(error)")
                        } else {
                            let newUser = [
                                "provider": authData.provider,
                                "displayName": authData.providerData["displayName"]!,
                                "uid": authData.uid
                            ]
                            print("Added user \(newUser["displayName"]))")
                            
                            self.ref.childByAppendingPath("users")
                               .childByAppendingPath(authData.uid).setValue(newUser)
                            
                            let sb = UIStoryboard(name: "LandingPage", bundle: nil)
                            let VC = sb.instantiateInitialViewController() as! UINavigationController
                            self.presentViewController(VC, animated: true, completion: nil)

                        }
                })
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.ref.observeAuthEventWithBlock { (authData) -> Void in
            if authData == nil {
                print("No one is home")
            } else {
                print("Someone is home, \(authData.providerData["displayName"]!) to be specific")
//                self.updateUIAndSetCurrentUser(authData)
                let sb = UIStoryboard(name: "AlarmActive", bundle: nil)
                let VC = sb.instantiateInitialViewController() as UIViewController!
                self.presentViewController(VC!, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

