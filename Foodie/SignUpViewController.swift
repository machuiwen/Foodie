//
//  SignUpViewController.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/5/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var userid: UITextField!
    @IBOutlet private weak var password: UITextField!
    @IBOutlet private weak var firstname: UITextField!
    @IBOutlet private weak var lastname: UITextField!
    
    // MARK: - ManagedObjectContext
    
    var managedObjectContext: NSManagedObjectContext? = AppDelegate.managedObjectContext
    
    // MARK: - Actions
    
    @IBAction private func goBack(sender: UIButton) {
        // exit keyboard
        self.view.endEditing(true)
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction private func signUp(sender: UIButton) {
        self.view.endEditing(true)
        if let uid = userid.text, let context = managedObjectContext {
            let users = User.queryUsers(uid, inManagedObjectContext: context)
            if !users.isEmpty {
                showAlert("Invalid ID", message: "User ID already exists")
                return
            }
            if uid.characters.count < 6 || uid.characters.count > 20 {
                showAlert("Invalid ID", message: "User ID should be in 6-20 characters")
            } else if !Methods.isValidPassword(password.text) {
                showAlert("Invalid Password", message: "8-20 characters in 0-9, a-z or A-Z")
                password.text = nil
            } else if !Methods.isValidName(firstname.text) {
                showAlert("Invalid Name", message: "Please try again")
            } else if !Methods.isValidName(lastname.text) {
                showAlert("Invalid Name", message: "Please try again")
            } else {
                updateDBWithNewUser(uid, password: password.text!,
                    firstname: firstname.text!, lastname: lastname.text!,
                    inManagedObjectContext: context)
                showAlert("Successfully registered!", message: "Go back to log in", actions: [
                    UIAlertAction(
                        title: Constants.ContinueButton,
                        style: UIAlertActionStyle.Default) {
                            [weak weakSelf = self] (action: UIAlertAction) -> Void in
                            weakSelf?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                    }]
                )
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func updateDBWithNewUser(id: String, password: String,
        firstname: String, lastname: String,
        inManagedObjectContext context: NSManagedObjectContext)
    {
        context.performBlock {
            User.addUser(id, password: password, firstname: firstname,
                lastname: lastname, inManagedObjectContext: context)
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
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userid.delegate = self
        password.delegate = self
        firstname.delegate = self
        lastname.delegate = self
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
