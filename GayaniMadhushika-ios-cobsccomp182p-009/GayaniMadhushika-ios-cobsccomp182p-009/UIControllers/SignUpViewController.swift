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
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    
    var imagePicker : UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
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
    
    @IBAction func pickImage(_ sender: Any) {
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func RegisterUserTapped(_ sender: Any) {
        
        //Validate the field
        let error = validateFields()
        guard let image = profileImage.image else { return  }
        
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
                
                //User created and store username, batchname, email and password
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
                    
                    
                    self.uploadProfileImage(image) { url in
                        
                        if url != nil{
                            
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.displayName = username
                            changeRequest?.photoURL = url
                            
                            changeRequest?.commitChanges { error in
                                if error == nil {
                                    print ("User display name changed!")
                                    
                                    self.saveProfile(username: username, profileImageURL: url!){ success in
                                        if success {
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                    }
                                    // self.dismiss(animated: false, completion: nil)
                                }else{
                                    print("Error: \(error!.localizedDescription)")
                                }
                                
                            }
                            
                        }else{
                            //error unable to save profile
                        }
                        
                    }
                    
                 //Navigate to login page
                    self.navigationToLoginScreen()
                }
            
            }
            
            
        }
        

    }
    
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                
                storageRef.downloadURL { url, error in
                    completion(url)
                    // success!
                }
            } else {
                // failed
                completion(nil)
            }
        }
    }
    
    func saveProfile(username:String, profileImageURL:URL, completion: @escaping ((_ success:Bool)->())){
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        
        let userObject = [
            "username" : username,
            "photoURL": profileImageURL
        ] as NSDictionary
//        databaseRef.setValue(userObject){ error, ref in
//            completion(error == nil)
//        }
        
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

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
    
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.profileImage.image = pickedImage
        }
    }
    
    
}
