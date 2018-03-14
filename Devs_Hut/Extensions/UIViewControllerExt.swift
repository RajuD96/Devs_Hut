//
//  UIViewControllerExt.swift
//  Devs_Hut
//
//  Created by Raju Dhumne on 10/02/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func  presentDetails(_ viewControllerToPresent : UIViewController){
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func DismissDetails() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    
}
