//
//  FavoriteRestaurantTableViewController.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/8/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit
import CoreData

class FavoriteRestaurantTableViewController: UITableViewController {
    
    // MARK: - Propertities
    
    private var restaurants = [Restaurant]()
    private var managedObjectContext: NSManagedObjectContext? = AppDelegate.managedObjectContext
    private var defaults = Defaults()
    
    // MARK: - ViewController Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let context = managedObjectContext, uid = defaults.currentUser {
            if let user = User.queryUsers(uid, inManagedObjectContext: context).first {
                restaurants = (user.favorites?.allObjects as? [Restaurant]) ?? []
                tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.FavoriteRestaurantCell, forIndexPath: indexPath)
        cell.textLabel?.text = restaurants[indexPath.row].name
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let restaurant = restaurants[indexPath.row]
            deleteFavoriteRestaurantFromUser(restaurant)
            restaurants.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    // MARK: - Private Methods
    
    private func deleteFavoriteRestaurantFromUser(restaurant: Restaurant) {
        if let context = managedObjectContext, uid = defaults.currentUser {
            if let user = User.queryUsers(uid, inManagedObjectContext: context).first {
                context.performBlockAndWait {
                    user.removeRestaurantObject(restaurant)
                    do {
                        try context.save()
                    } catch let error {
                        print("Core Data Error: \(error)")
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationvc: UIViewController? = segue.destinationViewController
        if let navcon = destinationvc as? UINavigationController {
            destinationvc = navcon.visibleViewController
        }
        if let rivc = destinationvc as? RestaurantInfoTableViewController {
            if let cell = sender as? UITableViewCell {
                if let rname = cell.textLabel?.text, context = managedObjectContext {
                    rivc.navigationItem.title = rname
                    rivc.restaurant = Restaurant.queryRestaurant(rname, inManagedObjectContext: context)
                }
            }
        }
    }
    
}
