//
//  SignUpViewController.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/5/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet private weak var userid: UITextField!
    @IBOutlet private weak var password: UITextField!
    @IBOutlet private weak var firstname: UITextField!
    @IBOutlet private weak var lastname: UITextField!
    
    // MARK: managedObjectContext
    
    var managedObjectContext: NSManagedObjectContext = AppDelegate.managedObjectContext!
    
    // MARK: Actions
    
    @IBAction func goBack(sender: AnyObject) {
        // hide keyboard
        self.view.endEditing(true)
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signUp(sender: UIButton) {
        if let uid = userid.text {
            let users = User.queryUsers(uid, inManagedObjectContext: managedObjectContext)
            if users.count > 0 {
                showAlert("Invalid ID", message: "User ID already exists")
                return
            }
            if uid.characters.count < 6 {
                showAlert("Invalid ID", message: "User ID should be at least 6 characters")
            } else if !isValidPassword(password.text) {
                showAlert("Invalid Password", message: "8-20 characters in 0-9, a-z or A-Z")
            } else if firstname.text == nil || firstname.text!.isEmpty {
                showAlert("Invalid Name", message: "First name cannot be empty")
            } else if lastname.text == nil || lastname.text!.isEmpty {
                showAlert("Invalid Name", message: "Last name cannot be empty")
            } else {
                User.addUser(uid, password: password.text!, firstname: firstname.text!, lastname: lastname.text!, inManagedObjectContext: managedObjectContext)
                showAlert("Successfully registered!", message: "Go back to log in", actions: [
                    UIAlertAction(
                        title: "Continue", style: UIAlertActionStyle.Default) {
                            [weak weakSelf = self] (action) -> Void in
                            weakSelf?.view.endEditing(true)
                            weakSelf?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                    }]
                )
            }
        }
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userid.delegate = self
        password.delegate = self
        firstname.delegate = self
        lastname.delegate = self
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
    
    private func isValidPassword(pwd: String?) -> Bool {
        if let pwd = pwd where pwd.characters.count >= 8 && pwd.characters.count <= 20 {
            let regex = "^[0-9a-zA-Z]{8,20}$"
            if pwd.rangeOfString(regex, options: .RegularExpressionSearch) != nil {
                return true
            }
        }
        return false
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
