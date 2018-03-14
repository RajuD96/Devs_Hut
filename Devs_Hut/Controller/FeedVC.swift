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
        tableView.tableFooterView = UIView(frame: CGRect.zero)
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
        DataService.instance.getUserName(withUID: message.senderId) { (returnedUserName) in
            DataService.instance.getProfilePhoto(forUserId: message.senderId, handler: { (returnedUrl) in
                cell.configureCell(image: returnedUrl, email: returnedUserName, message: message.content)
            })
        }
        return cell
    }
}
