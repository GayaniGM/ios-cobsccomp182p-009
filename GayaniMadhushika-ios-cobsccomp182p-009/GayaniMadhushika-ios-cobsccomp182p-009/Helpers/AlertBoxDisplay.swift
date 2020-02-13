//
//  AlertBoxDisplay.swift
//  GayaniMadhushika-ios-cobsccomp182p-009
//
//  Created by Imali Chathurika on 2/13/20.
//  Copyright © 2020 Gayani Madhushika. All rights reserved.
//


import Foundation
import UIKit


class AlertDialog {
    
    func showAlert(title: String,message: String,buttonText: String)  {
        
        let alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButton(withTitle: buttonText)
        alert.show()
        
    }
}
