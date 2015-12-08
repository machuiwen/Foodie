//
//  Defaults.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/7/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import Foundation

// NSUserDefaults wrapper
class Defaults {
    
    private var defaults = NSUserDefaults.standardUserDefaults()
    
    func logInWithUser(user: String) {
        defaults.setObject(user, forKey: Constants.CurrentUser)
        defaults.setBool(true, forKey: Constants.LogInFlag)
    }
    
    func logOutCurrentUser() {
        defaults.removeObjectForKey(Constants.CurrentUser)
        defaults.setBool(false, forKey: Constants.LogInFlag)
    }
    
    var currentUser: String? {
        return defaults.stringForKey(Constants.CurrentUser)
    }
    
    var loggedIn: Bool? {
        return defaults.boolForKey(Constants.LogInFlag)
    }
    
}