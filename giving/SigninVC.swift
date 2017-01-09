//
//  SigninVC.swift
//  giving
//
//  Created by Taylor King on 1/4/17.
//  Copyright © 2017 Taylor King. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper

class SigninVC: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signinBtnTapped(_ sender: Any) {
        
        guard let username = usernameField.text else {
            print("TAYLOR: No username")
            return
        }
        
        guard let password = passwordField.text else {
            print("TAYLOR: No password")
            return
        }
        
        let parameters: Parameters = ["username": username, "password": password]
        
        
        Alamofire.request("https://shielded-taiga-67588.herokuapp.com/auth/login", method: .post, parameters: parameters).responseJSON { (response) in
            if response.result.isFailure == true {
                print("TAYLOR: Wrong info given")
                return
            }
            
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                
                KeychainWrapper.standard.set(JSON["token"] as! String, forKey: KEY_UID)
                KeychainWrapper.standard.set(JSON["id"] as! Int, forKey: "id")
                self.dismiss(animated: true, completion: nil)
            }
            
            
        }
        
    }
    
    @IBAction func createAnAccountTapped(_ sender: Any) {
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let SignupVC = sb.instantiateViewController(withIdentifier: "SignupVC")
//        present(SignupVC, animated: true, completion: nil)
        
    }
    
    
}
