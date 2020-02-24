//
//  MapViewController.swift
//  GayaniMadhushika-ios-cobsccomp182p-009
//
//  Created by Imali Chathurika on 2/25/20.
//  Copyright © 2020 Gayani Madhushika. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, UISearchBarDelegate, LocateOnTheMap {

    
    @IBOutlet weak var googleMapsContainer: UIView!
    var googleMapView: GMSMapView!
    var searchResultController: SearchResultsController!
    var resultArray = [String]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.googleMapView = GMSMapView(frame: self.googleMapsContainer.frame)
        self.view.addSubview(self.googleMapView)
        
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
    }
    
     //search location by address
    @IBAction func searchWithAddress(_ sender: Any) {
        
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.present(searchController, animated: true, completion: nil)
        
    }
    

    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
    
        DispatchQueue.main.async {
            
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
            self.googleMapView.camera = camera
            
            marker.title = "Address : \(title)"
            marker.map = self.googleMapView
            
        }
        
    }
    
}
