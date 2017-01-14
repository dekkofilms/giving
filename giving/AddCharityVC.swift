//
//  AddCharityVC.swift
//  giving
//
//  Created by Taylor King on 1/12/17.
//  Copyright © 2017 Taylor King. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import Whisper

class AddCharityVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var charities = [Charity]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        self.tableView.backgroundColor = UIColor.init(red: 253/255, green: 254/255, blue: 254/255, alpha: 1.0)
        
        //self adjusted row height
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Alamofire.request("https://shielded-taiga-67588.herokuapp.com/user/charities", method: .get).responseJSON { (response) in
            let json = JSON(response.result.value!)
            
            for (_, value) in json["charities"] {
                print("TAYLOR: \(value)")
                self.charities.append(Charity(name: value["name"].stringValue, description: value["description"].stringValue, charityID: value["id"].int!))
            }
            
            self.tableView.reloadData()
        }
    }
    
}

extension AddCharityVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let charity = charities[indexPath.row] as Charity! else { return }
        
        let alertController: UIAlertController = UIAlertController(title: "Add this Charity?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let subview = alertController.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        
        alertContentView.backgroundColor = UIColor.white
        alertContentView.layer.cornerRadius = 15
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result) in
        }
        
        let okAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) { (result) in
            print("TAYLOR: \(charity.charityID)")
            
            if let user_id = KeychainWrapper.standard.integer(forKey: "id") {
                
                let parameters: Parameters = ["charity_id" : charity.charityID, "user_id" : user_id]
                
                Alamofire.request("https://shielded-taiga-67588.herokuapp.com/user/add/charity", method: .post, parameters: parameters).responseJSON(completionHandler: { (response) in
                    
                    let json = JSON(response.result.value!)
                    
                    print("TAYLOR RESPONSE: \(json["response"])")
                    
                    if json["response"] == "exists" {
                        
                        //rgb(95,120,109) -- darker green
                        let message = Message(title: "You've already added this!", textColor: UIColor.white, backgroundColor: UIColor.init(red: 95/255, green: 120/255, blue: 109/255, alpha: 1.0))
                        
                        Whisper.show(whisper: message, to: self.navigationController!)
                        
                    }
                    
                    if json["response"] == "added" {
                        
                        //rgb(21,195,152) -- green
                        let message = Message(title: "Good Choice!", textColor: UIColor.white, backgroundColor: UIColor.init(red: 21/255, green: 195/255, blue: 152/255, alpha: 1.0))
                        
                        Whisper.show(whisper: message, to: self.navigationController!)
                    }
                    
                })
                
            }
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true) {
        }
        
    }
    
}

extension AddCharityVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let charity = charities[indexPath.row] as Charity
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharityCell", for: indexPath) as! CharityCell
        
        let bgColorView = UIView()
        //rgb(216,240,228) --- light green
        bgColorView.backgroundColor = UIColor.init(red: 216/255, green: 240/255, blue: 228/255, alpha: 1.0)
        cell.selectedBackgroundView = bgColorView
        
        cell.configureCell(charity: charity)
        
        return cell
    }
    
}
