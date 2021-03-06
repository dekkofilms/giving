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
    @IBOutlet weak var currentRoundUp: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var roundupNeeded: UILabel!
    
    var donations = [Contribution]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = KeychainWrapper.standard.string(forKey: KEY_UID)
        
        if user == nil {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let signinNavVC = sb.instantiateViewController(withIdentifier: "SigninNavVC")
            present(signinNavVC, animated: false, completion: nil)
        }
        
        let token = KeychainWrapper.standard.string(forKey: "access_token")
        
        if token != nil {
            getUserTransactions()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        self.tableView.backgroundColor = UIColor.init(red: 253/255, green: 254/255, blue: 254/255, alpha: 1.0)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.revealViewController().rearViewRevealWidth = 200
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let id = KeychainWrapper.standard.integer(forKey: "id") {
            
            let parameters: Parameters = ["id" : id]
            
            print("TAYLOR - lololololol: \(parameters)")
            
            Alamofire.request("https://shielded-taiga-67588.herokuapp.com/user/dashboard", method: .post, parameters: parameters).responseJSON(completionHandler: { (response) in
                
                if response.result.isFailure {
                    return
                }
                
                print("TAYLOR: readedeaw: \(response.result.value)")
                
                self.donations.removeAll()
                
                let json = JSON(response.result.value!)
                
                print("TAYLOR: PLEEEASSEEEEEEE: \(json)")
                
                //Let me figure out a way to pass the currentRoundUp and amountGiven to the other views that need it from here!!!
                self.amountGivenNumber.text = "$\(json["given"])"
                self.currentRoundUp.text = "$\(json["currentRoundUp"])"
                self.roundupNeeded.text = "$\(json["roundToGo"])"
                
                let defaults = UserDefaults.standard
                defaults.setValue("$\(json["currentRoundUp"])", forKey: "currentRoundUp")
                defaults.setValue("$\(json["roundToGo"])", forKey: "roundToGo")
                
                for (key, value) in json["specificCharityTotal"] {
                    print("TAYLOR ___---: \(key) && \(value)")
                    self.donations.append(Contribution(name: key, amount: Double(round(value.doubleValue*100)/100)))
                }
                
                self.tableView.reloadData()
                
                
            })
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        

    }

    @IBAction func signOutButtonTapped(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        KeychainWrapper.standard.removeObject(forKey: "id")
        KeychainWrapper.standard.removeObject(forKey: "access_token")
        
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "currentRoundUp")
        prefs.removeObject(forKey: "roundToGo")
        prefs.synchronize()
        
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
}

