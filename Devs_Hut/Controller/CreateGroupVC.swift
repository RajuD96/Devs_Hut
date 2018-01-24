//
//  CreateGroupVC.swift
//  Devs_Hut
//
//  Created by Raju Dhumne on 24/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit

class CreateGroupVC: UIViewController {

    
    @IBOutlet weak var titleTxtField: InsetTxtField!
    @IBOutlet weak var descriptionTxtfield: InsetTxtField!
    @IBOutlet weak var addEmailsTxtField: InsetTxtField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupMemberLbl: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
       
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
    }
    
    @IBAction func doneBtnWasPressed(_ sender: Any) {
    }

}



extension CreateGroupVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell()}
        let profileImage = UIImage(named: "defaultProfileImage")
        cell.congfigureCell(profileImage: profileImage!, email: "user@devslopes", isSelected: true)
        
        return cell
        
    }
 
}
