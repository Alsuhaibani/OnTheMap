//
//  studentDetails.swift
//  OnTheMap
//
//  Created by Alsuhaibani on 13/01/2019.
//  Copyright © 2019 Alsuhaibani. All rights reserved.
//

import Foundation

class StudentInformation {
    
    
    static var studentInformation  = [StudentInfo]()
    
    struct StudentInfo : Codable {
        
        let createdAt:  String?
        let uniqueKey:  String?
        let firstName:  String?
        let lastName:   String?
        let address :   String?
        let url :       String?
        let latitude :  Double?
        let longitude : Double?
        
    }
}
