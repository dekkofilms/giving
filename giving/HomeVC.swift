//
//  ViewController.swift
//  giving
//
//  Created by Taylor King on 1/4/17.
//  Copyright © 2017 Taylor King. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftKeychainWrapper
import Alamofire

class HomeVC: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var amountGivenNumber: UILabel!
    @IBOutlet weak var userFirstName: UILabel!
    @IBOutlet weak var currentRoundUp: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var donations = [Contribution]()
    
    override func viewWillAppear(_ animated: Bool) {
        if let id = KeychainWrapper.standard.integer(forKey: "id") {
            let parameters: Parameters = ["id" : id]
            
            Alamofire.request("https://shielded-taiga-67588.herokuapp.com/user/given", method: .post, parameters: parameters).responseJSON(completionHandler: { (response) in
                let json = JSON(response.result.value!)
                print("TAYLOR: PLEEEASSEEEEEEE: \(json)")
                
                self.amountGivenNumber.text = "$\(json["given"])"
                self.userFirstName.text = "\(json["username"])"
                self.currentRoundUp.text = "$\(json["currentRoundUp"])"
                
                for (key, value) in json["specificCharityTotal"] {
                    print("TAYLOR ___---: \(key) && \(value)")
                    self.donations.append(Contribution(name: key, amount: value.stringValue))
                }
                
                self.tableView.reloadData()
                
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        self.tableView.backgroundColor = UIColor.clear
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
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
        if let token = KeychainWrapper.standard.string(forKey: "access_token"), let user_id = KeychainWrapper.standard.integer(forKey: "id") {
            let parameters: Parameters = ["token" : token, "user_id" : user_id]
            print("TAYLOR --- PARAMS: \(parameters)")
            
            Alamofire.request("https://shielded-taiga-67588.herokuapp.com/plaid/transactions", method: .post, parameters: parameters).responseJSON { (response) in
                print("TAYLOR---Account INFO: \(response.result.value)")
            }
        }
        
    }


}

extension HomeVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let donation = donations[indexPath.row] as Contribution
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContributionCell", for: indexPath) as! ContributionCell
        cell.configureCell(contribution: donation)
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
}

extension HomeVC: UITableViewDelegate {
    
}

