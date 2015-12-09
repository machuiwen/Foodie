//
//  ImageCollectionViewController.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/3/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit


class ImageCollectionViewController: UICollectionViewController, ImageCollectionLayoutDelegate {
    
    // MARK: - Public API
    
    var imageURLs = [NSURL]() {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    // MARK: - Private Properties
    
    private let reuseIdentifier = "ImageCell"
    
    // MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionView?.collectionViewLayout as? ImageCollectionLayout {
            layout.delegate = self
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationvc: UIViewController? = segue.destinationViewController
        if let navcon = destinationvc as? UINavigationController {
            destinationvc = navcon.visibleViewController
        }
        if let imagevc = destinationvc as? RestaurantImageViewController {
            if let imageCell = sender as? ImageCollectionViewCell {
                imagevc.image = imageCell.myImage
            }
        }
    }
    
    // MARK: - UICollectionView DataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        if let cell = cell as? ImageCollectionViewCell {
            cell.imageURL = imageURLs[indexPath.row]
            print(cell.imageURL)
        }
        return cell
    }
    
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath,
        withWidth width:CGFloat) -> CGFloat {
            // TODO: Fix the aspect ratio
            return width / 4.0 * 3.0
    }
    
}
