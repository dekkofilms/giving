//
//  Transactions.swift
//  giving
//
//  Created by Taylor King on 1/11/17.
//  Copyright © 2017 Taylor King. All rights reserved.
//

import Foundation

class Transaction {
    
    private var _roundUp: String!
    private var _chargeAmount: String!
    private var _chargeName: String!
    
    var roundup: String {
        return _roundUp
    }
    
    var chargeAmount: String {
        return _chargeAmount
    }
    
    var chargeName: String {
        return _chargeName
    }
    
    init(roundNum: String, chargeAmount: String, chargeName: String) {
        self._roundUp = roundNum
        self._chargeAmount = chargeAmount
        self._chargeName = chargeName
    }
    
    
}
