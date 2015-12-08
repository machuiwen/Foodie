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
    
    // MARK: - Outlets
    
    @IBOutlet private weak var webView: UIWebView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        webView?.scalesPageToFit = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadAddressUrl(urlPath)
    }
    
    // MARK: - Private Methods
    
    private func loadAddressUrl(url: String?) {
        if let url = url {
            if let requestUrl = NSURL(string: url) {
                print("You are requesting url: \(requestUrl)")
                webView?.loadRequest(NSURLRequest(URL: requestUrl))
            }
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if var searchText = searchBar.text {
            if !searchText.hasPrefix("http") {
                searchText = searchText.stringByReplacingOccurrencesOfString(" ", withString: "+")
                searchText = Constants.GoogleSearchRequestPrefix + searchText
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
    
}
