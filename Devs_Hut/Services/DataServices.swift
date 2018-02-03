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
    
    func getEmail(searchQuery query:String,handler: @escaping (_ emailArry:[String])-> ()) {
        
        var emailArry = [String]()
        
        REF_USER.observeSingleEvent(of: .value) { (userSnapShot) in
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else{ return }
            
            for user in userSnapShot {
                let email = user.childSnapshot(forPath: "email").value as! String
            
                if email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    emailArry.append(email)
                }
            }
            handler(emailArry)
        }
    }
    
    func getIds(forUserName userNames:[String], handler: @escaping (_ uidArry:[String]) ->()){
        var idsArry = [String]()
        REF_USER.observeSingleEvent(of: .value) { (userSnapShot) in
          guard  let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in userSnapShot {
                let email = user.childSnapshot(forPath: "email").value as! String
                
                if userNames.contains(email){
                    idsArry.append(user.key)
                }
            }
            handler(idsArry)
        }
    }
    
    func createGroup(groupTitle title:String,groupDescription description: String,grpIds ids:[String],handler:@escaping (_ groupCreted:Bool) -> ()){
        REF_GROUPS.childByAutoId().updateChildValues(["title":title,"description":description,"members":ids])
            handler(true)
    }
    
    func getAllGroups( handler: @escaping (_ groupArray:[Group])->()) {
        
        var groupsArry = [Group]()
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapShot) in
            guard let groupSnapShot = groupSnapShot.children.allObjects as? [DataSnapshot] else { return }
            for group in groupSnapShot {
                if let memberArry = group.childSnapshot(forPath: "members").value as? [String]
                {
                    if memberArry.contains((Auth.auth().currentUser?.uid)!) {
                        let title = group.childSnapshot(forPath: "title").value as! String
                        let description = group.childSnapshot(forPath: "description").value as! String
                        let group = Group(title: title, description: description, key: group.key, members: memberArry, memberCount: memberArry.count)
                        groupsArry.append(group)
                
                    }
                }
            }
            handler(groupsArry)
        }
    }
    
    
    
    
    
    
    
}
