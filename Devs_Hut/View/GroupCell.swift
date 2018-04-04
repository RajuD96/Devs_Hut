//
//  GroupCell.swift
//  Devs_Hut
//
//  Created by Raju Dhumne on 25/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

  
    @IBOutlet weak var groupTitle: UILabel!
    @IBOutlet weak var groupDesc: UILabel!
    @IBOutlet weak var memberCount: UILabel!
    
    func configureCell(title:String,description:String,memberCount:Int){
        self.groupTitle.text = title
        self.groupDesc.text = description
        self.memberCount.text = "\(memberCount) member"
    }
    
    
    
    
}
