//
//  HomeVCCompositionalLayout.swift
//  Reverberate
//
//  Created by arun-13930 on 21/07/22.
//

import UIKit

class HomeVCCompositionalLayout: UICollectionViewCompositionalLayout
{
    private static var isInPortraitMode: Bool
    {
        get
        {
            return UIDevice.current.orientation.isPortrait ? true : (UIDevice.current.orientation == .unknown ? true : false)
        }
    }
    
    private static var sectionProvider: UICollectionViewCompositionalLayoutSectionProvider = {
        sectionIndex , _ -> NSCollectionLayoutSection? in
        HomeVCCompositionalLayout.createSectionLayout(section: sectionIndex)
    }
    
    convenience init?(useInternalSectionProvider: Bool)
    {
        if useInternalSectionProvider
        {
            self.init(sectionProvider: HomeVCCompositionalLayout.sectionProvider)
        }
        else
        {
            return nil
        }
        
    }
    
    private static func createSectionLayout(section sectionIndex: Int) -> NSCollectionLayoutSection
    {
        //Item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 3), heightDimension: .fractionalHeight(1)))
        
        //Group
        let groupSize: NSCollectionLayoutSize!
        let group: NSCollectionLayoutGroup!
        if isInPortraitMode
        {
//            groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.3), heightDimension: .fractionalHeight(0.3))
//            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
            
            groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.2), heightDimension: .fractionalHeight(0.2))
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        }
        else
        {
            groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.2), heightDimension: .fractionalHeight(0.3))
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 4)
        }
        
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(15)
        
        //Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem.init(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), elementKind: UICollectionView.elementKindSectionHeader, alignment: NSRectAlignment.top)]
        
        return section
    }
}
