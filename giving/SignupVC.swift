//
//  SignupVC.swift
//  giving
//
//  Created by Taylor King on 1/4/17.
//  Copyright © 2017 Taylor King. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import SwiftyJSON

class SignupVC: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signupBtnTapped(_ sender: Any) {
        
        guard let username = usernameField.text else {
            print("TAYLOR: No username")
            return
        }
        
        guard let password = passwordField.text else {
            print("TAYLOR: No password")
            return
        }
        
        
        let parameters: Parameters = ["username": username, "password": password]
        Alamofire.request("https://shielded-taiga-67588.herokuapp.com/auth/signup", method: .post, parameters: parameters).responseJSON { (response) in
            
            if response.result.isFailure == true {
                print("TAYLOR: FAILURE = \(response.result.isFailure)")
                return
            }
            
            if let result = response.result.value {
                print("TAYLOR: SUCCESS = \(response.result.isSuccess)")
                let JSON = result as! NSDictionary
                print("TAYLOR: \(JSON["token"]) & \(JSON["id"])")
                
                if let token = JSON["token"], let id = JSON["id"] {
                    KeychainWrapper.standard.set(token as! String, forKey: KEY_UID)
                    KeychainWrapper.standard.set(id as! Int, forKey: "id")
                    print("TAYLOR: SIGNING UP ID \(id)")
                    //self.presentingViewController!.presentingViewController!.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
    
}
