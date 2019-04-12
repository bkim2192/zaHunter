//
//  ViewController.swift
//  zaHunter
//
//  Created by Brandon Kim on 4/3/19.
//  Copyright © 2019 Brandon Kim. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textField: UITextField!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var pizzaArray:[MKMapItem] = []
    var initialRegion: MKCoordinateRegion!
    var isInitialMapLoad = true
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        if isInitialMapLoad == true {
            initialRegion = MKCoordinateRegion(center: mapView.centerCoordinate, span: mapView.region.span)
            isInitialMapLoad = false
        }
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        textField.delegate = self
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
        var coord = currentLocation.coordinate
    }
    @IBAction func zoomPressed(_ sender: Any) {
        let center = currentLocation.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        pizzaArray.removeAll()
        var array = mapView.annotations
        mapView.removeAnnotations(array)
        mapView.reloadInputViews()
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        let request = MKLocalSearch.Request()
        if textField.text == "" {
            request.naturalLanguageQuery = "pizza"
            pizzaArray.removeAll()
            mapView.reloadInputViews()
        } else {
            request.naturalLanguageQuery = "\(textField.text!)"
            pizzaArray.removeAll()
            mapView.reloadInputViews()
        }
        
        
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        request.region = MKCoordinateRegion(center: currentLocation.coordinate, span: span)
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {return}
            for mapItem in response.mapItems {
                self.pizzaArray.append(mapItem)
                let annotation = MKPointAnnotation()
                annotation.title = mapItem.name
                annotation.coordinate = mapItem.placemark.coordinate
                self.mapView.addAnnotation(annotation)
    }
    }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isEqual(mapView.userLocation){
            return nil
        }
        
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.canShowCallout = true
        let pic = UIImage(named: "pizza")
        pin.image = pic
        let button = UIButton(type: .detailDisclosure)
        
        pin.rightCalloutAccessoryView = button
        let zoomButton = UIButton(type: .contactAdd)
        pin.leftCalloutAccessoryView = zoomButton
        return pin
        
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
         var currentMapItem = MKMapItem()
        let theButton = control as! UIButton
       
        
        
        
        if let title = view.annotation?.title, let parkName = title{
            for mapItem in pizzaArray {
                if mapItem.name == parkName {
                    currentMapItem = mapItem
                }
            }
        }
        
        if theButton.buttonType == .contactAdd {
            let defaults = UserDefaults.standard
            if let name = currentMapItem.name {
            
            defaults.set(name, forKey: "name")
            

            }
            if let number = currentMapItem.phoneNumber {
               
                defaults.set(number, forKey: "number")
            }
            if let url = currentMapItem.url {
              
                defaults.set(url, forKey: "url")
            }
            if let region = currentMapItem.placemark.region {
                
                defaults.set(region, forKey: "region")
            }
            if let timezone = currentMapItem.placemark.timeZone {
                
                defaults.set(timezone, forKey: "timezone")
            }
        }
        let placemark = currentMapItem.placemark
        
        if let street = currentMapItem.placemark.thoroughfare, let sub = currentMapItem.placemark.subThoroughfare{
            createAlert(street, placemark.name!, sub)
        }
        if let name = currentMapItem.name{
            createAlert(name, placemark.name!, name)
        }
    }
    func createAlert(_ street:String, _ name:String, _ sub:String){
        let alert = UIAlertController(title: name, message: "\(sub) \(street)", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
        
    }
}

