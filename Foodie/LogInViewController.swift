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
    
    // MARK: - Outlets
    
    @IBOutlet private weak var userid: UITextField!
    @IBOutlet private weak var password: UITextField!
    
    // MARK: - ManagedObjectContext
    
    var managedObjectContext: NSManagedObjectContext? = AppDelegate.managedObjectContext
    private var defaults = Defaults()
    
    // MARK: - Actions
    
    @IBAction private func goBack(sender: UIButton) {
        self.view.endEditing(true)
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction private func logIn(sender: UIButton) {
        if let uid = userid.text, let context = managedObjectContext {
            let users = User.queryUsers(uid, inManagedObjectContext: context)
            if !users.isEmpty {
                let user = users.first!
                if user.password == password.text {
                    clearContents()
                    defaults.logInWithUser(uid)
                    performSegueWithIdentifier(Constants.LogInSuccess, sender: sender)
                } else {
                    password.text = nil
                    showAlert("Wrong password", message: "Try again!")
                }
            } else {
                clearContents()
                showAlert("User not exist", message: "Try again!")
            }
        }
    }
    
    
    // MARK: Private methods
    
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
    
    private func clearContents() {
        userid.text = nil
        password.text = nil
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userid.delegate = self
        password.delegate = self
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
