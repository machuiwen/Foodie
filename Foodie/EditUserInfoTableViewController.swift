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
    
    // MARK: - Public API
    
    var info: Constants.UserInfoType? { didSet { tableView.reloadData() } }
    var managedObjectContext: NSManagedObjectContext? = AppDelegate.managedObjectContext
    
    // MARK: - Private Properties
    
    private var defaults = Defaults()
    
    // MARK: - Outlets
    
    @IBOutlet private weak var textField: UITextField!
    
    // MARK: - Actions
    
    @IBAction func save(sender: UIBarButtonItem) {
        if let info = info, uid = defaults.currentUser, context = managedObjectContext {
            let user = User.queryUsers(uid, inManagedObjectContext: context)[0]
            switch info {
            case .FirstName:
                if !Methods.isValidName(textField.text) {
                    showAlert("Invalid First Name")
                } else {
                    updateUserField(user, field: .FirstName, value: textField.text, inManagedObjectContext: context)
                    performSegueWithIdentifier(Constants.PopViewControllerSegue, sender: sender)
                }
            case .LastName:
                if !Methods.isValidName(textField.text) {
                    showAlert("Invalid Last Name")
                } else {
                    updateUserField(user, field: .LastName, value: textField.text, inManagedObjectContext: context)
                    performSegueWithIdentifier(Constants.PopViewControllerSegue, sender: sender)
                }
            case .Email:
                if !Methods.isValidEmail(textField.text) {
                    showAlert("Invalid Email Address")
                } else {
                    updateUserField(user, field: .Email, value: textField.text, inManagedObjectContext: context)
                    performSegueWithIdentifier(Constants.PopViewControllerSegue, sender: sender)
                }
            case .Address:
                updateUserField(user, field: .Address, value: textField.text, inManagedObjectContext: context)
                performSegueWithIdentifier(Constants.PopViewControllerSegue, sender: sender)
            case .Note:
                updateUserField(user, field: .Note, value: textField.text, inManagedObjectContext: context)
                performSegueWithIdentifier(Constants.PopViewControllerSegue, sender: sender)
            default: break
            }
        }
    }
    
    // MARK: - Private Methods
    
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
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
