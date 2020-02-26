//
//  SearchViewController.swift
//  GayaniMadhushika-ios-cobsccomp182p-009
//
//  Created by Imali Chathurika on 2/18/20.
//  Copyright © 2020 Gayani Madhushika. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        // Do any additional setup after loading the view.
        if UserDefaults.standard.bool(forKey: "email") == true{
            let  homeVc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
            self.navigationController?.pushViewController(homeVc, animated: true)
            
        }
        
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
