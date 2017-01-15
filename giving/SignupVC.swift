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
    
    var isKeyboardPresent: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SigninVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SigninVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if isKeyboardPresent == false {
                self.view.frame.origin.y -= keyboardSize.height - 85
                isKeyboardPresent = true
            }
            
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if isKeyboardPresent == true {
                self.view.frame.origin.y += keyboardSize.height - 85
                isKeyboardPresent = false
            }
            
        }
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
