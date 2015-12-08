//
//  UserImageViewController.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/7/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class UserImageViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: Public Model
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }
    
    // MARK: Properties
    
    private var imageView = UIImageView()
    
    // MARK: Outlets
    
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
        }
    }
    
    // MARK: Tap Gesture Recognizer
    
    @IBAction func goBack(sender: UITapGestureRecognizer) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UIScrollViewDelegate
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        // soft limit
        if scale < 1 {
            scrollView.setZoomScale(1, animated: true)
        } else if scale > 2 {
            scrollView.setZoomScale(2, animated: true)
        }
    }
    
    // MARK: ViewController Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateImageSize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        // hard limit
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 3.0
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateImageSize()
    }
    
    // MARK: UI Helper
    
    private func updateImageSize() {
        let imageWidth = min(view.bounds.width, view.bounds.height)
        imageView.frame = CGRect(origin: CGPointZero, size: CGSize(width: imageWidth, height: imageWidth))
        imageView.center = view.center
        scrollView?.contentSize = imageView.frame.size
    }
    
}
