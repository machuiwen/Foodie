//
//  RestaurantInfoTableViewController.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/1/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class RestaurantInfoTableViewController: UITableViewController {
    
    // MARK: Public API
    
    var restaurant: Restaurant? { didSet { tableView.reloadData() } }
    var managedObjectContext: NSManagedObjectContext? = AppDelegate.managedObjectContext
    
    // MARK: Private Properties
    
    private var defaults = Defaults()
    private var locationManager = CLLocationManager()
    
    private struct SectionInfo {
        var titleForHeader: String?
        var cellType: String
        var numberOfRows: Int
        var segueIdentifier: String?
    }
    
    private var sections: [SectionInfo] {
        get {
            if let _ = restaurant {
                return [
                    // show image
                    SectionInfo(titleForHeader: nil, cellType: "ProfileImageCell", numberOfRows: 1, segueIdentifier: "Show Images"),
                    // map
                    SectionInfo(titleForHeader: nil, cellType: "MapviewCell", numberOfRows: 1, segueIdentifier: nil),
                    SectionInfo(titleForHeader: nil, cellType: "BasicInfoCell", numberOfRows: 1, segueIdentifier: "Show Map"),
                    // call
                    SectionInfo(titleForHeader: nil, cellType: "BasicInfoCell", numberOfRows: 1, segueIdentifier: nil),
                    SectionInfo(titleForHeader: nil, cellType: "BasicInfoCell", numberOfRows: 1, segueIdentifier: "Show Website"),
                ]
            } else {
                return [SectionInfo]()
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func share(sender: UIBarButtonItem) {
        if let restaurant = restaurant {
            let activityViewController = UIActivityViewController(
                activityItems: [
                    restaurant.name!,
                    restaurant.type!,
                    restaurant.formattedAddress!,
                ],
                applicationActivities: nil)
            presentViewController(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func addToFavorite(sender: UIBarButtonItem) {
        if let restaurant = restaurant, uid = defaults.currentUser, context = managedObjectContext {
            if let user = User.queryUsers(uid, inManagedObjectContext: context).first {
                context.performBlock {
                    user.addRestaurantObject(restaurant)
                    do {
                        try context.save()
                    } catch let error {
                        print("Core Data Error: \(error)")
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].numberOfRows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(sections[indexPath.section].cellType, forIndexPath: indexPath)
        switch indexPath.section {
        case 0:
            if let imageCell = cell as? ProfileImageTableViewCell {
                imageCell.restaurant = restaurant
            }
        case 1:
            if let mapCell = cell as? MapTableViewCell {
                mapCell.address = restaurant?.formattedAddress
            }
        case 2:
            cell.textLabel?.text = "Address"
            cell.detailTextLabel?.text = restaurant?.formattedAddress
        case 3:
            cell.textLabel?.text = "Phone Number"
            cell.detailTextLabel?.text = restaurant?.phoneNumberStr
        case 4:
            cell.textLabel?.text = "Website"
            if let url = restaurant?.website {
                cell.detailTextLabel?.text = "\(url)"
            }
        default: break
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].titleForHeader
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.hidden = sections[section].numberOfRows == 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if restaurant == nil {
            return UITableViewAutomaticDimension
        }
        switch indexPath.section {
        case 0:
            return tableView.frame.width / CGFloat(4.0/3.0)
        case 1:
            return 150.0
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let segueIdentifier = sections[indexPath.section].segueIdentifier {
            performSegueWithIdentifier(segueIdentifier, sender: tableView.cellForRowAtIndexPath(indexPath))
        } else {
            switch indexPath.section {
            case 3:
                if let phone = restaurant?.phoneNumber {
                    if let url = NSURL(string: "tel://\(phone)") {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
            default:
                break
                
            }
        }
    }
    
    // MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationvc: UIViewController? = segue.destinationViewController
        if let navcon = destinationvc as? UINavigationController {
            destinationvc = navcon.visibleViewController
        }
        destinationvc?.navigationItem.title = restaurant?.name
        if let webvc = destinationvc as? WebViewController {
            if let urlCell = sender as? UITableViewCell {
                webvc.urlPath = urlCell.detailTextLabel?.text
            }
        } else if let imagesvc = destinationvc as? ImageCollectionViewController {
            imagesvc.imageURLs = (restaurant?.moreImageURLs)!
        } else if let mapvc = destinationvc as? MapViewController,
            address = (sender as? UITableViewCell)?.detailTextLabel?.text
        {
            mapvc.locations = [address]
        }
    }
    
}
