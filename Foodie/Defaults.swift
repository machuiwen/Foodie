//
//  Defaults.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/7/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit
import Foundation

// NSUserDefaults wrapper
class Defaults {
    
    private var defaults = NSUserDefaults.standardUserDefaults()
    
    func initializeApp() {
        if defaults.boolForKey(Constants.AppInitialized) == true {
            return
        }
        // initialize app with restaurants
        if let context = AppDelegate.managedObjectContext {
            context.performBlock {
                Restaurant.addRestaurant("Peking Duck Restaurant", type: "Chinese", description: "Traditional Chinese delicacy", openStatus: true, phoneNumber: 6504981388, formattedAddress: "151 California Ave, Palo Alto, CA 94306", priceLevel: 30, website: "http://www.yelp.com/biz/peking-duck-restaurant-palo-alto", rating: 3.9, imageURL: "http://media-cdn.tripadvisor.com/media/photo-s/02/c4/72/96/new-peking-duck-chinese.jpg", inManagedObjectContext: context)
                Restaurant.addRestaurant("Tofu House", type: "Korean", description: "Very hot!", openStatus: false, phoneNumber: 6507960930, formattedAddress: "4127 El Camino Real, Palo Alto, CA 94306", priceLevel: 15, website: "http://www.yelp.com/biz/so-gong-dong-tofu-house-palo-alto", rating: 4.2, imageURL: "https://lh5.googleusercontent.com/-coA3W-VOtGw/UhgHZBiMDwI/AAAAAAAAJDY/dBfDpKzytao/s408-k-no/", inManagedObjectContext: context)
                Restaurant.addRestaurant("Sushi House", type: "Japanese", description: "Best sushi in Bay Area", openStatus: true, phoneNumber: 6503213453, formattedAddress: "Town & Country Village, 158 El Camino Real #855, Palo Alto, CA 94301", priceLevel: 18, website: "http://www.yelp.com/biz/sushi-house-palo-alto", rating: 4.2, imageURL: "http://s3-media2.fl.yelpcdn.com/bphoto/Ns7cN3OKgXXhHh3EEVz89w/o.jpg", inManagedObjectContext: context)
                Restaurant.addRestaurant("Arrillaga Family Dining Commons", type: "Dining Hall", description: "Go Cardinal!", openStatus: true, phoneNumber: 6501234567, formattedAddress: "489 Arguello Way, Stanford, CA 94305", priceLevel: 9, website: "https://rde.stanford.edu/dining/arrillaga-family-dining-commons", rating: 4.6, imageURL: "http://rde-stanford-edu.s3.amazonaws.com/Dining/Images/afdc-exterior_0.jpg", inManagedObjectContext: context)
                Restaurant.addRestaurant("Graduate Community Center", type: "Bar/Coffee", description: "Saturday tradition", openStatus: false, phoneNumber: 6507254739, formattedAddress: "750 Escondido Rd, Stanford, CA 94305", priceLevel: 8, website: "https://rde.stanford.edu/studenthousing/gcc", rating: 4.7, imageURL: "http://rde-stanford-edu.s3.amazonaws.com/Housing/Images/gcc-artists.jpg", inManagedObjectContext: context)
                do {
                    try context.save()
                } catch let error {
                    print("Core Data Error: \(error)")
                }
            }
        }
        
        // initialize notification
        // http://stackoverflow.com/questions/31170112/notification-in-swift-every-day-at-a-set-time
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Month, NSCalendarUnit.Year, NSCalendarUnit.Day], fromDate: NSDate())
        components.hour = 18
        components.minute = 0
        components.second = 0
        calendar.timeZone = NSTimeZone.localTimeZone()
        let dayToFire = calendar.dateFromComponents(components)
        let notification = UILocalNotification()
        notification.timeZone = NSTimeZone.localTimeZone()
        notification.fireDate = dayToFire
        notification.alertBody = "Feel hungry? Find a restaurant!!"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        defaults.setBool(true, forKey: Constants.AppInitialized)
    }
    
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