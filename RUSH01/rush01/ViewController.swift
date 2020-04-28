//
//  ViewController.swift
//  rush01
//
//  Created by Maxime JOUBERT on 1/31/20.
//  Copyright © 2020 Maxime JOUBERT. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class ViewController: UIViewController {

    let locationManager = CLLocationManager()
    
    var resultSearchControllerSource: UISearchController?
    
    var selectedPin:MKPlacemark?
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var direction : Bool = false
    
    var sourceLocation : CLLocationCoordinate2D?
    var destinationLocation : CLLocationCoordinate2D?
    
    var sourceChange : Bool = false
    var selectedAnnotation : MKAnnotation?
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var resultSearchDestination: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchControllerSource = UISearchController(searchResultsController: locationSearchTable)
        resultSearchControllerSource?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchControllerSource!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Recherche lieu"
        navigationItem.titleView = resultSearchControllerSource?.searchBar

        resultSearchControllerSource?.hidesNavigationBarDuringPresentation = false
        resultSearchControllerSource?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    @IBAction func segmentAction(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        default:
            mapView.mapType = .hybrid
        }
    }
    
    @IBAction func buttonPosition(_ sender: Any) {
        let region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.mapView.setRegion(region, animated: true)
    }
    
    @objc func getDirections(){
        if (self.direction == true) {
            self.mapView.removeOverlays(self.mapView.overlays)
        }
        if (self.destinationLocation != nil && self.sourceLocation != nil) {
            let sourcePlaceMark = MKPlacemark(coordinate: self.sourceLocation!)
            let destinationPlaceMark = MKPlacemark(coordinate: self.destinationLocation!)
            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
            directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
            directionRequest.transportType = .automobile
            
            let directions = MKDirections(request: directionRequest)
            directions.calculate { (response, error) in
                guard let directionResponse = response else {
                    if let error = error {
                        print("error direction", error.localizedDescription)
                    }
                    return
                }
                let route = directionResponse.routes[0]
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                
                let rec = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegion(rec), animated: true)
            }
            if self.direction == false {
                self.direction = true
            }
        }
    }
    
    @objc func getChangeDirectionSource() {
        print("Source getchange")
        resultSearchControllerSource?.searchBar.text = ""
        resultSearchControllerSource?.searchBar.placeholder = "Change de Source"
        self.sourceChange = true
    }
    
    @objc func getChangeDirectionSourceGPS() {
        print("Source getchange")
        resultSearchControllerSource?.searchBar.text = ""
        self.sourceLocation = locationManager.location?.coordinate
        getDirections()
    }
    
    @objc func getChangeDirectionDestination() {
        print("Destination getchange")
        resultSearchControllerSource?.searchBar.text = ""
        resultSearchControllerSource?.searchBar.placeholder = "Change de Destination"
    }
}

extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.sourceLocation = manager.location?.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
}

extension ViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        if let view = self.selectedAnnotation {
            mapView.removeAnnotation(view)
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        if (self.sourceChange == true) {
            print("source")
            self.sourceChange = false
            self.sourceLocation = placemark.coordinate
        } else {
            print("destination")
            self.destinationLocation = placemark.coordinate
        }
        if (self.destinationLocation != nil && self.sourceLocation != nil && self.direction == true) {
            getDirections()
        }
        mapView.setRegion(region, animated: true)
    }
}

extension ViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if let ulav = mapView.view(for: mapView.userLocation) {
            if ((self.sourceLocation?.latitude != mapView.userLocation.coordinate.latitude) && (self.sourceLocation?.longitude != mapView.userLocation.coordinate.longitude)) {
                let smallSquare = CGSize(width: 30, height: 30)
                let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
                button.setBackgroundImage(UIImage(named: "gps"), for: [])
                button.addTarget(self, action: #selector(getChangeDirectionSourceGPS), for: .touchUpInside)
                ulav.leftCalloutAccessoryView = button
            } else {
                let smallSquare = CGSize(width: 30, height: 30)
                let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
                button.setBackgroundImage(UIImage(named: "change"), for: [])
                button.addTarget(self, action: #selector(getChangeDirectionSource), for: .touchUpInside)
                ulav.leftCalloutAccessoryView = button
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "Placemark"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: [])
        button.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        let buttonChange = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        buttonChange.setBackgroundImage(UIImage(named: "change"), for: [])
        buttonChange.addTarget(self, action: #selector(getChangeDirectionDestination), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        pinView?.rightCalloutAccessoryView = buttonChange
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAnnotation = view.annotation
    }
}
