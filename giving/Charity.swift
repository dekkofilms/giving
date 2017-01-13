//
//  Charity.swift
//  giving
//
//  Created by Taylor King on 1/12/17.
//  Copyright © 2017 Taylor King. All rights reserved.
//

import Foundation

class Charity {
    
    private var _charityName: String!
    private var _charityDescription: String!
    private var _optionID: Int!
    private var _charityID: Int!
    
    var charityName: String {
        return _charityName
    }
    
    var charityDescription: String {
        return _charityDescription
    }
    
    var optionID: Int {
        return _optionID
    }
    
    var charityID: Int {
        return _charityID
    }
    
    init(name: String, description: String, optionID: Int) {
        self._charityName = name
        self._charityDescription = description
        self._optionID = optionID
    }
    
    init(name: String, description: String, charityID: Int) {
        self._charityName = name
        self._charityDescription = description
        self._charityID = charityID
    }
    
}
