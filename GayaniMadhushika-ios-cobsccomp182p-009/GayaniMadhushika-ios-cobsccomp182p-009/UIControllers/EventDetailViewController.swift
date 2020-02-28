//
//  EventDetailViewController.swift
//  GayaniMadhushika-ios-cobsccomp182p-009
//
//  Created by Imali Chathurika on 2/28/20.
//  Copyright © 2020 Gayani Madhushika. All rights reserved.
//

import UIKit
import Firebase

class EventDetailViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDateAndTime: UILabel!
    @IBOutlet weak var venue: UILabel!
    @IBOutlet weak var btnGoing: UIButton!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpButtonStyles()
        // Do any additional setup after loading the view.
    }
    
    //Styling
    func setUpButtonStyles(){
        
        Utilities.styleFilledButton(btnGoing)
        Utilities.styleHollowButton(shareButton)
        
    }
    
    @IBAction func goingButtonTapped(_ sender: Any) {
        
        let alert = AlertDialog();
        
        
        let db = Firestore.firestore()
        
        
        db.collection("events").getDocuments(){(QuerySnapshot, err) in
            if let err = err {
                print("Error getting data: \(err)")
            }else
            {
                for document in QuerySnapshot!.documents{
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
 
           
        alert.showAlert(title: "Error", message: "Please fill all the fields", buttonText: "Ok")
        
    }
        
}
