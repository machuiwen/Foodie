//
//  Constants.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/7/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import Foundation

struct Constants {
    static let LogInFlag = "LoggedIn"
    static let CurrentUser = "CurrentUser"
    static let EnterAppSegue = "Enter App"
    static let ContinueButton = "Continue"
    static let CancelButton = "Cancel"
    static let LogoutButton = "Log Out"
    static let LogInSuccess = "Log In Successful"
    
    enum UserInfoType {
        case Name
        case Email
        case Address
        case Gender
        case Note
    }
}