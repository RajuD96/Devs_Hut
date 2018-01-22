//
//  CreatePostVC.swift
//  Devs_Hut
//
//  Created by Raju Dhumne on 22/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit
import Firebase

class CreatePostVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var sendBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func sendBtnWasPressed(_ sender: Any) {
        
        if textView.text != nil && textView.text != "Say Something..." {
            sendBtn.isHidden = false
            DataService.instance.postUserMessage(withMessage: textView.text, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: nil, completion: { (success) in
                if success {
                    self.sendBtn.isHidden = true
                    self.dismiss(animated: true, completion: nil)
                }else {
                    print("There was an error.")
                }
            })
            
            
        }
        
    }
    

   
    
}
extension CreatePostVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
}

