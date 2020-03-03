//
//  ViewController.swift
//  NIBM Events
//
//  Created by Imali Chathurika on 2/6/20.
//  Copyright © 2020 Gayani Madhushika. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    let eventName = ["Hola' 2020", "Teentainment with NIBM", "NIC Design Fest", "IOT Hackathon 2020", "Youth Rave with B n S", "CyberFest 2k19", "Frozen Fest 2016", "Blood Donation Compaign 2019", "NIBM Halloween 2k19", "NIBM Sports Day 2019", "NIBM Awurudu 2015"]
    
    let eventImage = [UIImage(named: "image3"), UIImage(named: "image1"), UIImage(named: "image2"), UIImage(named: "image4"), UIImage(named: "image5"), UIImage(named: "image6"), UIImage(named: "image7"), UIImage(named: "image8"), UIImage(named: "image9"), UIImage(named: "image10"), UIImage(named: "image11")]
    
    let eventVenue = ["Venue: At NIBM Premises Colombo", "Venue: At ViharaMahaDevi Park", "Venue: At NIBM Premises Colombo", "Venue: At University of Colombo", "Venue: At NIBM premises Colombo", "Venue: At NIBM premises Colombo", "Venue: At NIBM premises Colombo", "Venue: At NIBM premises Colombo", "Venue: At NIBM premises Colombo", "Venue: At Sugathadasa Stadium Grounds", "Venue: At Maligawaththa grounds"]
    
    let eventDateTime = ["OCT 04 @9.30 AM - OCT 04 @4.30 PM", "JAN 04 @9.30 AM - JAN 05 @6.30 PM", "DEC 31 @9.30 AM - DEC 31 @4.30 PM", "MAR 04 @9.30 AM - MAR 06 @5.30 PM", "JAN 04 @9.30 AM - JAN 06 @4.30 PM", "MAY 04 @9.30 AM - MAY 08 @4.30 PM", "DEC 24 @9.30 AM - DEC 26 @4.30 PM", "JUL 04 @9.30 AM - JUL 06 @4.30 PM", "NOV 04 @9.30 AM - NOV 04 @4.30 PM", "SEP 04 @9.30 AM - SEP 04 @4.30 PM", "APR 24 @9.30 AM - APR 24 @4.30 PM"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
       
        cell.eventName.text = eventName[indexPath.row]
        cell.eventImage.image = eventImage[indexPath.row]
        cell.eventVenue.text = eventVenue[indexPath.row]
        cell.eventDateTime.text = eventDateTime[indexPath.row]
        
        //This creates shadows and modifies the appearance of cards a little bit
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
        

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
        
    }


    func showAlertController(_ message: String){
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        
    }


}
