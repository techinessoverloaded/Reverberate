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
    
    weak var playlistDelegate: PlaylistDelegate?
    
    weak var searchBarRef: UISearchBar?
    
    private var songToBeAddedToPlaylist: Song? = nil
    
    private var playlist: Playlist = {
        let allSongsPlaylist = Playlist()
        allSongsPlaylist.songs = DataManager.shared.availableSongs.sorted()
        allSongsPlaylist.name = "All Songs"
        return allSongsPlaylist
    }()
    
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
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        LifecycleLogger.viewDidAppearLog(self)
        NotificationCenter.default.setObserver(self, selector: #selector(onSongChange), name: NSNotification.Name.currentSongSetNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        LifecycleLogger.viewDidDisappearLog(self)
        NotificationCenter.default.removeObserver(self, name: .currentSongSetNotification, object: nil)
        super.viewDidDisappear(animated)
    }
    
    deinit
    {
        LifecycleLogger.deinitLog(self)
    }
    
    private func createSongMenu(song: Song) -> UIMenu
    {
        return ContextMenuProvider.shared.getSongMenu(song: song, requesterId: GlobalVariables.shared.mainTabController.requesterId, requiresTranslucentSelectionScreen: true)
    }
    
    private func createAlbumMenu(album: Album) -> UIMenu
    {
        return ContextMenuProvider.shared.getAlbumMenu(album: album, requesterId: GlobalVariables.shared.mainTabController.requesterId)
    }
    
    private func createArtistMenu(artist: Artist) -> UIMenu
    {
        return ContextMenuProvider.shared.getArtistMenu(artist: artist, requesterId: GlobalVariables.shared.mainTabController.requesterId)
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
            cell.configurationUpdateHandler = { cell, state in
                guard var updatedConfig = cell.contentConfiguration?.updated(for: state) as? UIListContentConfiguration else
                {
                    return
                }
                updatedConfig.textProperties.colorTransformer = UIConfigurationColorTransformer { _ in
                   return state.isSelected || state.isHighlighted ? UIColor(named: GlobalConstants.techinessColor)! : updatedConfig.textProperties.color
                }
                cell.contentConfiguration = updatedConfig
            }
            var menuButtonConfig = UIButton.Configuration.plain()
            menuButtonConfig.baseForegroundColor = .systemGray
            menuButtonConfig.image = UIImage(systemName: "ellipsis")!
            menuButtonConfig.buttonSize = .medium
            let menuButton = UIButton(configuration: menuButtonConfig)
            menuButton.sizeToFit()
            menuButton.menu = createSongMenu(song: song)
            menuButton.showsMenuAsPrimaryAction = true
            cell.accessories = [UICellAccessory.customView(configuration: .init(customView: menuButton, placement: .trailing(displayed: .always, at: { accessories in
                return 0
            })))]
            if GlobalVariables.shared.currentPlaylist == playlist
            {
                if GlobalVariables.shared.currentSong == song
                {
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
                }
            }
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
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        if searchMode == 0
        {
            let item = indexPath.item
            let song = filteredSongs[item]
            if GlobalVariables.shared.currentPlaylist == playlist
            {
                if GlobalVariables.shared.currentSong == song
                {
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let item = indexPath.item
        if searchMode == 0
        {
            let song = filteredSongs[item]
            if GlobalVariables.shared.currentPlaylist == playlist
            {
                if GlobalVariables.shared.currentSong != song
                {
                    playlistDelegate?.onPlaylistSongChangeRequest(playlist: playlist, newSong: song)
                }
            }
            else
            {
                playlistDelegate?.onPlaylistSongChangeRequest(playlist: playlist, newSong: song)
            }
        }
        else if searchMode == 1
        {
            delegate?.onAlbumSelection(selectedAlbum: filteredAlbums[item])
        }
        else
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
            let song = filteredSongs[item]
            let config = UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil , actionProvider: { [unowned self] _ in
                return createSongMenu(song: song)
            })
            return config
        }
        else if searchMode == 1
        {
            let album = filteredAlbums[item]
            let config = UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil , actionProvider: { [unowned self] _ in
                return createAlbumMenu(album: album)
            })
            return config
        }
        else
        {
            let artist = filteredArtists[item]
            let config = UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil , actionProvider: { [unowned self] _ in
                return createArtistMenu(artist: artist)
            })
            return config
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?
    {
        guard let indexPath = configuration.identifier as? IndexPath else
        {
            return nil
        }
        let cell = collectionView.cellForItem(at: indexPath)!
        let previewParameters = UIPreviewParameters()
        previewParameters.backgroundColor = .clear
        return UITargetedPreview(view: cell.contentView, parameters: previewParameters)
    }
    
    override func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?
    {
        guard let indexPath = configuration.identifier as? IndexPath else
        {
            return nil
        }
        let cell = collectionView.cellForItem(at: indexPath)!
        let previewParameters = UIPreviewParameters()
        previewParameters.backgroundColor = .clear
        return UITargetedPreview(view: cell.contentView, parameters: previewParameters)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating)
    {
        guard let indexPath = configuration.identifier as? IndexPath else
        {
            return
        }
        animator.preferredCommitStyle = searchMode == 0 ? .dismiss : .pop
        let item = indexPath.item
        animator.addAnimations { [unowned self] in
            if searchMode == 0
            {
                let song = filteredSongs[item]
                if GlobalVariables.shared.currentPlaylist == playlist
                {
                    if GlobalVariables.shared.currentSong != song
                    {
                        playlistDelegate?.onPlaylistSongChangeRequest(playlist: playlist, newSong: song)
                    }
                }
                else
                {
                    playlistDelegate?.onPlaylistSongChangeRequest(playlist: playlist, newSong: song)
                }
            }
            else if searchMode == 1
            {
                delegate?.onAlbumSelection(selectedAlbum: filteredAlbums[item])
            }
            else
            {
                delegate?.onArtistSelection(selectedArtist: filteredArtists[item])
            }
        }
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
    @objc func onSongChange()
    {
        guard searchMode == 0 else
        {
            return
        }
        guard let currentPlaylist = GlobalVariables.shared.currentPlaylist else
        {
            collectionView.selectItem(at: nil, animated: true, scrollPosition: .centeredVertically)
            return
        }
        guard currentPlaylist == playlist else
        {
            collectionView.selectItem(at: nil, animated: true, scrollPosition: .centeredVertically)
            return
        }
        let currentSong = GlobalVariables.shared.currentSong!
        guard let indexPath = collectionView.indexPathsForVisibleItems.first(where: { filteredSongs[$0.item] == currentSong }) else
        {
            return
        }
        guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems, !selectedIndexPaths.isEmpty else
        {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
            return
        }
        if !selectedIndexPaths.contains(indexPath)
        {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        }
    }
}
