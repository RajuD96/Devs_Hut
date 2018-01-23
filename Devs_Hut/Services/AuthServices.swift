//
//  AuthServices.swift
//  Devs_Hut
//
//  Created by Raju Dhumne on 22/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    
    static let instance = AuthService()
    
    func registerUser(withEmail email:String, andPassword password:String,registerUserComplete: @escaping (_ status:Bool,_ error:Error?)->()) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                registerUserComplete(false, error)
                return
            }
            let userData = ["provider": user.providerID, "email": user.email]
            DataService.instance.createDBUser(uid: user.uid, userData: userData)
            registerUserComplete(true, nil)
            
        }
    }
    
    func loginUser(withEmail email:String, andPassWord password:String,loginUserComplete: @escaping (_ status:Bool, _ error:Error?) -> ()) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil{
                loginUserComplete(false, error)
                return
            }
            loginUserComplete(true, nil)
        }
        
        
        
        
        
        
        
        
        
        
        
    }
    
}
