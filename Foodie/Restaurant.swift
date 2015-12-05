//
//  Restaurant.swift
//  Foodie
//
//  Created by Chuiwen Ma on 11/30/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import Foundation

class Restaurant {
    var name: String?
    var type: String?
    var description: String?
    //    var coordinate: CLLocation?
    var openNowStatus: Bool?
    var phoneNumber: Int?
    var formattedAddress: String?
    var priceLevel: Int?
    var website: NSURL?
    var rating: Float?
    var reviews: [String]?
    var email: String?
    var imageURL: NSURL?
    //    var moreImageURLs = [NSURL]()
    var moreImageURLs: [NSURL] = [
        NSURL(string: "http://media-cdn.tripadvisor.com/media/photo-s/02/c4/72/96/new-peking-duck-chinese.jpg")!,
        NSURL(string: "https://lh5.googleusercontent.com/-coA3W-VOtGw/UhgHZBiMDwI/AAAAAAAAJDY/dBfDpKzytao/s408-k-no/")!
    ]
    
    var phoneNumberStr: String? {
        if phoneNumber == nil {
            return nil
        } else {
            let s1 = String(format: "%03d", phoneNumber! / 10000000)
            let s2 = String(format: "%03d", phoneNumber! % 10000000 / 10000)
            let s3 = String(format: "%04d", phoneNumber! % 10000)
            return "(" + s1 + ")" + " " + s2 + "-" + s3
        }
    }
    
    init (name: String, type: String, description: String? = nil,
        imageURL: String, address: String? = nil, phone: Int? = nil,
        website: String? = nil, email: String? = nil) {
            self.name = name
            self.type = type
            self.description = description
            self.imageURL = NSURL(string: imageURL)
            self.formattedAddress = address
            self.phoneNumber = phone
            if let website = website {
                self.website = NSURL(string: website)
            }
    }
}