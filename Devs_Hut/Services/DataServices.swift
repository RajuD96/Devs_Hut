//
//  DataServices.swift
//  Devs_Hut
//
//  Created by Raju Dhumne on 20/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USER = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEEDS = DB_BASE.child("feeds")
    
    var REF_BASE:DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USER:DatabaseReference {
        return _REF_USER
    }
    
    var REF_GROUPS:DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_FEEDS:DatabaseReference {
        return _REF_FEEDS
    }
    
    func createDBUser(uid:String, userData:Dictionary<String,Any>) {
        
        REF_BASE.child(uid).updateChildValues(userData)
    }
    
    
    
    
    
    
    
    
    
}
