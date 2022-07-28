//
//  SearchResultsViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 19/07/22.
//

import UIKit

class SearchResultsViewController: UITableViewController
{
    private lazy var initialMessage: NSAttributedString = {
        let largeTextAttributes: [NSAttributedString.Key : Any] =
        [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 19, weight: .bold),
            NSAttributedString.Key.foregroundColor : UIColor.label
        ]
        let smallerTextAttributes: [NSAttributedString.Key : Any] =
        [
            NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .body),
            NSAttributedString.Key.foregroundColor : UIColor.secondaryLabel
        ]
        var mutableAttrString = NSMutableAttributedString(string: "Play what you love\n\n", attributes: largeTextAttributes)
        mutableAttrString.append(NSMutableAttributedString(string: "Search for Artists, Songs or Albums.", attributes: smallerTextAttributes))
        return mutableAttrString
    }()
    
    private lazy var noResultsMessage: NSAttributedString = {
        let largeTextAttributes: [NSAttributedString.Key : Any] =
        [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 19, weight: .bold),
            NSAttributedString.Key.foregroundColor : UIColor.label
        ]
        let smallerTextAttributes: [NSAttributedString.Key : Any] =
        [
            NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .body),
            NSAttributedString.Key.foregroundColor : UIColor.secondaryLabel
        ]
        var mutableAttrString = NSMutableAttributedString(string: "Couldn't find any result\n\n", attributes: largeTextAttributes)
        mutableAttrString.append(NSMutableAttributedString(string: "Try searching again using a different spelling or keyword.", attributes: smallerTextAttributes))
        return mutableAttrString
    }()
    
    private lazy var emptyMessageLabel: UILabel = {
        let emLabel = UILabel(useAutoLayout: true)
        emLabel.textAlignment = .center
        emLabel.numberOfLines = 4
        return emLabel
    }()
    
    private lazy var backgroundView: UIVisualEffectView = {
        let bView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        return bView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return cView
    }()
    
    private var searchMode: Int = 0
    
    private lazy var filteredSongs: [SongWrapper] = []
    
    private lazy var filteredAlbums: [AlbumWrapper] = []
    
    private lazy var filteredArtists: [ArtistWrapper] = []
    
    override func loadView()
    {
        super.loadView()
        backgroundView.contentView.addSubview(emptyMessageLabel)
        NSLayoutConstraint.activate([
            emptyMessageLabel.centerXAnchor.constraint(equalTo: backgroundView.contentView.centerXAnchor),
            emptyMessageLabel.centerYAnchor.constraint(equalTo: backgroundView.contentView.centerYAnchor),
            emptyMessageLabel.widthAnchor.constraint(equalTo: backgroundView.contentView.widthAnchor, multiplier: 0.8)
        ])
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        emptyMessageLabel.attributedText = initialMessage
        view.backgroundColor = .clear
        tableView.backgroundColor = .clear
        tableView.backgroundView = backgroundView
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        collectionView.register(SongCVCell.self, forCellWithReuseIdentifier: SongCVCell.identifier)
        collectionView.register(HeaderCVReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCVReusableView.identifier)
        tableView.separatorStyle = .none
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate {
            [unowned self] _ in
            self.tableView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    func reloadViews()
    {
        collectionView.reloadData()
        tableView.reloadData()
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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var cellHeight: CGFloat = .zero
        let margin: CGFloat = 30
        if searchMode == -1
        {
            return cellHeight
        }
        else
        {
            if isInPortraitMode
            {
                cellHeight = ((tableView.frame.width / 2.4) - 1)
            }
            else
            {
                cellHeight = ((tableView.frame.width / 2.4) - 1)
            }
            if searchMode == 0
            {
                return CGFloat(filteredSongs.count) * (cellHeight + margin) + 25
            }
            else if searchMode == 1
            {
                return CGFloat(filteredAlbums.count) * (cellHeight + margin) + 25
            }
            else if searchMode == 2
            {
                return CGFloat(filteredArtists.count) * (cellHeight + margin) + 25
            }
            else
            {
                return .zero
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        cell.addSubViewToContentView(collectionView)
        return cell
    }
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        if searchMode == -1
        {
            return 0
        }
        else
        {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if searchMode == 0
        {
            return filteredSongs.count
        }
        else if searchMode == 1
        {
            return filteredAlbums.count
        }
        else if searchMode == 2
        {
            return filteredArtists.count
        }
        else
        {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SongCVCell.identifier, for: indexPath) as! SongCVCell
        let item = indexPath.item
        if searchMode == 0
        {
            let song = filteredSongs[item]
            cell.configureCell(songPoster: song.coverArt!, songTitle: song.title!, artistNames: song.getArtistNamesAsString(artistType: nil))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let item = indexPath.item
        if searchMode == 0
        {
            if GlobalVariables.shared.currentSong != filteredSongs[item]
            {
                GlobalVariables.shared.currentSong = filteredSongs[item]
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if isInPortraitMode
        {
            let cellWidth = (tableView.bounds.width / 2.4) - 1
            return .init(width: cellWidth, height: cellWidth)
        }
        else
        {
            let cellWidth = (tableView.bounds.width / 2.4) - 1
            return .init(width: cellWidth, height: cellWidth)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return .init(top: 10, left: 20, bottom: 20, right: 20)
    }
}

extension SearchResultsViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        guard let query = searchController.searchBar.text else
        {
            filteredSongs = []
            reloadViews()
            emptyMessageLabel.isHidden = false
            emptyMessageLabel.attributedText = initialMessage
            return
        }
        if !query.isEmpty
        {
            if searchMode == 0
            {
                let result = DataProcessor.shared.getSongsThatSatisfy(theQuery: query)
                if let result = result {
                    if result.isEmpty
                    {
                        filteredSongs = []
                        reloadViews()
                        emptyMessageLabel.isHidden = false
                        emptyMessageLabel.attributedText = noResultsMessage
                    }
                    else
                    {
                        filteredSongs = result
                        print("\(filteredSongs.count) songs were filtered")
                        reloadViews()
                        emptyMessageLabel.isHidden = true
                    }
                }
                else
                {
                    filteredSongs = []
                    reloadViews()
                    emptyMessageLabel.isHidden = false
                    emptyMessageLabel.attributedText = noResultsMessage
                }
            }
        }
        else
        {
            filteredSongs = []
            reloadViews()
            emptyMessageLabel.isHidden = false
            emptyMessageLabel.attributedText = initialMessage
        }
        print(query)
    }
}

extension SearchResultsViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int)
    {
        self.searchMode = selectedScope
    }
}
