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
    
    private lazy var sectionHeaders: [String] = [
        "To get you started",
        "New Releases",
        "Top Charts",
    ]
    
    private var songs: [SongWrapper] = []
    
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
        GlobalConstants.songNames[.tamil]![.melody]!.forEach {
            songs.append(SongMetadataExtractor.extractSongMetadata(songName: $0)!)
        }
    }
    
    private func createSectionLayout(section sectionIndex: Int) -> NSCollectionLayoutSection
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
                cellHeight = tableView.frame.height * 0.3
            }
            else
            {
                cellHeight = tableView.frame.height * 0.6
            }
            let headerHeight: CGFloat = 40
            let margin: CGFloat = 40
            return CGFloat(sectionHeaders.count) * (cellHeight + headerHeight + margin)
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
        return sectionHeaders.count
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
                return headerView.configure(title: sectionHeaders[section], shouldShowSeeAllButton: false)
            }
            return headerView.configure(title: sectionHeaders[section])
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
        let row = indexPath.item
        if section == 0
        {
            if row == 0 || row == 1
            {
                let artists = songs[row].artists!
                var artistNames = ""
                artists.forEach {
                    artistNames.append("\($0.name!), ")
                }
                cell.configureCell(songPoster: songs[row].coverArt!, songTitle: songs[row].title!, artistNames: artistNames)
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
    
}
