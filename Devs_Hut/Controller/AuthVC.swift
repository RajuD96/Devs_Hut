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
    
    @IBAction func facebookBtnWasPressed(_ sender: Any) {
        var loginBtn: FBSDKLoginButton = FBSDKLoginButton()
        loginBtn.readPermissions = ["email"]
        loginBtn.delegate = self
        loginBtn.sendActions(for: .touchUpInside)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print("Something went wrong",error)
        }
        
        guard let accessToken = FBSDKAccessToken.current() else { return }
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        Auth.auth().signIn(with: credentials) { (user, error) in
            if error != nil {
                print("problem with user login",error ?? "")
            }
            else {
                print("successfully log in ", user ?? "")
            }
        }
        saveUserDataToFirebase()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "feedVC")
        self.presentDetails(vc!)
        
        
    }
    
    func saveUserDataToFirebase() {
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id,email,name"]).start { (connection, result, error) in
            if error != nil {
                
                print("something went wrong please try again",error ?? "")
            }
            
            
            print("\(result ?? "")")
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("############################")
            return
            
        }
        
        let userData = ["provider": "Facebook", "email": Auth.auth().currentUser?.email]
        
        DataService.instance.createDBUser(uid: uid, userData: userData)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
}
