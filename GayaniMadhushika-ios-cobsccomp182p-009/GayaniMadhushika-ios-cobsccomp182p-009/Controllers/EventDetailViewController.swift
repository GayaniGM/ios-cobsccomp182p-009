//
//  EventDetailViewController.swift
//  GayaniMadhushika-ios-cobsccomp182p-009
//
//  Created by Imali Chathurika on 2/28/20.
//  Copyright © 2020 Gayani Madhushika. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class EventDetailViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDateAndTime: UILabel!
    @IBOutlet weak var venue: UILabel!
    @IBOutlet weak var btnGoing: UIButton!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    let alert = UIAlertController(title: "Title", message: "Description", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpButtonStyles()
        
    }
    
    //Styling
    func setUpButtonStyles(){
        
        Utilities.styleFilledButton(btnGoing)
        Utilities.styleHollowButton(shareButton)
        
    }
    
    
    @IBAction func goingButtonTapped(_ sender: Any) {
        
        alert.addTextField { (textField) in
            textField.placeholder = "Email address"
        }
        
        alert.addTextField { (textFieldPass) in
            textFieldPass.placeholder = "Feedback"
            textFieldPass.isSecureTextEntry = true
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            print("cancel")
        }))
        
        alert.addAction(UIAlertAction(title: "Send Feedback now", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            _ = alert?.textFields![1]
            print("Text field: \(textField!.text)")
          
        }))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
        
}
