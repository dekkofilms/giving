//
//  ManageCharitiesVC.swift
//  giving
//
//  Created by Taylor King on 1/9/17.
//  Copyright © 2017 Taylor King. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class ManageCharitiesVC: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
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
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getCharities()
        
    }
    
    func getCharities() {
        
        if let id = KeychainWrapper.standard.integer(forKey: "id") {
            
            let parameters: Parameters = ["id" : id]
            
            Alamofire.request("https://shielded-taiga-67588.herokuapp.com/user/charities", method: .post, parameters: parameters).responseJSON(completionHandler: { (response) in
                let json = JSON(response.result.value!)
                
                for (_, value) in json["options"] {
                    print("TAYLOR -- CHARITIES: \(value["name"])")
                    self.charities.append(Charity(name: value["name"].stringValue, description: value["description"].stringValue))
                }
                
                self.tableView.reloadData()
                
            })
            
        }
        
    }
    
    

}

extension ManageCharitiesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
}

extension ManageCharitiesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return charities.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let charity = charities[indexPath.row] as Charity
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharityCell", for: indexPath) as! CharityCell
        
        cell.configureCell(charity: charity)
        
        return cell
        
    }
    
}
