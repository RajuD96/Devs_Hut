//
//  MeCell.swift
//  Devs_Hut
//
//  Created by Raju Dhumne on 12/03/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit

class MeCell: UITableViewCell {

    @IBOutlet weak var groupTitleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(groupTitle:String) {
        self.groupTitleLbl.text = groupTitle
        
    }
}
