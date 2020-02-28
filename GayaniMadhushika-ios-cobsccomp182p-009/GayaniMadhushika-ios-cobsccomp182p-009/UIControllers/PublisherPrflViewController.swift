//
//  PublisherPrflViewController.swift
//  GayaniMadhushika-ios-cobsccomp182p-009
//
//  Created by Imali Chathurika on 2/27/20.
//  Copyright © 2020 Gayani Madhushika. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FirebaseAuth
import Firebase

class PublisherPrflViewController: UIViewController {

    

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var contactNo: UITextField!
    @IBOutlet weak var fbConnection: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var publishImage: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
         setUpButtonStyles()
    }
    //Styling
    func setUpButtonStyles(){
        
        Utilities.styleTextField(firstName)
        Utilities.styleTextField(lastName)
        Utilities.styleTextField(contactNo)
        Utilities.styleHollowButton(fbConnection)
        Utilities.styleFilledButton(saveButton)
        
    }

    @IBAction func fbProfileUrlTapped(_ sender: Any) {
        let manager = LoginManager()
        manager.logIn(permissions: [.publicProfile, .email], viewController: self){(result) in
            switch result{
            case .cancelled:
                print("user cancelled login")
            break
            case .success(let granted, let declined, let token):
                print("Access token == \(AccessToken.self)")
            case .failed(let error):
                print("Login failed with error = \(error.localizedDescription)")
            }
            
        }
        
    }
    
    func getUserProfile(){
        
//        let connection = GraphRequestConnection()
//        connection.add(GraphRequest(graphPath: "/4", parameters: ["fields" : "id,name,about,birthday"], tokenString: AccessToken.current?.tokenString, version: Settings.defaultGraphAPIVersion, httpMethod: .get)) {
//            response, result{
//                switch result{
//                case  .success(let response):
//                    print("Profile user id == \(response.dictionaryValue!["id"])")
//                    print("Profile user name == \(response.dictionaryValue!["name"])")
//                    break
//                case .failed(let error):
//                    print("We have an error on fetching user profile == \(error.localizedDescription)")
//                }
//            }
//        }
        
        
    }
    
    func validateFields() -> String?{
        
        //Text fields can not be empty
        if firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" || lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || contactNo.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please fill in all fields"
        }
        
        return nil
        
        
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        let alert = AlertDialog();
        //Validate the field
        let error = validateFields()
        
        if error != nil
        {
            
            alert.showAlert(title: "Error", message: "Please fill all the fields", buttonText: "Ok")
            
        }
            
        else
        {

            let fName = firstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lName = lastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let contact  = contactNo.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
            
            
            //Create the  user
            Auth.auth().createUser(withEmail: firstName.text!, password: lastName.text!) { (result, err) in
                
                if err != nil
                {
                    
                    alert.showAlert(title: "Error", message: "Error creating the new Event contributer", buttonText: "Ok")
                    
                }
                    
                    //User created and store field values
                else
                {
                    let db = Firestore.firestore()
                    
                    db.collection("publisher").addDocument(data: ["fName":fName,"lName":lName,"contact": contact,"uid": result!.user.uid])
                    { (error) in
                        
                        if error != nil
                        {
                            alert.showAlert(title: "Error", message: "Error creating the new Event contributer", buttonText: "Ok")
                        }
                        
                    }
                    
                    
                    alert.showAlert(title: "Successful", message: "A new Event created", buttonText: "Ok")
                    
                    
                }
                
                let  detailVc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
                self.navigationController?.pushViewController(detailVc, animated: true)
                
            }
            
        }
    }
    
    @IBAction func btnTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func goBack(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "view") as! CreateEventViewController
        self.present(vc, animated: true, completion: nil)
    }
    
}


extension PublisherPrflViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            publishImage.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}

