//
//  LandingPageViewController.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/7/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private var defaults = Defaults()
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.initializeApp()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if defaults.loggedIn == true {
            performSegueWithIdentifier(Constants.EnterAppSegue, sender: self)
        }
    }
    
}
