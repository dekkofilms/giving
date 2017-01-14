//
//  Contribution.swift
//  giving
//
//  Created by Taylor King on 1/11/17.
//  Copyright © 2017 Taylor King. All rights reserved.
//

import Foundation

class Contribution {
    
    private var _charityName: String!
    private var _charityAmount: Double!
    
    var charityName: String {
        return _charityName
    }
    
    var charityAmount: Double{
        return _charityAmount
    }
    
    init(name: String, amount: Double) {
        self._charityName = name
        self._charityAmount = amount
    }
    
}
