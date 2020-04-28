//
//  FirstViewController.swift
//  D05
//
//  Created by Maxime JOUBERT on 1/24/20.
//  Copyright © 2020 Maxime JOUBERT. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FirstViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var controle: UISegmentedControl!
    
    var currentLatitude = Data.lieu[2].1
    var currentLongitude = Data.lieu[2].2
    var location = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for items in Data.lieu {
            print(items.0)
            let annotation = MKPointAnnotation()
            annotation.title = items.0
            annotation.subtitle = items.4
            annotation.coordinate = CLLocationCoordinate2D(latitude: items.1, longitude: items.2)
            mapView.addAnnotation(annotation)
        }
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        self.mapView.setRegion(region, animated: true)
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        self.mapView.showsUserLocation = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Placemark"
        
        if(annotation is MKUserLocation) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        if(annotation.title! == "Marseille") {
            pin.pinTintColor = MKPinAnnotationView.greenPinColor()
        } else if(annotation.title! == "Lyon") {
            pin.tintColor = MKPinAnnotationView.purplePinColor()
        }
        
        pin.canShowCallout = true
        
        annotationView = pin
        
        return annotationView
    }
    
    @IBAction func controlerAction(_ sender: Any) {
        switch controle.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        default:
            mapView.mapType = .hybrid
        }
    }
    
    
    @IBAction func geolocalisationAction(_ sender: Any) {
        let region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        self.mapView.setRegion(region, animated: true)
    }
    
    @IBAction func unWindSegue(segue: UIStoryboardSegue) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        self.mapView.setRegion(region, animated: true)
    }
}
