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
        let cView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {
            sectionIndex , _ -> NSCollectionLayoutSection? in
            self.createSectionLayout(section: sectionIndex)
        }))
        return cView
    }()
    
    private lazy var songs : [Category : [Song]] = {
        var result: [Category: [Song]] = [:]
        Category.allCases.forEach
        {
            result[$0] = DataProcessor.shared.getSongsOf(category: $0, andLimitNumberOfResultsTo: 10)
        }
        return result
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.register(PosterDetailCVCell.self, forCellWithReuseIdentifier: PosterDetailCVCell.identifier)
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
        section.interGroupSpacing = 15
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem.init(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60)), elementKind: UICollectionView.elementKindSectionHeader, alignment: NSRectAlignment.top)]
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
            let headerHeight: CGFloat = 60
            let margin: CGFloat = 0
            return CGFloat(songs.count) * (cellHeight + headerHeight + margin)
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
        return songs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return songs[Category(rawValue: section)!]!.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
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
}

extension HomeViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = indexPath.section
        let item = indexPath.item
        let category = Category(rawValue: section)!
        let categoricalSongs = songs[category]!
        if GlobalVariables.shared.currentSong != categoricalSongs[item]
        {
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
