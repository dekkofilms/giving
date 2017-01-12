//
//  CharityCell.swift
//  giving
//
//  Created by Taylor King on 1/12/17.
//  Copyright © 2017 Taylor King. All rights reserved.
//

import UIKit

class CharityCell: UITableViewCell {

    @IBOutlet weak var charityNameLabel: UILabel!
    @IBOutlet weak var charityDescriptionLabel: UILabel!
    
    var newCharity: Charity!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configureCell(charity: Charity) {
        self.newCharity = charity
        self.charityNameLabel.text = newCharity.charityName
        self.charityDescriptionLabel.text = newCharity.charityDescription
    }

}
