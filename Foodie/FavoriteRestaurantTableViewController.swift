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
    
    // MARK: - Outlet
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Propertities
    
    private var restaurants = [Restaurant]()
    private var managedObjectContext: NSManagedObjectContext? = AppDelegate.managedObjectContext
    private var defaults = Defaults()
    
    // MARK: - Action
    
    // http://www.ioscreator.com/tutorials/airprint-tutorial-ios8-swift
    @IBAction private func printList(sender: UIBarButtonItem) {
        let printController = UIPrintInteractionController.sharedPrintController()
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfoOutputType.General
        printInfo.jobName = Constants.PrintJobName
        printController.printInfo = printInfo
        let printContent = getPrintContent()
        let formatter = UIMarkupTextPrintFormatter(markupText: printContent)
        formatter.contentInsets = UIEdgeInsets(top: 72, left: 72, bottom: 72, right: 72)
        printController.printFormatter = formatter
        printController.presentAnimated(true, completionHandler: nil)
    }
    
    @IBAction private func sort(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            restaurants.sortInPlace({ $0.name < $1.name })
            tableView.reloadData()
        case 1:
            restaurants.sortInPlace({ $0.rating?.doubleValue > $1.rating?.doubleValue })
            tableView.reloadData()
        default:
            break
        }
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let context = managedObjectContext, uid = defaults.currentUser {
            if let user = User.queryUsers(uid, inManagedObjectContext: context).first {
                restaurants = (user.favorites?.allObjects as? [Restaurant]) ?? []
                sort(segmentedControl)
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
        cell.detailTextLabel?.text = restaurants[indexPath.row].ratingStr
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
    
    private func getPrintContent() -> String {
        var content: String = "Favorite Restaurants. "
        for r in restaurants {
            if let name = r.name {
                content += name + Constants.Comma
            }
            if let type = r.type {
                content += type + Constants.Comma
            }
            if let phoneNumber = r.phoneNumberStr {
                content += phoneNumber + Constants.Comma
            }
            if let address = r.formattedAddress {
                content += address + Constants.Comma
            }
            content += Constants.Splitter
        }
        return content
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
