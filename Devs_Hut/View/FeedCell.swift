//
//  FeedCell.swift
//  Devs_Hut
//
//  Created by Raju Dhumne on 23/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit
import Kingfisher

class FeedCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    
    
    func configureCell(image: URL?,email: String,message: String){
        
        if image != nil {
            self.userImage.kf.setImage(with: image)
        }
        else {
            self.userImage.image = UIImage(named: "defaultProfileImage")
        }
        
        self.emailLbl.text = email
        self.messageLbl.text = message
        
    }
}
