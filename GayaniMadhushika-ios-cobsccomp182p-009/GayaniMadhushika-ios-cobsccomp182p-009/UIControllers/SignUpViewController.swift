//
//  SignUpViewController.swift
//  GayaniMadhushika-ios-cobsccomp182p-009
//
//  Created by Imali Chathurika on 2/11/20.
//  Copyright © 2020 Gayani Madhushika. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var userExistErrorLabel: UILabel!
    @IBOutlet weak var batchNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var passwordInvalidErrorLabel: UILabel!
    
   // @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        setUpButtonStyles()
    
    }
    
    
    func setUpButtonStyles(){
      
       userExistErrorLabel.alpha = 0
        passwordErrorLabel.alpha = 0
        passwordInvalidErrorLabel.alpha = 0
        
    
    }
    
    
    @IBAction func RegisterUserTapped(_ sender: Any) {
        
        
    }
    
   
}
