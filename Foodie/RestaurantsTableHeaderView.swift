//
//  RestaurantsTableHeaderView.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/8/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class RestaurantsTableHeaderView: UIView, UIScrollViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet { scrollView.delegate = self }
    }
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Private Properties
    
    private var viewSize: CGSize = CGSize(width: 375, height: 185)
    
    // MARK: - UIScrollViewDelegate
    
    // http://sweettutos.com/2015/04/13/how-to-make-a-horizontal-paging-uiscrollview-with-auto-layout-in-storyboards-swift/
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let w = viewSize.width
        let currentPage: CGFloat = floor((scrollView.contentOffset.x - w / 2) / w) + 1
        pageControl.currentPage = Int(currentPage)
    }
    
    // MARK: - View Initializer
    
    override func awakeFromNib() {
        scrollView.frame = CGRect(origin: CGPointZero, size: viewSize)
        scrollView.addImage(named: "apples", index: 0, size: viewSize)
        scrollView.addImage(named: "orange", index: 1, size: viewSize)
        scrollView.addImage(named: "banana", index: 2, size: viewSize)
        scrollView.addImage(named: "christmas", index: 3, size: viewSize)
        scrollView.contentSize = CGSize(width: viewSize.width * CGFloat(pageControl.numberOfPages), height: viewSize.height)
        pageControl.currentPage = 0
    }
    
}

extension UIScrollView {
    func addImage(named name: String, index: CGFloat, size: CGSize) {
        let imageView = UIImageView(frame: CGRect(x: index * size.width, y: 0, width: size.width, height: size.height))
        imageView.image = UIImage(named: name)
        self.addSubview(imageView)
    }
}
