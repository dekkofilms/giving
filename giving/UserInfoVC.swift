//
//  UserInfoVC.swift
//  giving
//
//  Created by Taylor King on 1/5/17.
//  Copyright © 2017 Taylor King. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper

class UserInfoVC: UIViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        
        if let firstName = firstNameField.text, let lastName = lastNameField.text, let id = KeychainWrapper.standard.integer(forKey: "id") {
            
            let parameters: Parameters = ["firstName" : firstName, "lastName" : lastName, "id" : id]
            
            Alamofire.request("http://localhost:3000/user/profile", method: .post, parameters: parameters).responseJSON(completionHandler: { (response) in
                print("TAYLOR: \(response.result.value)")
            })
            
        }
        
    }

}
