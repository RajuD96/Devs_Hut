//
//  GroupFeedCell.swift
//  Devs_Hut
//
//  Created by Raju Dhumne on 04/02/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit
import Kingfisher

class GroupFeedCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var contentLbl: UILabel!
    
    func configureCell(image:URL?,email:String,content:String){
        
        if image != nil {
            self.profileImage.kf.setImage(with: image)
        }else {
            self.profileImage.image = UIImage(named: "defaultProfileImage")
        }
        self.emailLbl.text = email
        self.contentLbl.text = content
    }
}
