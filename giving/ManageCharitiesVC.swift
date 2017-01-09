//
//  ManageCharitiesVC.swift
//  giving
//
//  Created by Taylor King on 1/9/17.
//  Copyright © 2017 Taylor King. All rights reserved.
//

import UIKit

class ManageCharitiesVC: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

}
