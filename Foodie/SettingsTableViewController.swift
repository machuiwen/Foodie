//
//  SettingsTableViewController.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/7/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit
import CoreData

class SettingsTableViewController: UITableViewController {
    
    // MARK: - Public API
    
    var userid: String?
    
    private var firstname: String?
    private var lastname: String?
    private var email: String?
    private var address: String?
    private var gender: String?
    private var userword: String?
    
    private var fullname: String? {
        if firstname == nil || lastname == nil {
            return nil
        } else {
            return firstname! + " " + lastname!
        }
    }
    
    @IBOutlet private weak var profileImage: UIImageView!
    
    var managedObjectContext: NSManagedObjectContext? = AppDelegate.managedObjectContext
    private var defaults = Defaults()
    
    @IBAction private func logOut(sender: UIButton) {
        let alert = UIAlertController(
            title: nil,
            message: "Are you sure to log out?",
            preferredStyle: UIAlertControllerStyle.ActionSheet
        )
        alert.addAction(UIAlertAction(
            title: Constants.LogoutButton,
            style: .Destructive)
            {
                [weak weakSelf = self] (action: UIAlertAction) -> Void in
                weakSelf?.defaults.logOutCurrentUser()
                weakSelf?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
        )
        alert.addAction(UIAlertAction(
            title: Constants.CancelButton,
            style: .Cancel,
            handler: nil)
        )
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 6
        case 1: return 2
        default: return 0
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section{
        case 0:
            switch indexPath.row {
            case 1: cell.detailTextLabel?.text = firstname
            case 2: cell.detailTextLabel?.text = lastname
            case 3: cell.detailTextLabel?.text = userid
            case 4: cell.detailTextLabel?.text = email
            default: break
            }
        case 1:
            switch indexPath.row {
            case 0: cell.detailTextLabel?.text = gender
            default: break
            }
        default:
            break
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userid = defaults.currentUser
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let uid = userid, context = managedObjectContext {
            let user = User.queryUsers(uid, inManagedObjectContext: context)[0]
            firstname = user.firstname
            lastname = user.lastname
            email = user.email
            address = user.address
            if user.image != nil {
                profileImage.image = UIImage(data: user.image!)
            }
            gender = user.gender
            tableView.reloadData()
        }
    }
    
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
        var destinationvc: UIViewController? = segue.destinationViewController
        if let navcon = destinationvc as? UINavigationController {
            destinationvc = navcon.visibleViewController
        }
        if let euitvc = destinationvc as? EditUserInfoTableViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case "Edit First Name": euitvc.info = Constants.UserInfoType.FirstName
                case "Edit Last Name": euitvc.info = Constants.UserInfoType.LastName
                case "Edit Email": euitvc.info = Constants.UserInfoType.Email
                case "Edit Address": euitvc.info = Constants.UserInfoType.Address
                case "Edit Note": euitvc.info = Constants.UserInfoType.Note
                default: break
                }
            }
        }
    }
    
}
