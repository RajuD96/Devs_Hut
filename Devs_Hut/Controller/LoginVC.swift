//
//  LoginVC.swift
//  Devs_Hut
//
//  Created by Raju Dhumne on 20/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTxtFeild: InsetTxtField!
    @IBOutlet weak var passwordTxtFeild: InsetTxtField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtFeild.delegate = self
        passwordTxtFeild.delegate = self
        
    }
    @IBAction func signUpBtnwasPressed(_ sender: Any) {
        if emailTxtFeild.text != "" && passwordTxtFeild.text != "" {
            AuthService.instance.loginUser(withEmail: emailTxtFeild.text!, andPassWord: passwordTxtFeild.text!, loginUserComplete: { (success, loginError) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                }else {
                    print(String(describing: loginError?.localizedDescription))
                }
                AuthService.instance.registerUser(withEmail: self.emailTxtFeild.text!, andPassword: self.passwordTxtFeild.text!, registerUserComplete: { (success, registerError) in
                    if success {
                        AuthService.instance.loginUser(withEmail: self.emailTxtFeild.text!, andPassWord: self.passwordTxtFeild.text!, loginUserComplete: { (success, nil) in
                            self.dismiss(animated: true, completion: nil)
                            print("Successfully LoginUser")
                        })
                    }
                    else {
                        print(String(describing: registerError?.localizedDescription))
                    }
                })
            })
        }
        
        
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        
    }
    
}
extension LoginVC:UITextFieldDelegate {}
