//
//  SaveLocationVC.swift
//  OnTheMap
//
//  Created by Alsuhaibani on 24/01/2019.
//  Copyright © 2019 Alsuhaibani. All rights reserved.
//

import UIKit
import MapKit

class SaveLocationVC: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var TheMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TheMap.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createAnnotation()
        tabBarController?.tabBar.isHidden = true
    }
    
    var appKey:      String?
    var addressText: String?
    var urlText:     String?
    var latitude:    Double?
    var longitude:   Double?

    @IBAction func SaveButton(_ sender: Any) {
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appKey = appDelegate.uniqueKey!
        
        guard let key = appKey, let address = addressText, let url = urlText, let lat = latitude, let lon = longitude else {
            return
        }
        
        API.saveLocation(key, address, url, lat, lon){ (states, error) in
            
            ActivityIndicator.AiStart(view: self.view)
            
            DispatchQueue.main.async {
                
                ActivityIndicator.AiStop()
                
                if states == false {
                    
                    let error = UIAlertController(title: "Error", message: "There is something wrong", preferredStyle: .alert )
                    error.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(error, animated: true, completion: nil)
                    return
                    
                } else {
                    ActivityIndicator.AiStop()
                    self.goBack()                
                }
            }
            
        }
    }
    
    func goBack() {
        DispatchQueue.main.async {
            self.tabBarController?.tabBar.isHidden = false
            if let navigationController = self.navigationController {
                navigationController.popToRootViewController(animated: true)
            }
        }
        
    }
    func createAnnotation(){
        let annotation = MKPointAnnotation()
        annotation.title = addressText!
        annotation.subtitle = urlText!
        annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
        self.TheMap.addAnnotation(annotation)
        
        let coredinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coredinate, span: span)
        self.TheMap.setRegion(region, animated: true)
    }
    
}

extension SaveLocationVC {
    
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
