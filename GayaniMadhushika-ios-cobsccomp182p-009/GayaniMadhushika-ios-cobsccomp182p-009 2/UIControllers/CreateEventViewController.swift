//
//  CreateEventViewController.swift
//  GayaniMadhushika-ios-cobsccomp182p-009
//
//  Created by Imali Chathurika on 2/18/20.
//  Copyright © 2020 Gayani Madhushika. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import MapKit

class CreateEventViewController: UIViewController {

    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var details: UITextField!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var startDateAndTime: UITextField!
    @IBOutlet weak var endDateAndTme: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var contributerName: UITextField!
    @IBOutlet weak var contributerEmail: UITextField!
    @IBOutlet weak var cost: UITextField!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var updateVenue: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpButtonStyles()

    }
    //Style up the elements
    func setUpButtonStyles(){
        
        //style up button and textboxes
        Utilities.styleTextField(eventName)
        Utilities.styleTextField(details)
        Utilities.styleTextField(startDateAndTime)
        Utilities.styleTextField(endDateAndTme)
        Utilities.styleTextField(contributerName)
        Utilities.styleTextField(contributerEmail)
        Utilities.styleTextField(cost)
        Utilities.styleHollowButton(updateVenue)
        Utilities.styleHollowButton(reviewButton)
        Utilities.styleFilledButton(saveButton)
        
    }
    
    //Validate whether the inputs are correct display message whether there is an error
    func validateFields() -> String?{
        
        //Text fields can not be empty
        if eventName.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" || details.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || contributerName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || contributerEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please fill in all fields"
        }
        
        return nil

    }
    
    
    @IBAction func onClickSubmitToReview(_ sender: Any) {
    }
    
    
    @IBAction func onClickSave(_ sender: Any) {
        
         let alert = AlertDialog();
        //Validate the field
        let error = validateFields()
       
        if error != nil
        {
            
        alert.showAlert(title: "Error", message: "Please fill all the fields", buttonText: "Ok")
            
        }
            
        else
        {
            
            let eventNames = eventName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let description = details.text!.trimmingCharacters(in: .whitespacesAndNewlines)
           // let venue  = location.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let name = contributerName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let emailAddress = contributerEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            //Create the  user
            Auth.auth().createUser(withEmail: contributerEmail.text!, password: contributerName.text!) { (result, err) in
                
                if err != nil
                {
                    
                   alert.showAlert(title: "Error", message: "Error creating the new Event contributer", buttonText: "Ok")
                    
                }
                    
                    //User created and store field values
                else
                {
                    let db = Firestore.firestore()

                    db.collection("events").addDocument(data: ["eventNames":eventNames,"description":description,"name":name,"emailAddress":emailAddress,"uid": result!.user.uid])
                    { (error) in

                        if error != nil
                        {
                            alert.showAlert(title: "Error", message: "Error creating the new Event contributer", buttonText: "Ok")
                        }

                    }
                    
                    
                    //Navigate to login page
                  alert.showAlert(title: "Successful", message: "A new Event created", buttonText: "Ok")
                    
                }
                
            }
            
        }
    }
    
    
}
