//
//  Methods.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/7/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import Foundation

class Methods {
    
    class func isValidPassword(pwd: String?) -> Bool {
        if let pwd = pwd where pwd.characters.count >= 8 && pwd.characters.count <= 20 {
            let regex = "^[0-9a-zA-Z]{8,20}$"
            if pwd.rangeOfString(regex, options: .RegularExpressionSearch) != nil {
                return true
            }
        }
        return false
    }
    
}
