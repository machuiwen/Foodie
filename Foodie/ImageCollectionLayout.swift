//
//  ImageCollectionLayout.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/5/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class ImageCollectionLayout: UICollectionViewLayout {
    // TODO: Modify code here
    
    var delegate: ImageCollectionLayoutDelegate!
    var numberOfColumns = 2
    var cellPadding: CGFloat = 6.0
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var contentHeight: CGFloat  = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset // padding
        return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
    }
    
    override func prepareLayout() {
        if cache.isEmpty && collectionView!.numberOfSections() != 0{
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )
            }
            var column = 0
            var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: 0)
            
            for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
                
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                
                let width = columnWidth - cellPadding * 2
                let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath,
                    withWidth:width)
                
                let height = cellPadding +  photoHeight + cellPadding
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
                
                contentHeight = max(contentHeight, CGRectGetMaxY(frame))
                yOffset[column] = yOffset[column] + height
                
                column = column >= (numberOfColumns - 1) ? 0 : ++column
            }
        }
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}

protocol ImageCollectionLayoutDelegate {
    
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath,
        withWidth:CGFloat) -> CGFloat
    
}
