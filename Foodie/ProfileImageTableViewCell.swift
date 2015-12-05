//
//  ProfileImageTableViewCell.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/02/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class ProfileImageTableViewCell: UITableViewCell {
    
    // MARK: Public API
    
    var restaurant: Restaurant? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: UI
    @IBOutlet private weak var restaurantNameLabel: UILabel!
    @IBOutlet private weak var restaurantTypeLabel: UILabel!
    @IBOutlet weak var restaurantDescriptionLabel: UILabel!
    @IBOutlet private weak var myImageView: UIImageView!
    
    private func resetUI() {
        restaurantNameLabel.text = nil
        restaurantTypeLabel.text = nil
        restaurantDescriptionLabel.text = nil
        myImageView.image = nil
    }
    
    private func updateUI() {
        resetUI()
        if let r = restaurant {
            restaurantNameLabel.text = r.name
            restaurantTypeLabel.text = r.type
            restaurantDescriptionLabel.text = r.description
            fetchImage()
        }
    }
    
    private func fetchImage() {
        if let url = restaurant?.imageURL {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [ weak weakSelf = self ] in
                if let imageData = NSData(contentsOfURL: url) {
                    if url == weakSelf?.restaurant?.imageURL {
                        dispatch_async(dispatch_get_main_queue()) {
                            weakSelf?.myImageView.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
    
}
