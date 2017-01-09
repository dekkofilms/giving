//
//  ViewController.swift
//  giving
//
//  Created by Taylor King on 1/4/17.
//  Copyright © 2017 Taylor King. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire

class HomeVC: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let user = KeychainWrapper.standard.string(forKey: KEY_UID)
        
        if user == nil {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let signinNavVC = sb.instantiateViewController(withIdentifier: "SigninNavVC")
            present(signinNavVC, animated: true, completion: nil)
        }
        
        let token = KeychainWrapper.standard.string(forKey: "access_token")
        
        if token != nil {
            getUserTransactions()
        }
        
    }

    @IBAction func signOutButtonTapped(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        KeychainWrapper.standard.removeObject(forKey: "id")
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let signinNavVC = sb.instantiateViewController(withIdentifier: "SigninNavVC")
        
        present(signinNavVC, animated: false, completion: nil)
    }
    
    func getUserTransactions() {
        if let token = KeychainWrapper.standard.string(forKey: "access_token") {
            let parameters: Parameters = ["token" : token]
            print("TAYLOR --- PARAMS: \(parameters)")
            
            Alamofire.request("http://localhost:3000/plaid/transactions", method: .post, parameters: parameters).responseJSON { (response) in
                print("TAYLOR---Account INFO: \(response.result.value)")
            }
        }
        
    }


}

