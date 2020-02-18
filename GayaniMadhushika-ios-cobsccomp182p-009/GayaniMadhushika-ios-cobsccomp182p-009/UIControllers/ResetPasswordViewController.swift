//
//  ResetPasswordViewController.swift
//  GayaniMadhushika-ios-cobsccomp182p-009
//
//  Created by Imali Chathurika on 2/18/20.
//  Copyright © 2020 Gayani Madhushika. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController {

    
    @IBOutlet weak var resetPasswordTextField: UITextField!
    
    @IBOutlet weak var btnResetPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpButtonStyles()
        
    }
    
    //Styling
    func setUpButtonStyles(){
        
        Utilities.styleTextField(resetPasswordTextField)
        Utilities.styleFilledButton(btnResetPassword)
        
    }

    
    @IBAction func btnResetPassword(_ sender: Any) {
        
        let alert = AlertDialog();
        
        
        guard let email = resetPasswordTextField.text, email != "" else{
        alert.showAlert(title: "Failed", message: "Please enter a registered Email Address", buttonText: "OK")
        return
        
        }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil{
              alert.showAlert(title: "Successful", message: "We have just send you a password reset email. Please check your inbox and follow the instructions to reset your password!", buttonText: "OK")
                
                let loginPage : SignInViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as! SignInViewController
                
                self.navigationController?.pushViewController(loginPage, animated: true)
                
            }
            else{
                alert.showAlert(title: "Error", message: "Please enter a correct email address to reset password", buttonText: "OK")
            }
        }
        
    }
}
