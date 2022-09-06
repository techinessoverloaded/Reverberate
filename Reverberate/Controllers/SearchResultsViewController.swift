//
//  SearchResultsViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 19/07/22.
//
import UIKit

class SearchResultsViewController: UICollectionViewController
{
    private lazy var heartIcon: UIImage = {
        return UIImage(systemName: "heart")!
    }()
    
    private lazy var heartFilledIcon: UIImage = {
        return UIImage(systemName: "heart.fill")!
    }()
    
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
        mutableAttrString.append(NSMutableAttributedString(string: "Search for Songs, Albums or Artists.", attributes: smallerTextAttributes))
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
    
    private var searchMode: Int = 0
    
    private lazy var filteredSongs: [Song] = []
    
    private lazy var filteredAlbums: [Album] = []
    
    private lazy var filteredArtists: [Artist] = []
    
    weak var delegate: SearchResultDelegate?
    
    weak var searchBarRef: UISearchBar?
    
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
        collectionView.backgroundColor = .clear
        collectionView.backgroundView = backgroundView
        collectionView.keyboardDismissMode = .onDrag
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 75, right: 20)
        collectionView.register(PosterDetailCVCell.self, forCellWithReuseIdentifier: PosterDetailCVCell.identifier)
        collectionView.register(ArtistCVCell.self, forCellWithReuseIdentifier: ArtistCVCell.identifier)
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "cell")
    }
}

extension SearchResultsViewController: UICollectionViewDelegateFlowLayout
{
    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if searchMode == 0
        {
            return filteredSongs.count
        }
        else if searchMode == 1
        {
            return filteredAlbums.count
        }
        else
        {
            return filteredArtists.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let item = indexPath.item
        if searchMode == 0
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UICollectionViewListCell
            var config = UIListContentConfiguration.subtitleCell()
            let item = indexPath.item
            let song = filteredSongs[item]
            config.text = song.title!
            config.secondaryText = song.getArtistNamesAsString(artistType: nil)
            config.imageProperties.cornerRadius = 10
            config.image = song.coverArt
            config.textProperties.adjustsFontForContentSizeCategory = true
            config.textProperties.allowsDefaultTighteningForTruncation = true
            config.secondaryTextProperties.adjustsFontForContentSizeCategory = true
            config.secondaryTextProperties.color = .secondaryLabel
            config.secondaryTextProperties.allowsDefaultTighteningForTruncation = true
            config.secondaryTextProperties.font = .preferredFont(forTextStyle: .footnote)
            cell.contentConfiguration = config
            cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
            var menuButtonConfig = UIButton.Configuration.plain()
            menuButtonConfig.baseForegroundColor = .systemGray
            menuButtonConfig.image = UIImage(systemName: "ellipsis")!
            menuButtonConfig.buttonSize = .medium
            let menuButton = UIButton(configuration: menuButtonConfig)
            menuButton.tag = item
            menuButton.sizeToFit()
            let songFavMenuItem = UIAction(title: "Add Song to Favourites", image: heartIcon) { [unowned self] menuItem in
                onSongFavouriteMenuItemTap(menuItem: menuItem, tag: item)
            }
            let addToPlaylistMenuItem = UIAction(title: "Add Song to Playlist", image: UIImage(systemName: "text.badge.plus")!) { [unowned self] menuItem in
                onSongAddToPlaylistMenuItemTap(menuItem: menuItem, tag: item)
            }
            let showAlbumMenuItem = UIAction(title: "Show Album", image: UIImage(systemName: "music.note.list")) { [unowned self] menuItem in
                onShowAlbumMenuItemTap(tag: item)
            }
            let songMenu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [songFavMenuItem, addToPlaylistMenuItem, showAlbumMenuItem])
            menuButton.menu = songMenu
            menuButton.showsMenuAsPrimaryAction = true
            cell.accessories = [UICellAccessory.customView(configuration: .init(customView: menuButton, placement: .trailing(displayed: .always, at: { accessories in
                return 0
            })))]
            return cell
        }
        else if searchMode == 1
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterDetailCVCell.identifier, for: indexPath) as! PosterDetailCVCell
            let album = filteredAlbums[item]
            cell.configureCell(poster: album.coverArt!, title: album.name!, subtitle: album.songs![0].getArtistNamesAsString(artistType: .musicDirector))
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistCVCell.identifier, for: indexPath) as! ArtistCVCell
            let artist = filteredArtists[item]
            cell.configureCell(artistPicture: artist.photo!, artistName: artist.name!)
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let item = indexPath.item
        if searchMode == 1
        {
            delegate?.onAlbumSelection(selectedAlbum: filteredAlbums[item])
        }
        else if searchMode == 2
        {
            delegate?.onArtistSelection(selectedArtist: filteredArtists[item])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if searchMode == 0
        {
            let cellWidth = collectionView.bounds.width
            return CGSize(width: cellWidth, height: 70)
        }
        else
        {
            let cellWidth = (collectionView.bounds.width / 2.4) - 1
            return searchMode == 1 ? .init(width: cellWidth, height: cellWidth * 1.3) : .init(width: cellWidth, height: cellWidth * 1.35)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        if searchMode == 0
        {
            return .init(top: 0, left: 10, bottom: 0, right: 10)
        }
        else
        {
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return searchMode == 2 ? 20 : 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
    {
        let item = indexPath.item
        if searchMode == 0
        {
            let config = UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil , actionProvider: { [unowned self] _ in
                let user = GlobalVariables.shared.currentUser!
                let songFavMenuItem = UIAction(title: "Add Song to Favourites", image: heartIcon) { [unowned self] menuItem in
                    onSongFavouriteMenuItemTap(menuItem: menuItem, tag: item)
                }
                let addToPlaylistMenuItem = UIAction(title: "Add Song to Playlist", image: UIImage(systemName: "text.badge.plus")!) { [unowned self] menuItem in
                    onSongAddToPlaylistMenuItemTap(menuItem: menuItem, tag: item)
                }
                let showAlbumMenuItem = UIAction(title: "Show Album", image: UIImage(systemName: "music.note.list")) { [unowned self] menuItem in
                    onShowAlbumMenuItemTap(tag: item)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [songFavMenuItem, addToPlaylistMenuItem, showAlbumMenuItem])
            })
            return config
        }
        else if searchMode == 1
        {
            let config = UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil , actionProvider: { [unowned self] _ in
                let addAlbumToFavAction = UIAction(title: "Add Album to Favourites", image: heartIcon) { [unowned self] menuItem in
                    onAlbumFavouriteMenuItemTap(menuItem: menuItem, tag: item)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [addAlbumToFavAction])
            })
            return config
        }
        else
        {
            let config = UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil , actionProvider: { [unowned self] _ in
                let addArtistToFavAction = UIAction(title: "Add Artist to Favourites", image: heartIcon) { _ in //[unowned self] menuItem in
                    //onArtistFavouriteMenuItemTap(menuItem: menuItem, tag: item)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [addArtistToFavAction])
            })
            return config
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?
    {
        let indexPath = configuration.identifier as! IndexPath
        let cell = collectionView.cellForItem(at: indexPath)!
        let previewParameters = UIPreviewParameters()
        previewParameters.backgroundColor = .clear
        return UITargetedPreview(view: cell.contentView, parameters: previewParameters)
    }
    
    override func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?
    {
        let indexPath = configuration.identifier as! IndexPath
        let cell = collectionView.cellForItem(at: indexPath)!
        let previewParamters = UIPreviewParameters()
        previewParamters.backgroundColor = .clear
        return UITargetedPreview(view: cell.contentView, parameters: previewParamters)
    }
}

extension SearchResultsViewController: UISearchResultsUpdating
{
    func updateSearchResults(forQuery query: String?)
    {
        guard let query = query else
        {
            filteredSongs = []
            filteredArtists = []
            filteredAlbums = []
            collectionView.reloadData()
            emptyMessageLabel.isHidden = false
            emptyMessageLabel.attributedText = initialMessage
            return
        }
        if !query.isEmpty
        {
            if searchMode == 0
            {
                let result = DataProcessor.shared.getSongsThatSatisfy(theQuery: query.lowercased())
                if let result = result {
                    if result.isEmpty
                    {
                        filteredSongs = []
                        emptyMessageLabel.isHidden = false
                        emptyMessageLabel.attributedText = noResultsMessage
                    }
                    else
                    {
                        filteredSongs = result
                        print("\(filteredSongs.count) songs were filtered")
                        collectionView.reloadData()
                        emptyMessageLabel.isHidden = true
                    }
                }
                else
                {
                    filteredSongs = []
                    collectionView.reloadData()
                    emptyMessageLabel.isHidden = false
                    emptyMessageLabel.attributedText = noResultsMessage
                }
            }
            else if searchMode == 1
            {
                let result = DataProcessor.shared.getAlbumsThatSatisfy(theQuery: query.lowercased())
                if let result = result
                {
                    if result.isEmpty
                    {
                        filteredAlbums = []
                        collectionView.reloadData()
                        emptyMessageLabel.isHidden = false
                        emptyMessageLabel.attributedText = noResultsMessage
                    }
                    else
                    {
                        filteredAlbums = result
                        print("\(filteredAlbums.count) albums were filtered")
                        collectionView.reloadData()
                        emptyMessageLabel.isHidden = true
                    }
                }
                else
                {
                    filteredAlbums = []
                    collectionView.reloadData()
                    emptyMessageLabel.isHidden = false
                    emptyMessageLabel.attributedText = noResultsMessage
                }
            }
            else
            {
                let result = DataProcessor.shared.getArtistsThatSatisfy(theQuery: query.lowercased())
                if let result = result
                {
                    if result.isEmpty
                    {
                        filteredArtists = []
                        collectionView.reloadData()
                        emptyMessageLabel.isHidden = false
                        emptyMessageLabel.attributedText = noResultsMessage
                    }
                    else
                    {
                        filteredArtists = result
                        print("\(filteredArtists.count) artists were filtered")
                        collectionView.reloadData()
                        emptyMessageLabel.isHidden = true
                    }
                }
                else
                {
                    filteredArtists = []
                    collectionView.reloadData()
                    emptyMessageLabel.isHidden = false
                    emptyMessageLabel.attributedText = noResultsMessage
                }
            }
        }
        else
        {
            filteredSongs = []
            filteredArtists = []
            filteredAlbums = []
            collectionView.reloadData()
            emptyMessageLabel.isHidden = false
            emptyMessageLabel.attributedText = initialMessage
        }
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        updateSearchResults(forQuery: searchController.searchBar.text)
    }
}

extension SearchResultsViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int)
    {
        self.searchMode = selectedScope
    }
}

extension SearchResultsViewController
{
    func onSongFavouriteMenuItemTap(menuItem: UIAction, tag: Int)
    {
        
    }
    
    func onSongUnfavouriteMenuItemTap(menu: UIMenu, tag: Int)
    {
        
    }
    
    func onSongAddToPlaylistMenuItemTap(menuItem: UIAction, tag: Int)
    {
        
    }
    
    func onAlbumFavouriteMenuItemTap(menuItem: UIAction, tag: Int)
    {
        
    }
    
    func onShowAlbumMenuItemTap(tag: Int)
    {
        let album = DataProcessor.shared.getAlbumThat(containsSong: filteredSongs[tag].title!)!
        delegate?.onAlbumSelection(selectedAlbum: album)
    }
}
