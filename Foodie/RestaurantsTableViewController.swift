//
//  RestaurantsTableViewController.swift
//  Foodie
//
//  Created by Chuiwen Ma on 11/30/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class RestaurantsTableViewController: UITableViewController {
    
    //    var searchText: String? {
    //        didSet {
    //            searchTextField?.text = searchText
    //            tweets.removeAll()
    //            lastTwitterRequest = nil
    //            searchForTweets()
    //            title = searchText
    //            recentSearches.add(searchText)
    //        }
    //    }
    
    @IBOutlet private weak var headerImageView: UIImageView!
    
//    @IBOutlet private weak var headerScrollView: UIScrollView! { didSet { headerScrollView.delegate = self } }
    
//    private var headerImageView = UIImageView()
    
    var restaurants = [Array<Restaurant>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        restaurants.append([
            Restaurant(
                name: "Peking Duck Restaurant",
                type: "Chinese",
                description: "Traditional Chinese duck",
                imageURL: "http://media-cdn.tripadvisor.com/media/photo-s/02/c4/72/96/new-peking-duck-chinese.jpg",
                address: "151 California Ave, Palo Alto, CA 94306",
                phone: 6504981388,
                website: "http://www.yelp.com/biz/peking-duck-restaurant-palo-alto"
            ),
            Restaurant(
                name: "Tofu House",
                type: "Korean",
                description: "Very hot!!",
                imageURL: "https://lh5.googleusercontent.com/-coA3W-VOtGw/UhgHZBiMDwI/AAAAAAAAJDY/dBfDpKzytao/s408-k-no/",
                address: "4127 El Camino Real, Palo Alto, CA 94306",
                phone: 6507960930,
                website: "https://www.google.com"
            )
            ])
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return restaurants.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("RestaurantCell", forIndexPath: indexPath)
        
        let restaurant = restaurants[indexPath.section][indexPath.row]
        if let restaurantCell = cell as? RestaurantTableViewCell {
            restaurantCell.restaurant = restaurant
        }
        return cell
    }
    
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
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
