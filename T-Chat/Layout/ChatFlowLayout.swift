//
//  ChatFlowLayout.swift
//  T-Chat
//
//  Created by Pavel Ivanov on 08.11.2019.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import UIKit

class ChatFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        guard let collectionView = collectionView else { return }
        estimatedItemSize = CGSize(width: collectionView.frame.width, height: 0)
        scrollDirection = .vertical
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArray = [UICollectionViewLayoutAttributes]()
        guard let collectionView = collectionView else { return attributesArray }
        
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                guard let layoutAttributes = layoutAttributesForItem(at: indexPath) else { return attributesArray }
                
                if layoutAttributes.frame.intersects(rect) {
                    //rotate layout on 180
                    layoutAttributes.transform = CGAffineTransform(scaleX: 1, y: -1)
                    attributesArray.append(layoutAttributes)
                }
            }
        }

        return attributesArray
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { fatalError() }
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }

        layoutAttributes.frame.origin.x = sectionInset.left
        layoutAttributes.frame.size.width = collectionView.safeAreaLayoutGuide.layoutFrame.width - sectionInset.left - sectionInset.right
        
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if let oldBounds = self.collectionView?.bounds,
            oldBounds.width != newBounds.width || oldBounds.height != newBounds.height {
            return true
        }

        return false
    }
}
