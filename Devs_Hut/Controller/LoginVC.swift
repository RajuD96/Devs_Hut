//
//  LoginVC.swift
//  Devs_Hut
//
//  Created by Raju Dhumne on 20/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var emailTxtFeild: InsetTxtField!
    @IBOutlet weak var passwordTxtFeild: InsetTxtField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtFeild.delegate = self
        passwordTxtFeild.delegate = self
        spinner.isHidden = true
    }
    
    //Sign-In with Email
    @IBAction func signUpBtnwasPressed(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        if emailTxtFeild.text != nil && passwordTxtFeild.text != nil {
            AuthService.instance.loginUser(withEmail: emailTxtFeild.text!, andPassWord: passwordTxtFeild.text!, loginUserComplete: { (success, loginError) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: USER_IMAGE_LOADED, object: nil)
                    
                }else {
                    print(String(describing: loginError?.localizedDescription))
                }
                AuthService.instance.registerUser(withEmail: self.emailTxtFeild.text!, andPassword: self.passwordTxtFeild.text!, registerUserComplete: { (success, registerError) in
                    if success {
                        AuthService.instance.loginUser(withEmail: self.emailTxtFeild.text!, andPassWord: self.passwordTxtFeild.text!, loginUserComplete: { (success, nil) in
                            
                            self.dismiss(animated: true, completion: nil)
                            self.spinner.isHidden = true
                            self.spinner.stopAnimating()
                            print("Successfully LoginUser")
                        })
                    }
                    else {
                        self.presentAlert(alert: (registerError?.localizedDescription)!)
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                    }
                })
            })
        }
    }
    
    func presentAlert(alert:String) {
        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
}
extension LoginVC:UITextFieldDelegate {}
