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
                let json = JSON(response.result.value)
                
                
            }
        }
        
    }
    
    

}

extension RoundUpsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        
        return cell
    }
    
}

extension RoundUpsVC: UITableViewDelegate {
    
}
