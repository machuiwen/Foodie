//
//  LogInViewController.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/7/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit
import CoreData

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet private weak var userid: UITextField!
    @IBOutlet private weak var password: UITextField!
    
    // MARK: managedObjectContext
    
    var managedObjectContext: NSManagedObjectContext = AppDelegate.managedObjectContext!
    var defaults = Defaults()
    
    // MARK: Actions
    
    @IBAction func goBack(sender: UIButton) {
        self.view.endEditing(true)
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func logIn(sender: UIButton) {
        if let uid = userid.text {
            let users = User.queryUsers(uid, inManagedObjectContext: managedObjectContext)
            if !users.isEmpty {
                if users[0].password == password.text {
                    defaults.logInWithUser(uid)
                    clearContents()
                    performSegueWithIdentifier("Explore App", sender: sender)
                } else {
                    password.text = ""
                    showAlert("Wrong password", message: "Try again!")
                }
            } else {
                clearContents()
                showAlert("User not exist", message: "Try again!")
            }
        }
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userid.delegate = self
        password.delegate = self
    }
    
    // MARK: Private methods
    
    private func showAlert(title: String?, message: String? = nil,
        actions: [UIAlertAction] = [UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: nil)]) {
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
    
    private func clearContents() {
        userid.text = ""
        password.text = ""
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
