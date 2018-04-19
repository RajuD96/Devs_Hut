//
//  RoundedButton.swift
//  Devs_Hut
//
//  Created by Raju Dhumne on 14/03/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func awakeFromNib() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.75
        self.layer.cornerRadius = self.frame.height / 2
    }
}
