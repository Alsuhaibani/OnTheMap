//
//  AddLocationVC.swift
//  OnTheMap
//
//  Created by Alsuhaibani on 20/01/2019.
//  Copyright © 2019 Alsuhaibani. All rights reserved.
//

import UIKit
import MapKit

class AddLocationVC: UIViewController {

    @IBOutlet weak var FindLocation: UIButton!
    @IBOutlet weak var AddLocation: UITextField!
    @IBOutlet weak var AddURL: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         tabBarController?.tabBar.isHidden = false
    }
    var latitude : Double?
    var longitude : Double?
    

    @IBAction func FindLocation(_ sender: Any) {
       
        if AddLocation.text != "" && AddURL.text != "" {
            
           ActivityIndicator.AiStart(view: self.view)
            
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = AddLocation.text
            let activeSearch = MKLocalSearch(request: searchRequest)
            
            activeSearch.start { (response, error) in
                if error != nil {
                    let error = UIAlertController(title: "Error", message: "There is something wrong", preferredStyle: .alert )
                    error.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                        
                    }))
                    self.present(error, animated: true, completion: nil)
                    return
                } else {
                    self.latitude = response?.boundingRegion.center.latitude
                    self.longitude = response?.boundingRegion.center.longitude
                    self.performSegue(withIdentifier: "SaveLocation", sender: nil)
                    
                }
            }
        } else {
            
            DispatchQueue.main.async {
                
                let error = UIAlertController(title: "Error", message: "Add your Address And WebSite", preferredStyle: .alert )
                error.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                    return
                }))
                self.present(error, animated: true, completion: nil)
                
            }
            
        }
            
        }
        
    }

extension AddLocationVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SaveLocation"{
            let vc = segue.destination as! SaveLocationVC
            
            vc.addressText = AddLocation.text
            vc.urlText = AddURL.text
            vc.latitude = self.latitude
            vc.longitude = self.longitude
            
        }
        
    }
    
}


