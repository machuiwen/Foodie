//
//  User.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/5/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import Foundation
import CoreData


class User: NSManagedObject {

    class func addUser(userid: String, password: String, firstname: String, lastname: String, inManagedObjectContext context: NSManagedObjectContext) {
        if let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context) as? User {
            user.id = userid
            user.password = password
            user.firstname = firstname
            user.lastname = lastname
        }
    }
    
    class func queryUsers(userid: String, inManagedObjectContext context: NSManagedObjectContext) -> [User] {
        let request = NSFetchRequest(entityName: "User")
        request.predicate = NSPredicate(format: "id = %@", userid)
        let users = (try? context.executeFetchRequest(request)) as? [User] ?? []
        return users
    }
    
    var name: String? {
        if firstname == nil || lastname == nil {
            return nil
        } else {
            return firstname! + Constants.Space + lastname!
        }
    }
    
    // add a Restaurant object to favorites
    func addRestaurantObject(value: Restaurant) {
        self.mutableSetValueForKey("favorites").addObject(value)
    }
    
    // remove a Restaurant from favorites
    func removeRestaurantObject(value: Restaurant) {
        self.mutableSetValueForKey("favorites").removeObject(value)
    }
    
    var audioNotePath: NSURL? {
        return strToUrl(string: audioNotePathStr)
    }
    
    private func strToUrl(string string: String?) -> NSURL? {
        if let url = string {
            return NSURL(string: url)
        }
        return nil
    }
    
}
