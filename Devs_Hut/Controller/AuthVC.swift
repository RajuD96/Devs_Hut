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
            if let err = error {
                print ("Failed to log in with Google: ", err)
                return
            }
            
            print ("Successfully logged in with Google", user)
            
            guard let idToken = user.authentication.idToken else { return }
            guard let accessToken = user.authentication.accessToken else { return }
            
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            Auth.auth().signIn(with: credentials, completion: { (user, error) in
                if let err = error {
                    print("Failed to create a Firebase User with Google: ", err)
                    return
                } else {
                    
                    guard let uid = user?.uid else { return }
                    print("Sucessfully logged in to Firebase with Google", uid)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "feedVC")
                    self.presentDetails(vc!)
                    
                }
            })
        }
    

    @IBOutlet weak var fbLoginBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
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
        GIDSignIn.sharedInstance().signOut()
        
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
