//
//  Restaurant+CoreDataProperties.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/8/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Restaurant {

    @NSManaged var name: String?
    @NSManaged var type: String?
    @NSManaged var detailDescription: String?
    @NSManaged var openStatus: NSNumber?
    @NSManaged var phoneNumber: NSNumber?
    @NSManaged var formattedAddress: String?
    @NSManaged var priceLevel: NSNumber?
    @NSManaged var websiteStr: String?
    @NSManaged var rating: NSNumber?
    @NSManaged var email: String?
    @NSManaged var imageURLStr: String?
    @NSManaged var liked: NSSet?

}
