//
//  SongArtistsViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 25/07/22.
//

import UIKit

class SongArtistsViewController: UITableViewController
{
    private lazy var backgroundView: UIVisualEffectView = {
        let bView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        return bView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        let cView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {
            sectionIndex , _ -> NSCollectionLayoutSection? in
            self.createSectionLayout(section: sectionIndex)
        }))
        return cView
    }()
    
    private lazy var artists: [ArtistType : [Artist]] = {
        let song = GlobalVariables.shared.currentSong!
        var result: [ArtistType : [Artist]] = [:]
        for type in ArtistType.allCases
        {
            result[type] = song.getArtists(ofType: type)
        }
        return result
    }()
    
    weak var delegate: SongArtistsViewDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(onCloseButtonTap(_:)))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Contributing Artists"
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.label.withAlphaComponent(0.8),
            NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        ]
        view.backgroundColor = .clear
        tableView.backgroundColor = .clear
        tableView.backgroundView = backgroundView
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.register(ArtistCVCell.self, forCellWithReuseIdentifier: ArtistCVCell.identifier)
        collectionView.register(HeaderCVReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCVReusableView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
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
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.2), heightDimension: .absolute(290))
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
            }
            else
            {
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.2), heightDimension: .absolute(200))
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
            }
        }
        else
        {
            if isIpad
            {
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.3), heightDimension: .absolute(330))
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
            }
            else
            {
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.3), heightDimension: .absolute(270))
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
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        cell.addSubViewToContentView(collectionView)
        return cell
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
                    cellHeight = 290
                }
                else
                {
                    cellHeight = 200
                }
            }
            else
            {
                if isIpad
                {
                    cellHeight = 330
                }
                else
                {
                    cellHeight = 270
                }
            }
            let headerHeight: CGFloat = 40
            let margin: CGFloat = 40
            return CGFloat(artists.count) * (cellHeight + headerHeight + margin)
        }
        else
        {
            return .zero
        }
    }
}

extension SongArtistsViewController: UICollectionViewDataSource, UICollectionViewDelegate
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        let sectionAsInt16 = Int16(section)
        return artists[ArtistType(rawValue: sectionAsInt16)!]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if kind == UICollectionView.elementKindSectionHeader
        {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCVReusableView.identifier, for: indexPath) as! HeaderCVReusableView
            let section = Int16(indexPath.section)
            headerView.configure(title: ArtistType(rawValue: section)!.description, shouldShowSeeAllButton: false, headerFontColorOpacity: 0.8)
            return headerView
        }
        else
        {
            fatalError("No footers were registered")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistCVCell.identifier, for: indexPath) as! ArtistCVCell
        let section = Int16(indexPath.section)
        let item = indexPath.item
        let artist = artists[ArtistType(rawValue: section)!]![item]
        let artistName = artist.name!
        let artistPhoto = artist.photo
        cell.configureCell(artistPicture: artistPhoto, artistName: artistName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let section = Int16(indexPath.section)
        let item = indexPath.item
        let artist = artists[ArtistType(rawValue: section)!]![item]
        self.dismiss(animated: true)
        delegate?.onArtistDetailViewRequest(artist: artist)
    }
}

extension SongArtistsViewController
{
    @objc func onCloseButtonTap(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true)
    }
}
