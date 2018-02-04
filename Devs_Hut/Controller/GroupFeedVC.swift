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
    override func viewDidLoad() {
        super.viewDidLoad()
        sendBtnView.bindToKeyboard()
//        mainView.bindToKeyboard()

        
    }
//    deinit {
//        mainView.bindToKeyboard()
//    }
//

    @IBAction func sendBtnWasPressed(_ sender: Any) {
        
    }
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismiss(animated: true)
    
}
}
