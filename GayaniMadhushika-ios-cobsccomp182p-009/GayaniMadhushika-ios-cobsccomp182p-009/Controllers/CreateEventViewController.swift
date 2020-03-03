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
import AVFoundation
import FirebaseStorage
import FirebaseDatabase

class CreateEventViewController: UIViewController{

    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var details: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var contributerName: UITextField!
    @IBOutlet weak var contributerEmail: UITextField!
    @IBOutlet weak var cost: UITextField!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var updateVenue: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var sampleStartDateTextField: UITextField!
    @IBOutlet weak var sampleEndDateTextField: UITextField!

    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
  
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        setUpButtonStyles()

    }
    
    //Style up the elements
    func setUpButtonStyles(){
        
        //style up button and textboxes
        Utilities.styleTextField(eventName)
        Utilities.styleTextField(details)
        Utilities.styleTextField(sampleStartDateTextField)
        Utilities.styleTextField(sampleEndDateTextField)
        Utilities.styleTextField(contributerName)
        Utilities.styleTextField(contributerEmail)
        Utilities.styleTextField(cost)
        Utilities.styleTextField(location)
        Utilities.styleHollowButton(updateVenue)
        Utilities.styleHollowButton(reviewButton)
        Utilities.styleHollowButton(uploadButton)
        Utilities.styleFilledButton(saveButton)
        
    }
    
    func loadRecordingUI() {
        recordButton.isEnabled = false
        playButton.isEnabled = false
        recordButton.setTitle("Tap to Record", for: .normal)
        recordButton.addTarget(self, action: #selector(recordAudioButtonTapped), for: .touchUpInside)
        view.addSubview(recordButton)
    }
    
    
    @objc func recordAudioButtonTapped(_ sender: UIButton) {
        
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func startRecording() {
        let audioFilename = getFileURL()
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self as? AVAudioRecorderDelegate
            audioRecorder.record()
            
            recordButton.setTitle("Tap to Stop", for: .normal)
            playButton.isEnabled = false
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("Tap to Re-record", for: .normal)
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
        
        playButton.isEnabled = true
        recordButton.isEnabled = true
    }
    

    @IBAction func playAudioButtonTapped(_ sender: UIButton) {
        if (sender.titleLabel?.text == "Play"){
            recordButton.isEnabled = false
            sender.setTitle("Stop", for: .normal)
            preparePlayer()
            audioPlayer.play()
        } else {
           // audioPlayer.stop()
           // sender.setTitle("Play", for: .normal)
        }
    }
    
    func preparePlayer() {
        var error: NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileURL() as URL)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        
        if let err = error {
            print("AVAudioPlayer error: \(err.localizedDescription)")
        } else {
            audioPlayer.delegate = self as? AVAudioPlayerDelegate
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 10.0
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL() -> URL {
        let path = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        return path as URL
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
        playButton.setTitle("Play", for: .normal)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }
    
    //Validate whether the inputs are correct display message whether there is an error
    func validateFields() -> String?{
        
        //Text fields can not be empty
        if eventName.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" || details.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || contributerName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || contributerEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please fill in all fields"
        }
        
        return nil

        
        
    }


    @IBAction func uploadButtonTapped(_ sender: Any) {
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
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
            let venue  = location.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let startDate = sampleStartDateTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let endDate = sampleEndDateTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let costs = cost.text!.trimmingCharacters(in: .whitespacesAndNewlines)
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

                    db.collection("events").addDocument(data: ["eventNames":eventNames,"description":description,"venue": venue,"startDate":startDate,"endDate":endDate,"costs":costs,"name":name,"emailAddress":emailAddress,"uid": result!.user.uid])
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
    
    @IBAction func goBack(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.present(vc, animated: true, completion: nil)
    }
    
}


extension CreateEventViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            eventImage.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}
