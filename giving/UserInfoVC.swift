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
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        
        if let firstName = firstNameField.text, let lastName = lastNameField.text, let id = KeychainWrapper.standard.integer(forKey: "id") {
            
            let parameters: Parameters = ["firstName" : firstName, "lastName" : lastName, "id" : id]
            
            Alamofire.request("https://shielded-taiga-67588.herokuapp.com/user/profile", method: .post, parameters: parameters).responseJSON(completionHandler: { (response) in
                print("TAYLOR: \(response.result.value)")
            })
            
        }
        
    }

}
