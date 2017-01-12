//
//  RoundUpsVC.swift
//  giving
//
//  Created by Taylor King on 1/9/17.
//  Copyright © 2017 Taylor King. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class RoundUpsVC: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var transactions = [Transaction]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        self.tableView.backgroundColor = UIColor.init(red: 253/255, green: 254/255, blue: 254/255, alpha: 1.0)

        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let id = KeychainWrapper.standard.integer(forKey: "id") {
            let parameters: Parameters = ["id" : id]
            
            Alamofire.request("https://shielded-taiga-67588.herokuapp.com/user/roundups", method: .post, parameters: parameters).responseJSON { (response) in
                let json = JSON(response.result.value!)
                
                for (_, value) in json["transactions"] {
                    print("TAYLOR - transactions: \(value["rounded_amount"]) \(value["amount"]) \(value["name"])")
                    self.transactions.append(Transaction(roundNum: value["rounded_amount"].stringValue, chargeAmount: value["amount"].stringValue, chargeName: value["name"].stringValue))
                }
                
                self.tableView.reloadData()
            }
        }
        
    }
    
    

}

extension RoundUpsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let transaction = transactions[indexPath.row] as Transaction
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        cell.configureCell(transaction: transaction)
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
        
    }
    
}

extension RoundUpsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
}
