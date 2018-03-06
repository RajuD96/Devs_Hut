//
//  AuthVC.swift
//  Devs_Hut
//
//  Created by Raju Dhumne on 20/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class AuthVC: UIViewController,FBSDKLoginButtonDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "feedVC")
        presentDetails(vc!)
    }
    

    @IBOutlet weak var fbLoginBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func signInWithByEmailBtnWasPressed(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        present(loginVC!, animated: true, completion: nil)
    }
    
    @IBAction func googleBtnWasPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        
    }
    @IBAction func facebookBtnWasPressed(_ sender: Any) {
       
        var loginBtn: FBSDKLoginButton = FBSDKLoginButton()
        loginBtn.readPermissions = ["email"]
        loginBtn.delegate = self
        loginBtn.sendActions(for: .touchUpInside)
        
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    
        if error != nil {
            print(error.localizedDescription)
        }
        else if result.isCancelled {
            print("User has cancels login")
        } else {
            
            let credentials = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            Auth.auth().signIn(with: credentials, completion: { (user, error) in
                if error != nil {
                    print("something wrong with user ",error ?? "")
                    return
                }
            print("successfully loggin in with your fb",user ?? "")
            })
            
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id,email,name"]).start(completionHandler: { (connection, result, error) in
                if error != nil {
                    print("%%%%%%%%%%%%%%%%%",error ?? "")
                }
                let viewToPresent = self.storyboard?.instantiateViewController(withIdentifier: "feedVC")
                self.presentDetails(viewToPresent!)
                
            })
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
}
