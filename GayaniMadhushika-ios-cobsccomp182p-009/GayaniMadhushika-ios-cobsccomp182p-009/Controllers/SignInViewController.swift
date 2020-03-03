//
//  SignInViewController.swift
//  GayaniMadhushika-ios-cobsccomp182p-009
//
//  Created by Imali Chathurika on 2/9/20.
//  Copyright © 2020 Gayani Madhushika. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


struct UserLoginModel {
    let userNameTextField: String
    let passwordTextField: String

}

class SignInViewController: UIViewController {
    

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpButtonStyles()

    }
    
    
    func setUpButtonStyles(){
        
        Utilities.styleTextField(userNameTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        Utilities.styleHollowButton(registerButton)
        
    }
    
    @IBAction func SignInButtonTapped(_ sender: Any) {
       
        //Username and password authentication
        let alert = AlertDialog();
        
        Auth.auth().signIn(withEmail: userNameTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                
                alert.showAlert(title: "Error", message: "Your email and password is invalid", buttonText: "OK")
            }
            else if user != nil {
                    //store the email address
                    UserDefaults.standard.set(self.userNameTextField.text, forKey: "email")
                
                    let alert = AlertDialog();
                
                    alert.showAlert(title: "Successful", message: "You have successfully Logged In", buttonText: "OK")
                    
                    //Enabling the Major viewing page
                    let bottomTabBar = self.storyboard?.instantiateViewController(withIdentifier: "bottomTabBar") as! UITabBarController
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    appDelegate.window?.rootViewController = bottomTabBar
              
            }
            
        }

  }
    
    func resetPassword(email: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void){
       
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil{
                onSuccess()
            }
            else{
                onError(error!.localizedDescription)
            }
        }
        
    }
    
}
