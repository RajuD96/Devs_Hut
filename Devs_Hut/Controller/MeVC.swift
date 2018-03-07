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


class MeVC: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView! 
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (handleTapGesture)))
        profileImage.isUserInteractionEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailLbl.text = Auth.auth().currentUser?.email
        
        DataService.instance.getProfilePhoto(forUserId: (Auth.auth().currentUser?.uid)!) { (returnedImage) in
            self.profileImage.image = returnedImage
        }
    }
    
    @IBAction func signOutBtnWasPressed(_ sender: Any) {
        let logOutPopUp = UIAlertController(title: "Logout", message: "Are you sure ..?", preferredStyle: .actionSheet)
        let logOutAction = UIAlertAction(title: "Logout", style: .destructive) { (ButtonTapped) in
            do{
                try Auth.auth().signOut()
                GIDSignIn.sharedInstance().signOut()
                print("logout")
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
                self.present(authVC!, animated: true, completion: nil)
            }catch {
                print(error)
            }
        }
        logOutPopUp.addAction(logOutAction)
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
        }
        
        if let uploadData = UIImageJPEGRepresentation(selectedImageFromPicker!, 0.8) {
            let imgUid = UUID().uuidString
            DataService.instance.REF_STORE_PROFILEIMG.child(imgUid).putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                
                if error != nil {
                    print("unable to upload image")
                }else {
                    print("successfully image upload")
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    if let url = downloadUrl {
                        DataService.instance.uploadProfileImage(userId: imgUid, profileImageUrl: url, forUID: (Auth.auth().currentUser?.uid)!, handler: { (success) in
                            if success {
                                self.profileImage.image = self.profileImage.image
                                print("profile image uploaded")
                            }else {
                                print("cant save image")
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



















