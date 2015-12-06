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
    
    @IBAction func goBack(sender: AnyObject) {
        // hide keyboard
        if userid.isFirstResponder() {
            userid.resignFirstResponder()
        } else if password.isFirstResponder() {
            password.resignFirstResponder()
        } else if firstname.isFirstResponder() {
            firstname.resignFirstResponder()
        } else if lastname.isFirstResponder() {
            lastname.resignFirstResponder()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signUp(sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userid.delegate = self
        password.delegate = self
        firstname.delegate = self
        lastname.delegate = self
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
