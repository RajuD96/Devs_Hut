//
//  FirstViewController.swift
//  Devs_Hut
//
//  Created by Raju Dhumne on 20/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var messageArry = [Message]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.getMessage { (returnMessageArray) in
            self.messageArry = returnMessageArray.reversed()
            self.tableView.reloadData()
        }
    }
}

extension FeedVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedCell else {return UITableViewCell()}
        
        let message = messageArry[indexPath.row]
        let image = UIImage(named: "defaultProfileImage")
        
        DataService.instance.getUserName(withUID: message.senderId) { (returnedUserName) in
            DataService.instance.getProfilePhoto(forUserId: message.senderId, handler: { (returnedImage) in
                if returnedImage == nil {
                    cell.configureCell(userImage: image!, email: returnedUserName, message: message.content)
                }
                else {
                    cell.configureCell(userImage: returnedImage!, email: returnedUserName, message: message.content)
                }
            })
        }
        
        return cell
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, nil) in
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}



