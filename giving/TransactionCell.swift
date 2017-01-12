//
//  TransactionCell.swift
//  giving
//
//  Created by Taylor King on 1/11/17.
//  Copyright © 2017 Taylor King. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    @IBOutlet weak var roundedLabel: UILabel!
    @IBOutlet weak var amountNameLabel: UILabel!
    
    var newTransaction: Transaction!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(transaction: Transaction) {
        self.newTransaction = transaction
        
        self.roundedLabel.text = "+$\(newTransaction.roundup)"
        self.amountNameLabel.text = "$\(newTransaction.chargeAmount) \(newTransaction.chargeName)"
    }

}
