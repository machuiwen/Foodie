//
//  WebViewController.swift
//  Smashtag
//
//  Created by Chuiwen Ma on 10/28/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - Public API
    
    var urlPath: String? {
        didSet {
            loadAddressUrl(urlPath)
        }
    }
    
    // MARK: - Outlet
    
    @IBOutlet private weak var webView: UIWebView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        webView?.scalesPageToFit = true
        loadAddressUrl(urlPath)
    }
    
    // MARK: - Core Function
    
    private func loadAddressUrl(url: String?) {
        if let url = url {
            if let requestUrl = NSURL(string: url) {
                print("You are requesting \(requestUrl)")
                webView?.loadRequest(NSURLRequest(URL: requestUrl))
            }
        }
    }
    
    // MARK: - UISearchBarDelegate Methods
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if var searchText = searchBar.text {
            if !searchText.hasPrefix("http") {
                searchText = searchText.stringByReplacingOccurrencesOfString(" ", withString: "+")
                searchText = "https://www.google.com/search?q=" + searchText
            }
            loadAddressUrl(searchText)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        // Show cancel button
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        // Hide cancel button
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    //    // MARK: - Navigation
    //
    //    @IBAction private func goBackToRootView(sender: UIBarButtonItem) {
    //        self.navigationController?.popToRootViewControllerAnimated(true)
    //    }
    
}
