//
//  CircleImage.swift
//  Devs_Hut
//
//  Created by Raju Dhumne on 10/02/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit

@IBDesignable
class CircleImage: UIImageView {
    override func awakeFromNib() {
        setupView()
    }
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
   

}
