//
//  RestaurantsTableViewController.swift
//  Foodie
//
//  Created by Chuiwen Ma on 11/30/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit
import CoreData

class RestaurantsTableViewController: UITableViewController {
    
    // MARK: - Public API
    
    var managedObjectContext: NSManagedObjectContext? = AppDelegate.managedObjectContext
    var restaurants = [Restaurant]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Private Properties
    
    private var defaults = Defaults()
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let context = managedObjectContext {
            restaurants = Restaurant.queryAllRestaurants(inManagedObjectContext: context)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.RestaurantCell, forIndexPath: indexPath)
        
        let restaurant = restaurants[indexPath.row]
        if let restaurantCell = cell as? RestaurantTableViewCell {
            restaurantCell.restaurant = restaurant
        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationvc: UIViewController? = segue.destinationViewController
        if let navcon = destinationvc as? UINavigationController {
            destinationvc = navcon.visibleViewController
        }
        if let rivc = destinationvc as? RestaurantInfoTableViewController {
            if let cell = sender as? RestaurantTableViewCell {
                rivc.navigationItem.title = cell.restaurant?.name
                rivc.restaurant = cell.restaurant
            }
        }
    }
    
}
