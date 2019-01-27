//
//  TableVC.swift
//  OnTheMap
//
//  Created by Alsuhaibani on 13/01/2019.
//  Copyright © 2019 Alsuhaibani. All rights reserved.
//

import UIKit

class TableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    @IBOutlet weak var tableView: UITableView!
    
    func reload() {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    func getData() {
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
                
                guard let locationsArray = studentsLocations else {
                    ActivityIndicator.AiStop()
                    let locationsErrorAlert = UIAlertController(title: "Erorr loading locations", message: "There was an error loading locations", preferredStyle: .alert )
                    
                    locationsErrorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(locationsErrorAlert, animated: true, completion: nil)
                    return
                }
                
                for locationStruct in locationsArray {
                    
                    let mediaURL = locationStruct.mediaURL ?? " "
                    let first = locationStruct.firstName ?? " "
                    let last = locationStruct.lastName ?? " "
                    let lat = locationStruct.latitude ?? 0
                    let lon = locationStruct.longitude ?? 0
                    let created = locationStruct.createdAt ?? " "
                    let location = locationStruct.mapString ?? " "
                    
                    let studentInfo = StudentInformation.StudentInfo.init(createdAt: created, uniqueKey: "", firstName: first, lastName: last, address: location, url: mediaURL, latitude: lat, longitude: lon)
                    
                    StudentInformation.studentInformation.append(studentInfo)
                    
                }
                
                self.reload()
                ActivityIndicator.AiStop()
                print("table reloaded")
                
            }
            
        }
    }
    @IBAction func addPin(_ sender: Any) {
        
    }
    
    @IBAction func refrash(_ sender: Any) {
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


extension TableVC {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformation.studentInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! TableViewCell
        StudentInformation.studentInformation.sort() {$0.createdAt! > $1.createdAt!}
        let cellContent = StudentInformation.studentInformation[(indexPath as NSIndexPath).row]
        cell.StudentName.text = "\(cellContent.firstName ?? " ") \(cellContent.lastName ?? " ")"
        cell.studentUrl.text = cellContent.url
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellContent = StudentInformation.studentInformation[(indexPath as NSIndexPath).row]
        guard let url = URL(string: cellContent.url!) else {return}
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
}

