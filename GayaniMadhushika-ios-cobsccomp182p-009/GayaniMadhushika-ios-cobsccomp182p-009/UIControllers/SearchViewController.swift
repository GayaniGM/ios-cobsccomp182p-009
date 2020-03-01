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

protocol DocumentSerializeable {
    init?(dictionary:[String:Any])
}

struct Event {
    var eventNames: String
    var description: String
    var venue: String
    
    var dictionary: [String: Any] {
        return [
            "eventNames": eventNames,
            "description": description,
            "venue": venue
        ]
    }
}


extension Event : DocumentSerializeable {
    init?(dictionary: [String : Any]) {
        guard let eventNames = dictionary["eventNames"] as? String,
            let description = dictionary["description"] as? String,
            let venue = dictionary["venue"] as? String else {return nil}
        
        self.init(eventNames: eventNames, description: description, venue: venue)
        
    }
}
class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var table: UITableView!
    
    var db: Firestore!
    var eventsArray = [Event]()
    private var document: [DocumentSnapshot] = []
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cellNew", for: indexPath) as! DisplayTableViewCell
        let events = eventsArray[indexPath.row]
    print(events)

    cell.name?.text = events.eventNames
    cell.details?.text = events.description
    cell.venue?.text = events.venue
        return cell

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        db = Firestore.firestore()
        loadData()
        
        
        // Do any additional setup after loading the view.
        if UserDefaults.standard.bool(forKey: "email") == true{
            let  homeVc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
            self.navigationController?.pushViewController(homeVc, animated: true)
        
        }
        
    }

        
        func loadData() {
            db.collection("events").getDocuments() {
                (snapshot, error) in
                
                if let error = error {
                    
                    
                    
                } else {
                    if let snapshot = snapshot{
                    
                    for document in snapshot.documents {
                        
                        
                        
                        let data = document.data()
                        let eventNames = data["eventNames"] as? String ?? ""
                        let description = data["description"] as? String ?? ""
                        let venue = data["venue"] as? String ?? ""
                        
                        let newEvent = Event(eventNames: eventNames, description: description, venue: venue)
                       self.eventsArray.append(newEvent)
                    }
                    
                    self.table.reloadData()
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
