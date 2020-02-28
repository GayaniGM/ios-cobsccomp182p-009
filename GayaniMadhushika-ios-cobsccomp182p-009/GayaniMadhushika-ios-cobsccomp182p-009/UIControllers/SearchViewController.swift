//
//  SearchViewController.swift
//  GayaniMadhushika-ios-cobsccomp182p-009
//
//  Created by Imali Chathurika on 2/18/20.
//  Copyright © 2020 Gayani Madhushika. All rights reserved.
//

import UIKit
import Firebase
import LocalAuthentication

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var table: UITableView!
    
    var eventsArray = [String]()
    private var document: [DocumentSnapshot] = []
    
    struct Event {
        let eventName, description, emailAddress: String
    }
    
    var event = [Event]()
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellNew = tableView.dequeueReusableCell(withIdentifier: "cellNew", for: indexPath) as! MainTableViewCell
        let events = eventsArray[indexPath.row]
        cellNew.eventName?.text = events
        cellNew.details?.text = events
        cellNew.emailAddress?.text = events
        return cellNew
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        table.tableFooterView = UIView(frame: CGRect.zero)
        self.table.delegate = self
        self.table.dataSource = self
        
        
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
                    
//                    let data = document.data()
//                    let eventName = data["eventName"] as? String ?? ""
//                    let description = data["description"] as? String ?? ""
//                    let emailAddress = data["emailAddress"] as? String ?? ""
//                    let newEvent = Event(eventName: eventName, description: description, emailAddress: emailAddress)
//                    self.event.append(newEvent)
//
//                    let newIndexPath = IndexPath(row: self.event.count, section: 0)
//                    self.table.insertRows(at: [newIndexPath], with: .automatic)
//                    self.table.endUpdates()
//                }
//                DispatchQueue.main.async {
//                    self.table.reloadData()
              }
        }
        
        
        }
            
    }
    
    @IBAction func userProfile(_ sender: Any) {
        let context = LAContext()
        var error : NSError?
        
        //if touch id is available in the device
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            
            let reason = "Authenticate with touch ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply:  { (success, error) in
                //Show alert whether touch id is authenticated or not
                if success{
                    
                    let alert = AlertDialog();
                    alert.showAlert(title: "Successful", message: "You have successfully Authenticated with Touch ID", buttonText: "OK")
                    //Navigate to events detail page
                    let bottomTabBar = self.storyboard?.instantiateViewController(withIdentifier: "bottomTabBar") as! UITabBarController
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    appDelegate.window?.rootViewController = bottomTabBar
                    
                    self.showAlertController("Touch ID Authentication is successful!")
                    
                }
                else{
                    self.showAlertController("Touch ID Authentication Failed! Please log in.")
                }
            })
            
        }
            
        else{
            
            self.showAlertController("Touch ID is not avaialable!")
        }
        
        let popUpVc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "UserPrflViewController") as! UserPrflViewController
        self.addChild(popUpVc)
        popUpVc.view.frame = self.view.frame
        self.view.addSubview(popUpVc.view)
        popUpVc.didMove(toParent: self)
        
        
        
    }
    
    func showAlertController(_ message: String){
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        
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
