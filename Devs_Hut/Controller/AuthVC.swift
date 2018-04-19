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



class AuthVC: UIViewController,GIDSignInUIDelegate, GIDSignInDelegate,FBSDKLoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    
    // Google Sign-In
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
                NotificationCenter.default.post(name: USER_IMAGE_LOADED, object: nil)
                
                guard let uid = user?.uid else { return }
                print("Sucessfully logged in to Firebase with Google", uid)
                
                let userInfo = ["provider": "Google","email": Auth.auth().currentUser?.email]
                
                DataService.instance.createDBUser(uid: (Auth.auth().currentUser?.uid)!, userData: userInfo)
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "feedVC")
                self.presentDetails(vc!)
            }
        })
    }
    
    
    @IBAction func signInWithByEmailBtnWasPressed(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        present(loginVC!, animated: true, completion: nil)
    }
    
    @IBAction func googleBtnWasPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    //Facebook Sign-In
    @IBAction func facebookBtnWasPressed(_ sender: Any) {
        
        var loginBtn: FBSDKLoginButton = FBSDKLoginButton()
        loginBtn.readPermissions = ["email"]
        loginBtn.delegate = self
        loginBtn.sendActions(for: .touchUpInside)
        
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print("Something went wrong")
        }
        
        guard let accessToken = FBSDKAccessToken.current() else {return}
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        
        Auth.auth().signIn(with: credentials) { (user, error) in
            if error != nil {
                print("@@@@@@@@",error ?? "")
            }else {
                
                NotificationCenter.default.post(name: USER_IMAGE_LOADED, object: nil)
                
                let userInfo = ["provider":"Facebook","email":Auth.auth().currentUser?.email]
                guard let uid = Auth.auth().currentUser?.uid else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                
                DataService.instance.createDBUser(uid: uid, userData: userInfo)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "feedVC")
                self.presentDetails(vc!)
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logout")
    }
}
