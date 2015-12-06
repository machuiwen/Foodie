//
//  RestaurantInfoTableViewController.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/1/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit
import MapKit

class RestaurantInfoTableViewController: UITableViewController {
    
    // MARK: Public API
    
    var restaurant: Restaurant? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: Private data structure
    
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
                    SectionInfo(titleForHeader: nil, cellType: "MapviewCell", numberOfRows: 1, segueIdentifier: "Show Map"),
                    // call
                    SectionInfo(titleForHeader: nil, cellType: "BasicInfoCell", numberOfRows: 1, segueIdentifier: nil),
                    // map
                    SectionInfo(titleForHeader: nil, cellType: "BasicInfoCell", numberOfRows: 1, segueIdentifier: nil),
                    SectionInfo(titleForHeader: nil, cellType: "BasicInfoCell", numberOfRows: 1, segueIdentifier: "Show Website"),
                ]
            } else {
                return [SectionInfo]()
            }
        }
    }
    
    private var locationManager = CLLocationManager()
    
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
            cell.textLabel?.text = "Phone Number"
            cell.detailTextLabel?.text = restaurant?.phoneNumberStr
        case 3:
            cell.textLabel?.text = "Address"
            cell.detailTextLabel?.text = restaurant?.formattedAddress
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
            if indexPath.section == 2 {
                if let phone = restaurant?.phoneNumber {
                    if let url = NSURL(string: "tel://\(phone)") {
                        UIApplication.sharedApplication().openURL(url)
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
        destinationvc?.navigationItem.title = restaurant?.name
        if let webvc = destinationvc as? WebViewController {
            if let urlCell = sender as? UITableViewCell {
                webvc.urlPath = urlCell.detailTextLabel?.text
            }
        } else if let imagesvc = destinationvc as? ImageCollectionViewController {
            imagesvc.imageURLs = (restaurant?.moreImageURLs)!
        }
        //            if let tweetvc = destinationvc as? TweetTableViewController {
        //                if let mention = sender as? UITableViewCell {
        //                    if segue.identifier == "Search User" {
        //                        tweetvc.searchText = mention.textLabel?.text
        //                        /*
        //                        // HW4 extra credit, introduce confusion in HW5
        //                        if let user = mention.textLabel?.text {
        //                        tweetvc.searchText = user + " OR " + user.substringFromIndex(user.startIndex.advancedBy(1))
        //                        }
        //                        */
        //                    } else if segue.identifier == "Search Hashtag" {
        //                        tweetvc.searchText = mention.textLabel?.text
        //                    }
        //                }
        //            } else if let imagevc = destinationvc as? ImageViewController {
        //                if let imageCell = sender as? ImageTableViewCell {
        //                    imagevc.image = imageCell.myImage
        //                }
        //            } else if let webvc = destinationvc as? WebViewController {
        //                if let urlCell = sender as? UITableViewCell {
        //                    webvc.urlPath = urlCell.textLabel?.text
        //                }
        //            }
    }
    
    //    @IBAction private func goBackToRootView(sender: UIBarButtonItem) {
    //        self.navigationController?.popToRootViewControllerAnimated(true)
    //    }
    
    //////
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // MARK: - Table view data source
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
