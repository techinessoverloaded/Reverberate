//
//  HomeViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//
import UIKit
import MediaPlayer

class HomeViewController: UICollectionViewController
{
    static var compositionalLayout: UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout(sectionProvider: {
        sectionIndex , _ -> NSCollectionLayoutSection? in
        createSectionLayout(section: sectionIndex)
    })
    
    private lazy var songs : [Category : [Song]] = {
        var result: [Category: [Song]] = [:]
        Category.allCases.forEach
        {
            result[$0] = DataProcessor.shared.getSongsOf(category: $0, andLimitNumberOfResultsTo: 10)
        }
        return result
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(view.bounds.width)
        print(collectionView.bounds.width)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        collectionView.register(PosterDetailCVCell.self, forCellWithReuseIdentifier: PosterDetailCVCell.identifier)
        collectionView.register(HeaderCVReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCVReusableView.identifier)
        collectionView.backgroundColor = .clear
        collectionView.bounces = true
//        collectionView.alwaysBounceHorizontal = true
    }
    
    static func createSectionLayout(section sectionIndex: Int) -> NSCollectionLayoutSection
    {
        //Item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        //Group
        let groupSize: NSCollectionLayoutSize!
        let group: NSCollectionLayoutGroup!
        groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.3), heightDimension: .absolute(220))
        group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(15)
        
        //Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem.init(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60)), elementKind: UICollectionView.elementKindSectionHeader, alignment: NSRectAlignment.top)]
        return section
    }
}

extension HomeViewController
{
    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return songs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return songs[Category(rawValue: section)!]!.count
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if kind == UICollectionView.elementKindSectionHeader
        {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCVReusableView.identifier, for: indexPath) as! HeaderCVReusableView
            let section = indexPath.section
            let category = Category(rawValue: section)!
            headerView.configure(title: category.description, tagForSeeAllButton: indexPath.section)
            headerView.addTargetToSeeAllButton(target: self, action: #selector(onSeeAllButtonTap(_:)))
            return headerView
        }
        else
        {
            fatalError("No footers were registered")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterDetailCVCell.identifier, for: indexPath) as! PosterDetailCVCell
        let section = indexPath.section
        let item = indexPath.item
        let category = Category(rawValue: section)!
        let categoricalSongs = songs[category]!
        let artistNames = categoricalSongs[item].getArtistNamesAsString(artistType: nil)
        cell.configureCell(poster: categoricalSongs[item].coverArt!, title: categoricalSongs[item].title!, subtitle: artistNames)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = indexPath.section
        let item = indexPath.item
        let category = Category(rawValue: section)!
        let categoricalSongs = songs[category]!
        if GlobalVariables.shared.currentSong != categoricalSongs[item]
        {
            print(categoricalSongs[item])
            GlobalVariables.shared.currentSong = categoricalSongs[item]
        }
    }
}

extension HomeViewController
{
    @objc func onSeeAllButtonTap(_ sender: UIButton)
    {
        let categoricalVC = CategoricalSongsViewController(style: .grouped)
        categoricalVC.category = Category(rawValue: sender.tag)
        navigationController?.pushViewController(categoricalVC, animated: true)
    }
}
