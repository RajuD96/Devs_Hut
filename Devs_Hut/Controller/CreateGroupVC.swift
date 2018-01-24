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
    
    var emailArry = [String]()
    var selectedEmailArry = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        addEmailsTxtField.delegate = self
        addEmailsTxtField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneBtn.isHidden = true
    }
    
    @objc func textFieldDidChanged() {
        if addEmailsTxtField.text == "" {
            emailArry = []
            tableView.reloadData()
        }else {
            DataService.instance.getEmail(searchQuery: addEmailsTxtField.text!, hanler: { (returnedEmailArry) in
                self.emailArry = returnedEmailArry
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtnWasPressed(_ sender: Any) {
        
    }
}

extension CreateGroupVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell()}
        let profileImage = UIImage(named: "defaultProfileImage")
        
        if selectedEmailArry.contains(emailArry[indexPath.row]){
        cell.congfigureCell(profileImage: profileImage!, email: emailArry[indexPath.row], isSelected: true)
        }else {
            cell.congfigureCell(profileImage: profileImage!, email: emailArry[indexPath.row], isSelected: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath ) as? UserCell else { return }
        if !selectedEmailArry.contains(cell.userEmail.text!) {
            selectedEmailArry.append(cell.userEmail.text!)
            groupMemberLbl.text = selectedEmailArry.joined(separator: " ,")
            doneBtn.isHidden = false
        }else {
            selectedEmailArry = selectedEmailArry.filter({$0 != cell.userEmail.text!})
            if selectedEmailArry.count >= 1 {
                groupMemberLbl.text = selectedEmailArry.joined(separator: " ,")
            }else {
                groupMemberLbl.text = "Add people to your group"
                doneBtn.isHidden = true
            }
        }
    }
}






extension CreateGroupVC:UITextFieldDelegate {}
