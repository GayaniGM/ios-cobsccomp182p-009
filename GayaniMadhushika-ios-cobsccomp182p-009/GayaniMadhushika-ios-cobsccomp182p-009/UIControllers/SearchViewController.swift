//
//  SearchViewController.swift
//  GayaniMadhushika-ios-cobsccomp182p-009
//
//  Created by Imali Chathurika on 2/18/20.
//  Copyright © 2020 Gayani Madhushika. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLogOut(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "email")
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "Main")
        let navVc = UINavigationController(rootViewController: vc!)
        let share = UIApplication.shared.delegate as! AppDelegate
        
        share.window?.rootViewController = navVc
        share.window?.makeKeyAndVisible()
    }
    
    
}
