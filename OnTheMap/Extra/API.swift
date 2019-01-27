//
//  API.swift
//  OnTheMap
//
//  Created by Alsuhaibani on 10/01/2019.
//  Copyright © 2019 Alsuhaibani. All rights reserved.
//

import Foundation

class API {
    static func login(_ username: String!,_ password:String!,completion: @escaping (Bool, String, Error?)->Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username!)\", \"password\": \"\(password!)\"}}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil {
                completion (false, "", error)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                completion (false, "", statusCodeError)
                return
            }
            
            if statusCode >= 200  && statusCode < 300 {
                
                let range = 5..<data!.count
                let newData = data?.subdata(in: range)
                
                print (String(data: newData!, encoding: .utf8)!)
                
                let loginJsonObject = try! JSONSerialization.jsonObject(with: newData!, options: [])
                
                let loginDictionary = loginJsonObject as? [String : Any]
                let accountDictionary = loginDictionary?["account"] as? [String : Any]
                let uniqueKey = accountDictionary?["key"] as? String ?? " "
                
                completion (true, uniqueKey, nil)
                
            } else {
                
                completion (false, "", nil)
                
            }
        }
        task.resume()
    }
    
    static func logout(complation: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                complation(false, error)
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            complation(true, nil)
        }
        task.resume()
        
    }
    
    static func getAllLocations(completion: @escaping ([StudentLocation]?, Error?) -> ()) {
        
        var request = URLRequest (url: URL (string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) {data, response, error in
            if error != nil {
                completion(nil, error)
                return
            }
            
            print (String(data: data!, encoding: .utf8)!)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                
                completion(nil, statusCodeError)
                return
            }
            
            if statusCode >= 200 && statusCode < 300 {
                
                let jsonObject = try! JSONSerialization.jsonObject(with: data!, options: [])
                
                guard let jsonDictionary = jsonObject as? [String : Any] else {return}
                
                let resultsArray = jsonDictionary["results"] as? [[String:Any]]
                
                guard let array = resultsArray else {return}
                
                let dataObject = try! JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
                
                let studentsLocations = try! JSONDecoder().decode([StudentLocation].self, from: dataObject)
                
                completion(studentsLocations, nil)
            }
        }
        
        task.resume()
    }
    
    static func saveLocation(_ key: String!, _ address: String!, _ url: String!, _ lat: Double!, _ lon: Double!, completion: @escaping (Bool, Error?) -> ()) {
        
        var request = URLRequest (url: URL (string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue(API.Constants.applicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(API.Constants.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(key!)\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"\(address!)\", \"mediaURL\": \"\(url!)\",\"latitude\": \(lat!), \"longitude\": \(lon!)}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion (false, error)
                return
            }
            
            print(String(data: data!, encoding: .utf8)!)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                
                completion(false, statusCodeError)
                return
            }
            
            if statusCode >= 200 && statusCode < 300 {
                
                completion(true, nil)
                
            }
            
            completion(true, nil)
            
        }
        
        task.resume()
        
    }
    
}

extension API {
    
    struct Constants {
        
        static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let applicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
    }
    
}

    


