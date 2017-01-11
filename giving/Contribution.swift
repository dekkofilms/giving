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
    private var _charityAmount: String!
    
    var charityName: String {
        return _charityName
    }
    
    var charityAmount: String {
        return _charityAmount
    }
    
    init(name: String, amount: String) {
        self._charityName = name
        self._charityAmount = amount
    }
    
}
