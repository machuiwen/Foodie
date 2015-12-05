//
//  ImageCollectionViewCell.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/3/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: Public API
    
    var imageURL: NSURL? {
        didSet {
            myImageView?.image = nil
            fetchImage()
        }
    }
    
    var myImage: UIImage? {
        get {
            return myImageView?.image
        }
        set {
            myImageView?.image = newValue
        }
    }
    
    // MARK: UI
    
    @IBOutlet private weak var myImageView: UIImageView!
    
    private func fetchImage() {
        if let url = imageURL {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [ weak weakSelf = self ] in
                if let imageData = NSData(contentsOfURL: url) {
                    if url == weakSelf?.imageURL {
                        dispatch_async(dispatch_get_main_queue()) {
                            weakSelf?.myImageView?.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
    
}
