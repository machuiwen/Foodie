//
//  EditUserInfoTableViewController.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/7/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit
import CoreData

class EditUserInfoTableViewController: UITableViewController, UITextFieldDelegate {
    
    var info: Constants.UserInfoType? {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        if let info = info, uid = defaults.currentUser, context = managedObjectContext {
            let user = User.queryUsers(uid, inManagedObjectContext: context)[0]
            switch info {
            case .FirstName:
                if !Methods.isValidName(textField.text) {
                    showAlert("Invalid First Name")
                } else {
                    updateUserField(user, field: .FirstName, value: textField.text, inManagedObjectContext: context)
                    self.view.endEditing(true)
                    navigationController?.popToRootViewControllerAnimated(true)
                }
            case .LastName:
                if !Methods.isValidName(textField.text) {
                    showAlert("Invalid Last Name")
                } else {
                    updateUserField(user, field: .LastName, value: textField.text, inManagedObjectContext: context)
                    self.view.endEditing(true)
                    navigationController?.popToRootViewControllerAnimated(true)
                }
            case .Email:
                if !Methods.isValidEmail(textField.text) {
                    showAlert("Invalid Email Address")
                } else {
                    updateUserField(user, field: .Email, value: textField.text, inManagedObjectContext: context)
                    self.view.endEditing(true)
                    navigationController?.popToRootViewControllerAnimated(true)
                }
            case .Address:
                updateUserField(user, field: .Address, value: textField.text, inManagedObjectContext: context)
                self.view.endEditing(true)
                navigationController?.popToRootViewControllerAnimated(true)
            case .Note:
                updateUserField(user, field: .Note, value: textField.text, inManagedObjectContext: context)
                self.view.endEditing(true)
                navigationController?.popToRootViewControllerAnimated(true)
            default: break
                
            }
            //            switch type {
            //            case .Nickname:
            //                userQuery.modifyUser(userId, attribute: Constants.NicknameKey, value: infoText.text)
            //                self.view.endEditing(true)
            //                presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            //            case .EmailAddress:
            //                if Methods.isValidEmailAddress(infoText.text) {
            //                    if userQuery.exactSearch(Constants.EmailKey, keyword: infoText.text).isEmpty {
            //                        userQuery.modifyUser(userId, attribute: Constants.EmailKey, value: infoText.text)
            //                        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            //                    } else {
            //                        showAlert("Email address already exists", button: Constants.ContinueButton)
            //                    }
            //                } else {
            //                    showAlert("Invalid Email address", button: Constants.ContinueButton)
            //                }
            //            case .SaySomething:
            //                userQuery.modifyUser(userId, attribute: Constants.SaySomethingKey, value: infoText.text)
            //                self.view.endEditing(true)
            //                presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            //            }
        }
    }
    
    private func updateUserField(user: User, field: Constants.UserInfoType, value: String?,
        inManagedObjectContext context: NSManagedObjectContext)
    {
        context.performBlock {
            switch field {
            case .FirstName:
                user.firstname = value
            case .LastName:
                user.lastname = value
            case .Email:
                user.email = value
            case .Address:
                user.address = value
            case .Note:
                user.myWord = value
            default:
                break
            }
            do {
                try context.save()
            } catch let error {
                print("Core Data Error: \(error)")
            }
        }
    }
    
    @IBOutlet private weak var textField: UITextField!
    
    var managedObjectContext: NSManagedObjectContext? = AppDelegate.managedObjectContext
    private var defaults = Defaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let uid = defaults.currentUser, context = managedObjectContext {
            let user = User.queryUsers(uid, inManagedObjectContext: context)[0]
            if let info = info {
                switch info {
                case .FirstName: textField.text = user.firstname
                case .LastName: textField.text = user.lastname
                case .Email: textField.text = user.email
                case .Address: textField.text = user.address
                case .Gender: textField.text = user.gender
                case .Note: textField.text = user.myWord
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    //    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    //        return true
    //    }
    
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
    
    private func showAlert(title: String?, message: String? = nil,
        actions: [UIAlertAction] = [UIAlertAction(
            title: Constants.ContinueButton,
            style: UIAlertActionStyle.Default,
            handler: nil)])
    {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert
        )
        for action in actions {
            alert.addAction(action)
        }
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
