//
//  SignUpViewController.swift
//  GayaniMadhushika-ios-cobsccomp182p-009
//
//  Created by Imali Chathurika on 2/11/20.
//  Copyright © 2020 Gayani Madhushika. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
  
    
    @IBOutlet weak var batchNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        setUpButtonStyles()
    
    }
    
    //Style up the elements
    func setUpButtonStyles(){
      
        //Hide error texts
        passwordErrorLabel.alpha = 0
        
        //style up button and textboxes
        Utilities.styleTextField(userNameTextField)
        Utilities.styleTextField(batchNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(registerButton)
    
    }
    
    //Validate whether the inputs are correct display message whether there is an error
    func validateFields() -> String?{
        
        //Text fields can not be empty
        if userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" || batchNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please fill in all fields"
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
           if Utilities.isPasswordValid(cleanedPassword) == false{
            
            return "Your password must be at least have 8 Charaters."
        }
        return nil
    }
    
    
  
    @IBAction func RegisterUserTapped(_ sender: Any) {
        
        //Validate the field
        let error = validateFields()
        
        if error != nil
        {
            
           showerror(error!)
            
        }
        
        else
        {
            
            let username = userNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let batchName = batchNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email  = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create the  user
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, err) in
                
            if err != nil
                {
                    
                     self.showerror("Error creating the user...")
                    
                }
                
                //User created and store username and batchname
                else
                {
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["batchName":batchName,"username":username,"email":email,"password":password,"uid": result!.user.uid])
                    { (error) in
                        
                        if error != nil
                        {
                          self.showerror("Error saving user data")
                        }
                        
                    }
                    
                    
                 //Navigate to login page
                    self.navigationToLoginScreen()
                }
            
            }
            
        }
    }
    
    
    func showerror(_ message:String){
        
        passwordErrorLabel.text = message
        passwordErrorLabel.alpha = 1
        
    }
    
    
    //Navigating to login after successful registration
    func navigationToLoginScreen() {
        let signInViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.signInViewController) as? SignInViewController
        
        view.window?.rootViewController = signInViewController
        view.window?.makeKeyAndVisible()
        
    }
    
   
}
