//
//  Restaurant.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/8/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import Foundation
import CoreData


class Restaurant: NSManagedObject {
    
    class func addRestaurant(name: String, type: String, description: String? = nil, openStatus: Bool = true, phoneNumber: Int? = nil, formattedAddress: String, priceLevel: Int?, website: String? = nil, rating: Double? = nil, email: String? = nil, imageURL: String, inManagedObjectContext context: NSManagedObjectContext) {
        if let r = NSEntityDescription.insertNewObjectForEntityForName("Restaurant", inManagedObjectContext: context) as? Restaurant {
            r.name = name
            r.type = type
            r.detailDescription = description
            r.openStatus = openStatus
            r.phoneNumber = phoneNumber
            r.formattedAddress = formattedAddress
            r.priceLevel = priceLevel
            r.websiteStr = website
            r.rating = rating
            r.email = email
            r.imageURLStr = imageURL
        }
    }
    
    class func queryAllRestaurants(inManagedObjectContext context: NSManagedObjectContext) -> [Restaurant] {
        let request = NSFetchRequest(entityName: "Restaurant")
        request.predicate = nil
        let restaurants = (try? context.executeFetchRequest(request)) as? [Restaurant] ?? []
        return restaurants
    }
    
    class func queryRestaurant(name: String, inManagedObjectContext context: NSManagedObjectContext) -> Restaurant? {
        let request = NSFetchRequest(entityName: "Restaurant")
        request.predicate = NSPredicate(format: "name = %@", name)
        let restaurants = (try? context.executeFetchRequest(request)) as? [Restaurant] ?? []
        return restaurants.first
    }
    
    var phoneNumberStr: String? {
        if let phoneNumber = phoneNumber as? Int {
            let s1 = String(format: "%03d", phoneNumber / 10000000)
            let s2 = String(format: "%03d", phoneNumber % 10000000 / 10000)
            let s3 = String(format: "%04d", phoneNumber % 10000)
            return "(" + s1 + ")" + " " + s2 + "-" + s3
        }
        return nil
    }
    
    var imageURL: NSURL? {
        return strToUrl(string: imageURLStr)
    }
    
    var website: NSURL? {
        return strToUrl(string: websiteStr)
    }
    
    var price: String? {
        if let p = priceLevel?.integerValue {
            if p <= 10 {
                return "$"
            } else if p <= 20 {
                return "$$"
            } else if p <= 30 {
                return "$$$"
            } else {
                return "$$$$"
            }
        }
        return nil
    }
    
    var moreImageURLs: [NSURL] = [
        NSURL(string: "http://media-cdn.tripadvisor.com/media/photo-s/02/c4/72/96/new-peking-duck-chinese.jpg")!,
        NSURL(string: "https://lh5.googleusercontent.com/-coA3W-VOtGw/UhgHZBiMDwI/AAAAAAAAJDY/dBfDpKzytao/s408-k-no/")!
    ]
    
    private func strToUrl(string string: String?) -> NSURL? {
        if let url = string {
            return NSURL(string: url)
        }
        return nil
    }

}
