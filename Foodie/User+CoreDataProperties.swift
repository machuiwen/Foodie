//
//  User+CoreDataProperties.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/5/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var id: String?
    @NSManaged var image: NSData?
    @NSManaged var firstname: String?
    @NSManaged var lastname: String?
    @NSManaged var password: String?

}
