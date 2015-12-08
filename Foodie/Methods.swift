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
    
    class func isValidName(name: String?) -> Bool {
        if let name = name {
            let regex = "^[A-Z][a-z]*$"
            if name.rangeOfString(regex, options: .RegularExpressionSearch) != nil {
                return true
            }
        }
        return false
    }
    
    class func isValidEmail(email: String?) -> Bool {
        if let email = email {
            let regex = "^[0-9A-Za-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
            if email.rangeOfString(regex, options: .RegularExpressionSearch) != nil {
                return true
            } else if email == "" {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
}
