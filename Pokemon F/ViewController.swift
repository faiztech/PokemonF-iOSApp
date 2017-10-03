//
//  ViewController.swift
//  Pokemon F
//
//  Created by Mohammed Faizuddin on 10/3/17.
//  Copyright © 2017 Faiz Tech. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate{
   
   @IBOutlet weak var mapView: MKMapView!
   
   var manager = CLLocationManager()
   var updateCount = 0
   var pokemons: [Pokemon] = []
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      //adding all Pokemons into CoreData
      pokemons = getAllPokemon()
      
      manager.delegate = self
      
      //trying to verify if already have given permission for the location
      if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
      {
         //showing location
         mapView.showsUserLocation = true
         //start updating location
         manager.startUpdatingLocation()
         
         Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            //spawning pokemon every time interval
            
            if let coord = self.manager.location?.coordinate
            {
               let annot = MKPointAnnotation()
               annot.coordinate = coord
               
               //creating random latitude and longitude numbers
               let randoLat = (Double(arc4random_uniform(100)) - 100.0) / 30000.0
               let randoLon = (Double(arc4random_uniform(100)) - 100.0) / 30000.0
               
         
               annot.coordinate.latitude += randoLat
               annot.coordinate.longitude += randoLon
               self.mapView.addAnnotation(annot)
               
            }
         })
         
      }
      else{
         //requesting again
         manager.requestWhenInUseAuthorization()
      }
      
   }
   
   
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
      if updateCount < 4
      {
         
         //setting a region
         let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 400 , 400)
         
         //setting the region
         mapView.setRegion(region, animated: false)
         
         updateCount += 1
      }
      else
      {
         manager.stopUpdatingLocation()
         
      }
   }
   
   @IBAction func centerTapped(_ sender: Any) {
      
      if let coord = manager.location?.coordinate
      {
         let region = MKCoordinateRegionMakeWithDistance(coord, 300 , 300)
         
         //setting the region
         mapView.setRegion(region, animated: true)
      }
   }
}


