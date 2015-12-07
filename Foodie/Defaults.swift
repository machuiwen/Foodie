//
//  Defaults.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/7/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import Foundation

class Defaults {
    
    private var defaults = NSUserDefaults.standardUserDefaults()
    
    func logInWithUser(user: String) {
        defaults.setObject(user, forKey: Constants.CurrentUser)
        defaults.setBool(true, forKey: Constants.LogInFlag)
    }
    
    func logOutCurrentUser() {
        defaults.setBool(false, forKey: Constants.LogInFlag)
        defaults.removeObjectForKey(Constants.CurrentUser)
    }
    
}