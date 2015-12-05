//
//  ImageViewController.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/3/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: Public Model
    
    var imageURL: NSURL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
        }
    }
    
    // MARK: Private Implementation
    
    private func fetchImage() {
        if let url = imageURL {
            spinner?.startAnimating()
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [ weak weakSelf = self ] in
                if let imageData = NSData(contentsOfURL: url) {
                    if url == weakSelf?.imageURL {
                        dispatch_async(dispatch_get_main_queue()) {
                            weakSelf?.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
    
    private var imageView = UIImageView()
    
    // MARK: UIScrollViewDelegate
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        userExplicitZoom = true
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        scrollView.minimumZoomScale = 0.04
        scrollView.maximumZoomScale = 4.0
        updateZoomScale()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateZoomScale()
    }
    
    // MARK: UI Helper
    
    private var userExplicitZoom = false
    private func updateZoomScale() {
        if userExplicitZoom == false {
            let scrollViewSize = scrollView.bounds.size
            let imageViewSize = imageView.bounds.size
            if scrollViewSize.width != 0 && imageViewSize.width != 0 {
                let zoomScale = max(scrollViewSize.height / imageViewSize.height, scrollViewSize.width / imageViewSize.width)
                scrollView.minimumZoomScale = min(0.04, zoomScale)
                scrollView.maximumZoomScale = max(4, zoomScale)
                scrollView.setZoomScale(zoomScale, animated: false)
                userExplicitZoom = false
            }
        }
    }
    //
    //    // MARK: Navigation
    //
    //    @IBAction private func goBackToRootView(sender: UIBarButtonItem) {
    //        self.navigationController?.popToRootViewControllerAnimated(true)
    //    }
    
}
