//
//  GroupFeedVC.swift
//  Devs_Hut
//
//  Created by Raju Dhumne on 04/02/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit

class GroupFeedVC: UIViewController {

    @IBOutlet weak var membersLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var sendBtnView: UIView!
    @IBOutlet weak var textField: InsetTxtField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet var mainView: UIView!
    
    var group:Group?
    
    func initData(forGroup group:Group) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     mainView.bindToKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTitleLbl.text = group?.groupTitle
        
        DataService.instance.getEmails(group: group!) { (returnEmails) in
            self.membersLbl.text = returnEmails.joined(separator: ", ")
            
        }
        membersLbl.text = group?.members.joined(separator: ", ")
        
    }


    @IBAction func sendBtnWasPressed(_ sender: Any) {
        
        
    }
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismiss(animated: true)
    
}
    
   
}
