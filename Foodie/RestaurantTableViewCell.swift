//
//  RestaurantTableViewCell.swift
//  Foodie
//
//  Created by Chuiwen Ma on 11/30/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    
    // MARK: Public API
    
    var restaurant: Restaurant? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: UI
    
    @IBOutlet private weak var restaurantNameLabel: UILabel!
    @IBOutlet private weak var restaurantDescriptionLabel: UILabel!
    @IBOutlet private weak var restaurantDistanceLabel: UILabel!
    @IBOutlet private weak var restaurantPriceLabel: UILabel!
    @IBOutlet private weak var restaurantRatingLabel: UILabel!
    @IBOutlet private weak var restaurantNumOfReviewsLabel: UILabel!
    @IBOutlet private weak var restaurantImageView: UIImageView!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func updateUI()
    {
        // TODO: implement this
        if restaurant != nil {
            restaurantNameLabel?.text = restaurant?.name
            restaurantDescriptionLabel?.text = restaurant?.description
            myImage = nil
            fetchImage()
            
        }
    }
    
    var myImage: UIImage? {
        get {
            return restaurantImageView?.image
        }
        set {
            restaurantImageView?.image = newValue
        }
    }
    
    private func fetchImage() {
        if let url = restaurant?.imageURL  {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [ weak weakSelf = self ] in
                if let imageData = NSData(contentsOfURL: url) {
                    dispatch_async(dispatch_get_main_queue()) {
                        weakSelf?.myImage = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
}
