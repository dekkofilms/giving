//
//  SigninVC.swift
//  giving
//
//  Created by Taylor King on 1/4/17.
//  Copyright © 2017 Taylor King. All rights reserved.
//

import UIKit

class SigninVC: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signinBtnTapped(_ sender: Any) {
    }
    
    @IBAction func createAnAccountTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let SignupVC = sb.instantiateViewController(withIdentifier: "SignupVC")
        present(SignupVC, animated: true, completion: nil)
    }
    
    
}
