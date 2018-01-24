//
//  UserCell.swift
//  Devs_Hut
//
//  Created by Raju Dhumne on 24/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var checkMark: UIImageView!
    var showing = false
    func congfigureCell(profileImage image:UIImage,email:String,isSelected:Bool) {
        self.profileImage.image = image
        self.userEmail.text = email
        if isSelected {
            self.checkMark.isHidden = false
        }else {
            self.checkMark.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected{
            if showing == false{
                checkMark.isHidden = false
                showing = true
                
            }else {
                checkMark.isHidden = true
                showing = false
            }
        }
    }
}
