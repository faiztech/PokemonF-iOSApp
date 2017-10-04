//
//  ViewController.swift
//  Pokemon F
//
//  Created by Mohammed Faizuddin on 10/3/17.
//  Copyright © 2017 Faiz Tech. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
   
   @IBOutlet weak var mapView: MKMapView!
   
   var manager = CLLocationManager()
   var updateCount = 0
   var pokemons: [Pokemon] = []
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      manager.delegate = self

      
      //adding all Pokemons into CoreData
      pokemons = getAllPokemon()
      
      
      //trying to verify if already have given permission for the location
      if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
      {
         setup()
         
      }
      else{
         //requesting again
         manager.requestWhenInUseAuthorization()
      }
      
   }
   
   
   
   
   func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      if status == .authorizedWhenInUse
  
      {
         setup()
         
      }
      
   }
   
   
   
   
   func setup()  {
      
      mapView.delegate = self

      //showing location
      mapView.showsUserLocation = true
      //start updating location
      manager.startUpdatingLocation()
      
      Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
         //spawning pokemon every time interval
         
         if let coord = self.manager.location?.coordinate
         {
            let index = Int(arc4random_uniform((UInt32(self.pokemons.count))))
            
            let pokemon = self.pokemons[index]
            
            let annot = PokeAnnotation(coord: coord, pokemon: pokemon)
            
            //creating random latitude and longitude numbers
            let randoLat = (Double(arc4random_uniform(100)) - 100.0) / 30000.0
            let randoLon = (Double(arc4random_uniform(100)) - 100.0) / 30000.0
            
            
            annot.coordinate.latitude += randoLat
            annot.coordinate.longitude += randoLon
            self.mapView.addAnnotation(annot)
            
         }
      })
   }
   
   
   
   
   func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      
      if annotation is MKUserLocation{
         
         let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
         
         annoView.image  = UIImage(named: "player")
         
         var frame = annoView.frame
         
         frame.size.height = 40
         frame.size.width = 40
         
         annoView.frame = frame
         
         
         return annoView
         
         
         
      }
      
      
      let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
      
      let pokemon = (annotation as! PokeAnnotation).pokemon
      
      annoView.image  = UIImage(named: pokemon.imageName!)
      
      var frame = annoView.frame
      
      frame.size.height = 40
      frame.size.width = 40

      annoView.frame = frame
      
      
      return annoView
      
      
      
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
   
   //selecting pokemons
   func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
      
      if view.annotation! is MKUserLocation{
         
         return
         
      }
      
      //setting a region
      let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200 , 200)
      
      //setting the region
      mapView.setRegion(region, animated: true)
      
      Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
      
      
      
      if let coord = self.manager.location?.coordinate{
         if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)){
            
            let pokemon = (view.annotation as! PokeAnnotation).pokemon
            pokemon.caught = true
            ((UIApplication.shared.delegate) as! AppDelegate).saveContext()
            
            mapView.removeAnnotation(view.annotation!)
            
            let alertVC = UIAlertController(title: "Woah!!", message: "You just caught \(pokemon.name!). Gotta catch em all!", preferredStyle: .alert)
            let pokeDexAction = UIAlertAction(title: "Pokedex", style: .default, handler: { (action) in
               
              self.performSegue(withIdentifier: "PokeDexSegue", sender: nil)
            })
            alertVC.addAction(pokeDexAction)

            
           let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(okAction)
            
            self.present(alertVC, animated: true, completion: nil)
            
            
            
            
            
         }
      
         else
         {
            let pokemon = (view.annotation as! PokeAnnotation).pokemon

            let alertVC = UIAlertController(title: "Uh-Oh", message: "You are too far away to catch \(pokemon.name!). Please go closer and try again.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
         
         }
         }
      
      }
      
      
      
      
      mapView.deselectAnnotation(view.annotation!, animated: true)
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


