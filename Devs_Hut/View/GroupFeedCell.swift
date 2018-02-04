//
//  GroupFeedCell.swift
//  Devs_Hut
//
//  Created by Raju Dhumne on 04/02/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit

class GroupFeedCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var contentLbl: UILabel!
    
    func configureCell(profileImage:UIImage,email:String,content:String){
        
        self.profileImage.image = profileImage
        self.emailLbl.text = email
        self.contentLbl.text = content
        
    }
    
}
