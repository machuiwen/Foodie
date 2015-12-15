//
//  SettingsTableViewController.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/7/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

class SettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate
{
    
    // MARK: - Public API
    
    var userid: String?
    var managedObjectContext: NSManagedObjectContext? = AppDelegate.managedObjectContext
    
    // MARK: - Private Properties
    
    private var firstname: String?
    private var lastname: String?
    private var email: String?
    private var address: String?
    private var userword: String?
    private var defaults = Defaults()
    
    // MARK: - Outlets
    
    @IBOutlet private weak var profileImage: UIButton!
    
    // MARK: - Actions
    
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
    
    @IBAction private func goBack(segue: UIStoryboardSegue) {
        print("VC Unwinded")
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
        default:
            break
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            let alert = UIAlertController(
                title: nil,
                message: nil,
                preferredStyle: UIAlertControllerStyle.ActionSheet
            )
            alert.addAction(UIAlertAction(
                title: "Take Photo",
                style: .Default) {
                    [unowned self] (action) -> Void in
                    if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                        let picker = UIImagePickerController()
                        picker.sourceType = .Camera
                        picker.mediaTypes = [kUTTypeImage as String]
                        picker.delegate = self
                        picker.allowsEditing = true
                        self.presentViewController(picker, animated: true, completion: nil)
                    }
                }
            )
            alert.addAction(UIAlertAction(
                title: "Choose Photo",
                style: .Default) {
                    [unowned self] (action) -> Void in
                    if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                        let picker = UIImagePickerController()
                        picker.sourceType = .PhotoLibrary
                        picker.mediaTypes = [kUTTypeImage as String]
                        picker.delegate = self
                        picker.allowsEditing = true
                        self.presentViewController(picker, animated: true, completion: nil)
                    }
                }
            )
            alert.addAction(UIAlertAction(
                title: Constants.CancelButton,
                style: .Cancel,
                handler: nil)
            )
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            presentViewController(alert, animated: true, completion: nil)
        }
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
            userid = uid
            email = user.email
            address = user.address
            if user.image != nil {
                profileImage.setImage(UIImage(data: user.image!), forState: UIControlState.Normal)
            }
            tableView.reloadData()
        }
    }
    
    // MARK: Image Picker Controller Delegate
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        if let uid = defaults.currentUser, context = managedObjectContext {
            let user = User.queryUsers(uid, inManagedObjectContext: context)[0]
            context.performBlockAndWait {
                user.image = UIImageJPEGRepresentation(image, 1.0)
                do {
                    try context.save()
                } catch let error {
                    print("Core Data Error: \(error)")
                }
            }
            self.dismissViewControllerAnimated(true, completion: nil)
            self.updatePhoto()
        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    private func updatePhoto() {
        if let uid = userid, context = managedObjectContext {
            if let image = User.queryUsers(uid, inManagedObjectContext: context).first?.image {
                profileImage.setImage(UIImage(data: image), forState: UIControlState.Normal)
            }
        }
    }
    
    // MARK: - Navigation
    
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
        } else if let uivc = destinationvc as? UserImageViewController {
            uivc.image = profileImage.imageView?.image
        } else if let mapvc = destinationvc as? MapViewController {
            if let uid = userid, context = managedObjectContext {
                if let addr = User.queryUsers(uid, inManagedObjectContext: context).first?.address {
                    mapvc.locations = [addr]
                }
            }
        }
    }
    
}
