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
        REF_USER.child(uid).updateChildValues(userData)
    }
    
    func getUserName(withUID uid:String,handeler: @escaping(_ userName:String)->()) {
        REF_USER.observeSingleEvent(of: .value) { (userSnapShot) in
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
            
            for user in userSnapShot {
                if user.key == uid {
                    handeler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    
    func postUserMessage(withMessage message:String,forUID uid:String,withGroupKey groupKey:String?, completion:@escaping (_ status:Bool) -> ()) {
        
        if groupKey != nil {
            //send to the grp reference
        }else {
            REF_FEEDS.childByAutoId().updateChildValues(["content":message,"senderId":uid])
            completion(true)
        }
    }

    func getMessage(handler:@escaping (_ messages:[Message])-> ()){
        var messageArry = [Message]()
        REF_FEEDS.observeSingleEvent(of: .value) { (feedMessageSnapShot) in
            guard let feedMessageSnapShot = feedMessageSnapShot.children.allObjects as? [DataSnapshot] else { return }
            
            for message in feedMessageSnapShot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let message = Message(content: content, senderId: senderId)
                
                messageArry.append(message)
            }
            handler(messageArry)
        }
    }
}
