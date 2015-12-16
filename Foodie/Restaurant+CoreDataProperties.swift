//
//  Restaurant+CoreDataProperties.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/16/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Restaurant {

    @NSManaged var detailDescription: String?
    @NSManaged var email: String?
    @NSManaged var formattedAddress: String?
    @NSManaged var imageURLStr: String?
    @NSManaged var name: String?
    @NSManaged var openStatus: NSNumber?
    @NSManaged var phoneNumber: NSNumber?
    @NSManaged var priceLevel: NSNumber?
    @NSManaged var profileImage: NSData?
    @NSManaged var rating: NSNumber?
    @NSManaged var type: String?
    @NSManaged var websiteStr: String?
    @NSManaged var liked: NSSet?

}
