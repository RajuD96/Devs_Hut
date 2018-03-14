//
//  MeVC.swift
//  Devs_Hut
//
//  Created by Raju Dhumne on 22/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import GoogleSignIn
import FBSDKLoginKit
import Kingfisher


class MeVC: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView! 
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var groups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       fetchGroups()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (handleTapGesture)))
        profileImage.isUserInteractionEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(fetchProfileImage), name: USER_IMAGE_LOADED, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailLbl.text = Auth.auth().currentUser?.email
    }
    
    @objc func fetchProfileImage() {
        DataService.instance.getProfilePhoto(forUserId: (Auth.auth().currentUser?.uid)!) { (returnedUrl) in
            if returnedUrl != nil {
                self.profileImage.kf.setImage(with: returnedUrl)
            }else {
                self.profileImage.image = UIImage(named: "defaultProfileImage")
            }
        }
    }
    
    func fetchGroups(){
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllGroups(handler: { (groupInfo) in
                self.groups = groupInfo
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func signOutBtnWasPressed(_ sender: Any) {
        let logOutPopUp = UIAlertController(title: "Logout", message: "Are you sure ..?", preferredStyle: .actionSheet)
        let logOutAction = UIAlertAction(title: "Logout", style: .destructive) { (ButtonTapped) in
            do{
                try Auth.auth().signOut()
                GIDSignIn.sharedInstance().signOut()
                FBSDKLoginManager().logOut()
                
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
                
                self.present(authVC!, animated: true, completion: nil)
                self.profileImage.image = UIImage(named: "defaultProfileImage")
            }catch {
                print(error)
            }
        }
    
        let logoutCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        logOutPopUp.addAction(logOutAction)
        logOutPopUp.addAction(logoutCancel)
        present(logOutPopUp, animated: true, completion: nil)
    }
}

extension MeVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @objc func handleTapGesture() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker : UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
            self.profileImage.image = selectedImageFromPicker
        }
        
        if let uploadData = UIImageJPEGRepresentation(selectedImageFromPicker!, 0.8) {
            let imgUid = Auth.auth().currentUser?.uid
            DataService.instance.REF_STORE_PROFILEIMG.child(imgUid!).putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("unable to upload image")
                }else {
                    print("successfully image upload")
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    if let url = downloadUrl {
                        
                        let profileUrl = ["profileImageUrl":url]
                        
                        DataService.instance.uploadProfileImage(uid: (Auth.auth().currentUser?.uid)!, userData: profileUrl, handler: { (success) in
                            if success {
                                print("Profile image was successfully stored")
                            }
                            else {
                        print("unable to store image into storage")
                            }
                        })
                    }
                }
            })
        }else {
            print("image was not selected")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension MeVC : UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "meCell", for: indexPath) as? MeCell else { return UITableViewCell()}
        let group = groups[indexPath.row]
        
        cell.configureCell(groupTitle: group.groupTitle)
        return cell
        
    }
}
