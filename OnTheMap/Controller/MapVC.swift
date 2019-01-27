//
//  MapVC.swift
//  OnTheMap
//
//  Created by Alsuhaibani on 10/01/2019.
//  Copyright © 2019 Alsuhaibani. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
         mapView.delegate = self
    }
    
//        func reload() {
//        let annot = self.mapView.annotations
//        self.mapView.removeAnnotations(annot)
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    func getData(){
        
        let annot = self.mapView.annotations
        self.mapView.removeAnnotations(annot)
        
        ActivityIndicator.AiStart(view: self.view)
        API.getAllLocations() {(studentsLocations, error) in
            
            DispatchQueue.main.async {
                
                if error != nil {
                    ActivityIndicator.AiStop()
                    let errorAlert = UIAlertController(title: "Error performing request", message: "There was an error performing your request", preferredStyle: .alert )
                    
                    errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                    return
                }
                
                var annotations = [MKPointAnnotation] ()
                
                guard let locationsArray = studentsLocations else {
                    ActivityIndicator.AiStop()
                    let locationsErrorAlert = UIAlertController(title: "Error loading locations", message: "There is a problem loading", preferredStyle: .alert )
                    
                    locationsErrorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(locationsErrorAlert, animated: true, completion: nil)
                    return
                    
                }
                
                for locationStruct in locationsArray {
                    
                    let long = CLLocationDegrees(locationStruct.longitude ?? 0)
                    let lat = CLLocationDegrees(locationStruct.latitude ?? 0)
                    
                    let coords = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let mediaURL = locationStruct.mediaURL ?? " "
                    let first = locationStruct.firstName ?? " "
                    let last = locationStruct.lastName ?? " "
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coords
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    annotations.append(annotation)
                    
                }
                
                ActivityIndicator.AiStop()
                
                self.mapView.addAnnotations(annotations)
                
            }
            
        }
    }
    @IBAction func addPin(_ sender: Any) {
        
    }
    @IBAction func refresh(_ sender: Any) {
       getData()
    }
    @IBAction func logOut(_ sender: Any) {
        
        API.logout { (states, error) in
            
            print("signed out success")
            if error != nil {
                let error = UIAlertController(title: "Erorr", message: "There was an error", preferredStyle: .alert )
                
                error.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                    return
                }))
                self.present(error, animated: true, completion: nil)
                return
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
            
        }
    }
    
}



extension MapVC {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .green
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
        
    }
    
}



