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
    static let PopViewControllerSegue = "Pop VC"
    static let GoogleSearchRequestPrefix = "https://www.google.com/search?q="
    static let EmptyStr = ""
    static let Space = " "
    static let Comma = ","
    static let Period = "."
    static let Splitter = "   |   "
    static let AppInitialized = "Innitialized"
    static let RestaurantCell = "RestaurantCell"
    static let FavoriteRestaurantCell = "FavoriteRestaurantCell"
    static let AudioSuffix = ".wav"
    static let AudioDefaultPrefix = "my_audio"
    static let PrintJobName = "Foodie Print Job"
    
    enum UserInfoType {
        case FirstName
        case LastName
        case Email
        case Address
        case Gender
        case Note
    }
}