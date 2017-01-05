//
//  ViewController.swift
//  giving
//
//  Created by Taylor King on 1/4/17.
//  Copyright © 2017 Taylor King. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let user = KeychainWrapper.standard.string(forKey: KEY_UID)
        
        if user == nil {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let signinNavVC = sb.instantiateViewController(withIdentifier: "SigninNavVC")
            present(signinNavVC, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func signOutBtnTapped(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        KeychainWrapper.standard.removeObject(forKey: "id")
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let signinNavVC = sb.instantiateViewController(withIdentifier: "SigninNavVC")
        
        present(signinNavVC, animated: false, completion: nil)
    }
    


}

