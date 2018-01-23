//
//  FeedCell.swift
//  Devs_Hut
//
//  Created by Raju Dhumne on 23/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    
    
    func configureCell(userImage:UIImage,email:String,message:String){
        self.userImage.image = userImage
        self.emailLbl.text = email
        self.messageLbl.text = message
        
    }
}
