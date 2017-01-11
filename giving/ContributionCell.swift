//
//  ContributionCell.swift
//  giving
//
//  Created by Taylor King on 1/11/17.
//  Copyright © 2017 Taylor King. All rights reserved.
//

import UIKit

class ContributionCell: UITableViewCell {
    
    @IBOutlet weak var charityNameLabel: UILabel!
    @IBOutlet weak var charityTotalAmount: UILabel!
    
    var newContribution: Contribution!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(contribution: Contribution) {
        self.newContribution = contribution
        self.charityNameLabel.text = newContribution.charityName
        self.charityTotalAmount.text = newContribution.charityAmount
    }

}
