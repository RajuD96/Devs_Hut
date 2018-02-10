//
//  UIViewExt.swift
//  Devs_Hut
//
//  Created by Raju Dhumne on 22/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit

extension UIView {
    
    func bindToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func keyboardWillChange(_ notif:NSNotification) {
        
        let duration = notif.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notif.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let beginningFrame = (notif.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (notif.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let delta = endFrame.origin.y - beginningFrame.origin.y
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue:curve), animations: {
            self.frame.origin.y += delta
        }, completion: nil)
    
        
        
    }
    
}
