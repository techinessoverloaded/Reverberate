//
//  DynamicHeightCollectionView.swift
//  Reverberate
//
//  Created by arun-13930 on 19/08/22.
//

import UIKit

class DynamicHeightCollectionView: UICollectionView
{
    override func layoutSubviews()
    {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize
        {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize
    {
        return collectionViewLayout.collectionViewContentSize
    }
}
