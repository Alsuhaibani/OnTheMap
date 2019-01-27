//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Alsuhaibani on 10/01/2019.
//  Copyright © 2019 Alsuhaibani. All rights reserved.
//

import UIKit
import SafariServices

class LoginVC: UIViewController {


    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func loginButton(_ sender: Any) {
        
        let email = Email.text!
        let Password = password.text!
        
        ActivityIndicator.AiStart(view: self.view)
        
        API.login(email, Password){(loginSuccess, key, error) in
            
            DispatchQueue.main.async {
                
                if error != nil {
                    ActivityIndicator.AiStop()
                    let error = UIAlertController(title: "Erorr", message: "There was an error", preferredStyle: .alert )
                    
                    error.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(error, animated: true, completion: nil)
                    return
                }
                
                if !loginSuccess {
                    ActivityIndicator.AiStop()
                    let loginAlert = UIAlertController(title: "✋", message: "please check username or password", preferredStyle: .alert )
                    
                    loginAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(loginAlert, animated: true, completion: nil)
                } else {
                    ActivityIndicator.AiStop()
                    let object = UIApplication.shared.delegate
                    let appDelegate = object as! AppDelegate
                    appDelegate.uniqueKey = key
                    self.completeLogin()
                }
            }
        }
    }
    private func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ManagerTabBarController") as! UITabBarController
        present(controller, animated: true, completion: nil)
    }
    @IBAction func signupButton(_ sender: Any) {
        let url = URL(string: "https://www.udacity.com/account/auth#!/signup")
        guard let newUrl = url else {return}
        let safari = SFSafariViewController(url: newUrl)
        present(safari, animated: true, completion: nil)
    }
}

