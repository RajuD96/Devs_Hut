//
//  GroupFeedVC.swift
//  Devs_Hut
//
//  Created by Raju Dhumne on 04/02/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController {

    @IBOutlet weak var membersLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var sendBtnView: UIView!
    @IBOutlet weak var textField: InsetTxtField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet var mainView: UIView!
    
    var group:Group?
    var groupMessage = [Message]()
    
    func initData(forGroup group:Group) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        sendBtnView.bindToKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTitleLbl.text = group?.groupTitle
        
        DataService.instance.getEmails(group: group!) { (returnEmails) in
            self.membersLbl.text = returnEmails.joined(separator: ", ")
        }
        
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllGroupsMessages(desiredGroup: self.group!, handler: { (returnedGroupMessage) in
                self.groupMessage = returnedGroupMessage
                self.tableView.reloadData()
                
                if self.groupMessage.count > 0 {
                 self.tableView.scrollToRow(at: IndexPath(row: self.groupMessage.count - 1, section: 0), at: .none, animated: true)
                }
            })
        }
    }


    @IBAction func sendBtnWasPressed(_ sender: Any) {
        if textField.text != "" {
            textField.isEnabled = false
            sendBtn.isEnabled = false
            DataService.instance.postUserMessage(withMessage: textField.text!, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: group?.key, completion: { (complete) in
               
                if complete {
                    self.textField.text = ""
                    self.textField.isEnabled = true
                    self.sendBtn.isEnabled = true
                }
                
            })
        }
    }
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismiss(animated: true)
    }

}

extension GroupFeedVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupFeedCell", for: indexPath) as? GroupFeedCell else { return UITableViewCell() }
        
        let message = groupMessage[indexPath.row]
        DataService.instance.getUserName(withUID: message.senderId) { (email) in
            cell.configureCell(profileImage: UIImage(named: "defaultProfileImage")!, email: email, content: message.content)
        }
        return cell
    }
    
}



