//
//  HomeViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//
import UIKit

class HomeViewController: UITableViewController
{
    private lazy var collectionView: UICollectionView = {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        let cView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {
            sectionIndex , _ -> NSCollectionLayoutSection? in
            self.createSectionLayout(section: sectionIndex)
        }))
        return cView
    }()
    
    private lazy var categories: [Category] = {
//        return Category.allCases
        return [.starter, .newReleases, .topCharts, .tamil, .melody]
    }()
    
    private var songs = DataManager.shared.availableSongs
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        collectionView.register(SongCVCell.self, forCellWithReuseIdentifier: SongCVCell.identifier)
        collectionView.register(HeaderCVReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCVReusableView.identifier)
        tableView.separatorStyle = .none
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
    }
    
    private func createSectionLayout(section sectionIndex: Int) -> NSCollectionLayoutSection
    {
        //Item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        //Group
        let groupSize: NSCollectionLayoutSize!
        let group: NSCollectionLayoutGroup!
        if isInPortraitMode
        {
            if isIpad
            {
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.35), heightDimension: .absolute(420))
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
            }
            else
            {
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.3), heightDimension: .absolute(220))
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
            }
        }
        else
        {
            if isIpad
            {
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.7), heightDimension: .absolute(520))
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
            }
            else
            {
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.7), heightDimension: .absolute(380))
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
            }
        }
        
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(15)
        
        //Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem.init(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), elementKind: UICollectionView.elementKindSectionHeader, alignment: NSRectAlignment.top)]
        return section
    }
    
    
    // MARK: - Table view data source and delegate
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            var cellHeight: CGFloat = 0
            if isInPortraitMode
            {
                if isIpad
                {
                    cellHeight = 420
                }
                else
                {
                    cellHeight = 220
                }
            }
            else
            {
                if isIpad
                {
                    cellHeight = 520
                }
                else
                {
                    cellHeight = 380
                }
            }
            let headerHeight: CGFloat = 40
            let margin: CGFloat = 40
            return CGFloat(categories.count) * (cellHeight + headerHeight + margin)
        }
        else
        {
            return .zero
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        cell.addSubViewToContentView(collectionView)
        return cell
    }
}

extension HomeViewController: UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if kind == UICollectionView.elementKindSectionHeader
        {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCVReusableView.identifier, for: indexPath) as! HeaderCVReusableView
            let section = indexPath.section
            if section == 0
            {
                return headerView.configure(title: categories[section].rawValue, shouldShowSeeAllButton: false)
            }
            return headerView.configure(title: categories[section].rawValue)
        }
        else
        {
            fatalError("No footers were registered")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SongCVCell.identifier, for: indexPath) as! SongCVCell
        let section = indexPath.section
        let item = indexPath.item
        if section == 0
        {
            if (0...2).contains(item)
            {
                let artistNames = songs[item].getArtistNamesAsString(artistType: nil)
                cell.configureCell(songPoster: songs[item].coverArt!, songTitle: songs[item].title!, artistNames: artistNames)
            }
            else
            {
                cell.configureCell(songTitle: "Song \(indexPath.item)", artistNames: "Artist 1, Artist 2, Artist 3, Artist 4")
            }
        }
        else if section == 1
        {
            if (0...2).contains(item)
            {
                let artistNames = songs[item+3].getArtistNamesAsString(artistType: nil)
                cell.configureCell(songPoster: songs[item+3].coverArt!, songTitle: songs[item+3].title!, artistNames: artistNames)
            }
            else
            {
                cell.configureCell(songTitle: "Song \(indexPath.item)", artistNames: "Artist 1, Artist 2, Artist 3, Artist 4")
            }
        }
        else
        {
            cell.configureCell(songTitle: "Song \(indexPath.item)", artistNames: "Artist 1, Artist 2, Artist 3, Artist 4")
        }
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = indexPath.section
        let item = indexPath.item
        if section == 0
        {
            if (0...2).contains(item)
            {
                GlobalVariables.shared.currentSong = songs[item]
            }
        }
        else if section == 1
        {
            if (0...2).contains(item)
            {
                GlobalVariables.shared.currentSong = songs[item+3]
            }
        }
    }
}
