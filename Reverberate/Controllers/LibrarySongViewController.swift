//
//  LibrarySongViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 19/07/22.
//

import UIKit

class LibrarySongViewController: UITableViewController
{
    private let requesterId: Int = 2
    
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
    
    private lazy var noFavouritesMessage: NSAttributedString = {
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
        var mutableAttrString = NSMutableAttributedString(string: "No Favourites were found\n\n", attributes: largeTextAttributes)
        mutableAttrString.append(NSMutableAttributedString(string: "Try adding some songs to Favourites.", attributes: smallerTextAttributes))
        return mutableAttrString
    }()
    
    private lazy var emptyMessageLabel: UILabel = {
        let emLabel = UILabel(useAutoLayout: true)
        emLabel.textAlignment = .center
        emLabel.numberOfLines = 4
        emLabel.isHidden = true
        return emLabel
    }()
    
     private lazy var searchController: UISearchController = {
        let sController = UISearchController(searchResultsController: nil)
        sController.searchResultsUpdater = self
        sController.delegate = self
        sController.hidesNavigationBarDuringPresentation = true
        sController.searchBar.placeholder = "Find in Songs"
        return sController
    }()
    
    private lazy var playIcon: UIImage = {
        return UIImage(systemName: "play.fill")!
    }()
    
    private lazy var pauseIcon: UIImage = {
        return UIImage(systemName: "pause.fill")!
    }()
    
    private lazy var playButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = playIcon
        config.title = "Play"
        config.imagePlacement = .leading
        config.imagePadding = 10
        config.buttonSize = .large
        config.baseBackgroundColor = UIColor(named: GlobalConstants.techinessColor)!
        let pButton = UIButton(configuration: config)
        pButton.enableAutoLayout()
        return pButton
    }()
    
    private lazy var shuffleButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "shuffle")!
        config.title = "Shuffle All"
        config.imagePlacement = .leading
        config.imagePadding = 10
        config.buttonSize = .large
        config.baseBackgroundColor = .secondarySystemFill
        config.baseForegroundColor = UIColor(named: GlobalConstants.techinessColor)!
        let sButton = UIButton(configuration: config)
        sButton.enableAutoLayout()
        return sButton
    }()
    
    var viewOnlyFavSongs: Bool = false
    
    private lazy var allSongs: [Song] = viewOnlyFavSongs ? DataManager.shared.availableSongs.filter({ GlobalVariables.shared.currentUser!.isFavouriteSong($0) }) : DataManager.shared.availableSongs
    
    private lazy var sortedSongs: [Alphabet : [Song]] = sortSongs()
    
    private lazy var tableHeaderView: UIView = createTableHeaderView()
    
    private lazy var backgroundView: UIView = UIView()
    
    private var filteredSongs: [Alphabet : [SongSearchResult]] = [:]
    
    private var songToBeAddedToPlaylist: Song? = nil
    
    private var playlist: Playlist
    {
        get
        {
            let songPlaylist = Playlist()
            songPlaylist.name = title
            songPlaylist.songs = sortedSongs.values.flatMap({ $0 }).sorted()
            return songPlaylist
        }
    }
    
    private var isSearchBarEmpty: Bool
    {
       return searchController.searchBar.text?.isEmpty ?? true
    }

    private var isFiltering: Bool
    {
       return searchController.isActive && !isSearchBarEmpty
    }
    
    weak var delegate: PlaylistDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        if SessionManager.shared.isUserLoggedIn
        {
            setupFilterMenu()
        }
        if viewOnlyFavSongs
        {
            title = "Favourite Songs"
        }
        else
        {
            title = "All Songs"
        }
        tableView.tableHeaderView = tableHeaderView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        tableView.sectionHeaderTopPadding = 0
        backgroundView.addSubview(emptyMessageLabel)
        NSLayoutConstraint.activate([
            emptyMessageLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            emptyMessageLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            emptyMessageLabel.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.8)
        ])
        emptyMessageLabel.attributedText = noResultsMessage
        tableView.backgroundView = backgroundView
        playButton.addTarget(self, action: #selector(onPlayButtonTap(_:)), for: .touchUpInside)
        shuffleButton.addTarget(self, action: #selector(onShuffleButtonTap(_:)), for: .touchUpInside)
        if GlobalVariables.shared.currentPlaylist == playlist
        {
            if GlobalVariables.shared.avAudioPlayer!.isPlaying
            {
                onPlayNotificationReceipt()
            }
        }
        NotificationCenter.default.setObserver(self, selector: #selector(onShowAlbumNotification(_:)), name: .showAlbumTapNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(onPlayNotificationReceipt), name: NSNotification.Name.playerPlayNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(onPausedNotificationReceipt), name: NSNotification.Name.playerPausedNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(onSongChange), name: NSNotification.Name.currentSongSetNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(onUserLoginNotification), name: .userLoggedInNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(onAddSongToFavouritesNotification(_:)), name: .addSongToFavouritesNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(onRemoveSongFromFavouritesNotification(_:)), name: .removeSongFromFavouritesNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(onAddSongToPlaylistNotification(_:)), name: .addSongToPlaylistNotification, object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: .showAlbumTapNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.playerPlayNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.playerPausedNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .currentSongSetNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .userLoggedInNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .addSongToFavouritesNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .removeSongFromFavouritesNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .addSongToPlaylistNotification, object: nil)
        LifecycleLogger.deinitLog(self)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
    }
    
    private func sortSongs() -> [Alphabet: [Song]]
    {
        var result: [Alphabet : [Song]] = [ : ]
        for alphabet in Alphabet.allCases
        {
            let startingLetter = alphabet.asString
            result[alphabet] = allSongs.filter({ $0.title!.hasPrefix(startingLetter)}).sorted()
        }
        return result
    }
    
    private func createTableHeaderView() -> UIView
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60))
        headerView.addSubview(playButton)
        headerView.addSubview(shuffleButton)
        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            playButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            playButton.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.42),
            shuffleButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            shuffleButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            shuffleButton.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.42),
        ])
        return headerView
    }
    
    private func resetPlayAndShuffleButtons()
    {
        if viewOnlyFavSongs
        {
            if allSongs.isEmpty
            {
                playButton.configuration!.title = "Play"
                playButton.configuration!.image = playIcon
                playButton.isEnabled = false
                shuffleButton.isEnabled = false
            }
            else
            {
                playButton.isEnabled = true
                shuffleButton.isEnabled = true
            }
        }
        else
        {
            playButton.isEnabled = true
            shuffleButton.isEnabled = true
        }
    }
    
    private func getAllSongsMenuItem(_ state: UIMenuElement.State) -> UIAction
    {
        return UIAction(title: "All Songs", image: UIImage(systemName: "music.note")!, state: state, handler: { [unowned self] _ in
            if !viewOnlyFavSongs
            {
                return
            }
            title = "All Songs"
            searchController.searchBar.placeholder = "Find in Songs"
            allSongs = DataManager.shared.availableSongs
            sortedSongs = sortSongs()
            viewOnlyFavSongs = false
            emptyMessageLabel.isHidden = true
            tableView.reloadData()
            resetPlayAndShuffleButtons()
        })
    }
    
    private func getFavSongsMenuItem(_ state: UIMenuElement.State) -> UIAction
    {
        return UIAction(title: "Favourite Songs", image: UIImage(systemName: "heart")!, state: state, handler: { [unowned self] _ in
            if viewOnlyFavSongs
            {
                return
            }
            title = "Favourite Songs"
            searchController.searchBar.placeholder = "Find in Favourite Songs"
            allSongs = self.allSongs.filter({ GlobalVariables.shared.currentUser!.isFavouriteSong($0) })
            sortedSongs = self.sortSongs()
            viewOnlyFavSongs = true
            if allSongs.isEmpty
            {
                emptyMessageLabel.attributedText = noFavouritesMessage
                emptyMessageLabel.isHidden = false
            }
            else
            {
                emptyMessageLabel.isHidden = true
            }
            tableView.reloadData()
            resetPlayAndShuffleButtons()
        })
    }
    
    private func setupFilterMenu()
    {
        let menuBarItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease")!, style: .plain, target: nil, action: nil)
        menuBarItem.menu = UIMenu(title: "", image: nil, identifier: nil, options: .singleSelection, children: [
            getAllSongsMenuItem(.on),
            getFavSongsMenuItem(.off)
        ])
        navigationItem.rightBarButtonItem = menuBarItem
    }
    
    private func createMenu(song: Song) -> UIMenu
    {
        return ContextMenuProvider.shared.getSongMenu(song: song, requesterId: requesterId)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    // MARK: - Table view data source and Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 26
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return isFiltering ? filteredSongs[Alphabet(rawValue: section)!]?.count ?? 0 : sortedSongs[Alphabet(rawValue: section)!]!.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let alphabet = Alphabet(rawValue: section)!
        if isFiltering
        {
            return filteredSongs[alphabet]?.isEmpty ?? true ? nil : alphabet.asString
        }
        else
        {
            return sortedSongs[alphabet]!.isEmpty ? nil : alphabet.asString
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]?
    {
        return Alphabet.allCases.map({ $0.asString })
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
    {
        return index
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let section = indexPath.section
        let item = indexPath.item
        var song: Song!
        var config = cell.defaultContentConfiguration()
        if isFiltering
        {
            let songResult = filteredSongs[Alphabet(rawValue: section)!]![item]
            song = songResult.song
            var attributedTitle: NSAttributedString = NSAttributedString(string: song.title!)
            var attributedArtistNames: NSAttributedString = NSAttributedString(string: song.getArtistNamesAsString(artistType: nil))
            if let titleRange = songResult.titleRange
            {
                attributedTitle = song.title!.getHighlightedAttributedString(forRange: titleRange, withPointSize: config.textProperties.font.pointSize)
            }
            if let artistsRange = songResult.artistsRange
            {
                attributedArtistNames = song.getArtistNamesAsString(artistType: nil).getHighlightedAttributedString(forRange: artistsRange, withPointSize: config.secondaryTextProperties.font.pointSize)
            }
            config.attributedText = attributedTitle
            config.secondaryAttributedText = attributedArtistNames
            config.image = song.coverArt!
        }
        else
        {
            song = sortedSongs[Alphabet(rawValue: section)!]![item]
            let attributedTitle: NSAttributedString = NSAttributedString(string: song.title!)
            let attributedArtistNames: NSAttributedString = NSAttributedString(string: song.getArtistNamesAsString(artistType: nil))
            config.attributedText = attributedTitle
            config.secondaryAttributedText = attributedArtistNames
            config.image = song.coverArt!
        }
        config.imageProperties.cornerRadius = 10
        config.textProperties.adjustsFontForContentSizeCategory = true
        config.textProperties.allowsDefaultTighteningForTruncation = true
        config.secondaryTextProperties.adjustsFontForContentSizeCategory = true
        config.secondaryTextProperties.color = .secondaryLabel
        config.secondaryTextProperties.allowsDefaultTighteningForTruncation = true
        config.secondaryTextProperties.font = .preferredFont(forTextStyle: .footnote)
        cell.configurationUpdateHandler = { cell, state in
            guard var updatedConfig = cell.contentConfiguration?.updated(for: state) as? UIListContentConfiguration else
            {
                return
            }
            updatedConfig.textProperties.color =  state.isSelected || state.isHighlighted ? UIColor(named: GlobalConstants.techinessColor)! : .label
            cell.contentConfiguration = updatedConfig
        }
        cell.contentConfiguration = config
        var menuButtonConfig = UIButton.Configuration.plain()
        menuButtonConfig.baseForegroundColor = .systemGray
        menuButtonConfig.image = UIImage(systemName: "ellipsis")!
        menuButtonConfig.buttonSize = .medium
        let menuButton = UIButton(configuration: menuButtonConfig)
        menuButton.tag = item
        menuButton.sizeToFit()
        menuButton.menu = createMenu(song: song)
        menuButton.showsMenuAsPrimaryAction = true
        cell.selectionStyle = .none
        cell.accessoryView = menuButton
        cell.backgroundColor = .clear
        if GlobalVariables.shared.currentPlaylist == playlist
        {
            if GlobalVariables.shared.currentSong == song
            {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                if GlobalVariables.shared.avAudioPlayer!.isPlaying
                {
                    onPlayNotificationReceipt()
                }
                else
                {
                    onPausedNotificationReceipt()
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let section = indexPath.section
        let item = indexPath.item
        let song = isFiltering ? filteredSongs[Alphabet(rawValue: section)!]![item].song : sortedSongs[Alphabet(rawValue: section)!]![item]
        if GlobalVariables.shared.currentPlaylist == playlist
        {
            if GlobalVariables.shared.currentSong == song
            {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                if GlobalVariables.shared.avAudioPlayer!.isPlaying
                {
                    onPlayNotificationReceipt()
                }
                else
                {
                    onPausedNotificationReceipt()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let section = indexPath.section
        let item = indexPath.item
        let song = isFiltering ? filteredSongs[Alphabet(rawValue: section)!]![item].song : sortedSongs[Alphabet(rawValue: section)!]![item]
        if GlobalVariables.shared.currentPlaylist == playlist
        {
            if GlobalVariables.shared.currentSong != song
            {
                delegate?.onPlaylistSongChangeRequest(playlist: playlist, newSong: song)
            }
        }
        else
        {
            delegate?.onPlaylistSongChangeRequest(playlist: playlist, newSong: song)
        }
        onPlayNotificationReceipt()
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
    {
        let section = indexPath.section
        let item = indexPath.item
        let song = isFiltering ? filteredSongs[Alphabet(rawValue: section)!]![item].song : sortedSongs[Alphabet(rawValue: section)!]![item]
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil, actionProvider: { [unowned self] _ in
            return createMenu(song: song)
        })
    }
    
    override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating)
    {
        guard let indexPath = configuration.identifier as? IndexPath else
        {
            return
        }
        animator.preferredCommitStyle = .dismiss
        let section = indexPath.section
        let item = indexPath.item
        let song = isFiltering ? filteredSongs[Alphabet(rawValue: section)!]![item].song : sortedSongs[Alphabet(rawValue: section)!]![item]
        animator.addAnimations { [unowned self] in
            if GlobalVariables.shared.currentPlaylist == playlist
            {
                if GlobalVariables.shared.currentSong != song
                {
                    delegate?.onPlaylistSongChangeRequest(playlist: playlist, newSong: song)
                }
            }
            else
            {
                delegate?.onPlaylistSongChangeRequest(playlist: playlist, newSong: song)
            }
            onPlayNotificationReceipt()
        }
    }
}

extension LibrarySongViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        guard let query = searchController.searchBar.text, !query.isEmpty else
        {
            tableView.reloadData()
            return
        }
        filteredSongs = DataProcessor.shared.getSortedSongsThatSatisfy(theQuery: query, songSource: viewOnlyFavSongs ? allSongs : nil)
        emptyMessageLabel.attributedText = viewOnlyFavSongs ? (allSongs.isEmpty ? noFavouritesMessage : noResultsMessage) : noResultsMessage
        emptyMessageLabel.isHidden = !filteredSongs.isEmpty
        tableView.reloadData()
    }
}

extension LibrarySongViewController: UISearchControllerDelegate
{
    func willPresentSearchController(_ searchController: UISearchController)
    {
        tableView.tableHeaderView = nil
    }
    
    func willDismissSearchController(_ searchController: UISearchController)
    {
        emptyMessageLabel.isHidden = viewOnlyFavSongs ? (allSongs.isEmpty ? false : true) : true
        tableView.tableHeaderView = tableHeaderView
    }
    
    func didDismissSearchController(_ searchController: UISearchController)
    {
        tableView.reloadData()
        filteredSongs = [:]
    }
}
extension LibrarySongViewController
{
    @objc func onUserLoginNotification()
    {
        setupFilterMenu()
    }
    
    @objc func onPlayNotificationReceipt()
    {
        if GlobalVariables.shared.currentPlaylist == playlist
        {
            playButton.configuration!.title = "Pause"
            playButton.configuration!.image = pauseIcon
        }
    }
    
    @objc func onPausedNotificationReceipt()
    {
        if GlobalVariables.shared.currentPlaylist == playlist
        {
            playButton.configuration!.title = "Play"
            playButton.configuration!.image = playIcon
        }
    }
    
    @objc func onSongChange()
    {
        guard let currentPlaylist = GlobalVariables.shared.currentPlaylist else
        {
            tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
            playButton.configuration!.title = "Play"
            playButton.configuration!.image = playIcon
            return
        }
        guard currentPlaylist == playlist else
        {
            tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
            playButton.configuration!.title = "Play"
            playButton.configuration!.image = playIcon
            return
        }
        let currentSong = GlobalVariables.shared.currentSong!
        let alphabet = Alphabet.getAlphabetFromLetter(currentSong.title!.first!)
        let section = alphabet.rawValue
        guard let item = sortedSongs[alphabet]!.firstIndex(of: currentSong) else
        {
            tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
            playButton.configuration!.title = "Play"
            playButton.configuration!.image = playIcon
            return
        }
        print("current song found")
        let indexPath = IndexPath(item: item, section: section)
        guard let selectedIndexPath = tableView.indexPathForSelectedRow, selectedIndexPath == indexPath else
        {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            if GlobalVariables.shared.avAudioPlayer!.isPlaying
            {
                onPlayNotificationReceipt()
            }
            else
            {
                onPausedNotificationReceipt()
            }
            return
        }
    }

    
    @objc func onPlayButtonTap(_ sender: UIButton)
    {
        if sender.configuration!.title == "Play"
        {
            print("Gonna Play")
            delegate?.onPlaylistPlayRequest(playlist: playlist)
            sender.configuration!.title = "Pause"
            sender.configuration!.image = pauseIcon
        }
        else
        {
            print("Gonna Pause")
            delegate?.onPlaylistPauseRequest(playlist: playlist)
            sender.configuration!.title = "Play"
            sender.configuration!.image = playIcon
        }
    }
    
    @objc func onShuffleButtonTap(_ sender: UIButton)
    {
        delegate?.onPlaylistShuffleRequest(playlist: playlist, shuffleMode: .on)
        playButton.configuration!.image = pauseIcon
        playButton.configuration!.title = "Pause"
    }
    
    @objc func onAddSongToPlaylistNotification(_ notification: NSNotification)
    {
        guard let receiverId = notification.userInfo?["receiverId"] as? Int, receiverId == requesterId else
        {
            return
        }
        guard let song = notification.userInfo?["song"] as? Song else
        {
            return
        }
        songToBeAddedToPlaylist = song
        let playlistSelectionVc = PlaylistSelectionViewController(style: .plain)
        playlistSelectionVc.delegate = self
        let playlistVcNavigationVc = UINavigationController(rootViewController: playlistSelectionVc)
        if let sheet = playlistVcNavigationVc.sheetPresentationController
        {
            print("sheet")
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
        }
        self.present(playlistVcNavigationVc, animated: true)
    }
    
    @objc func onAddSongToFavouritesNotification(_ notification: NSNotification)
    {
        guard let receiverId = notification.userInfo?["receiverId"] as? Int, receiverId == requesterId else
        {
            return
        }
        guard let song = notification.userInfo?["song"] as? Song else
        {
            return
        }
        GlobalVariables.shared.currentUser!.addToFavouriteSongs(song)
    }
    
    @objc func onRemoveSongFromFavouritesNotification(_ notification: NSNotification)
    {
        guard let receiverId = notification.userInfo?["receiverId"] as? Int, receiverId == requesterId else
        {
            return
        }
        guard let song = notification.userInfo?["song"] as? Song else
        {
            return
        }
        GlobalVariables.shared.currentUser!.removeFromFavouriteSongs(song)
        if viewOnlyFavSongs
        {
            allSongs = DataManager.shared.availableSongs.filter({ GlobalVariables.shared.currentUser!.isFavouriteSong($0) })
            sortedSongs = sortSongs()
            emptyMessageLabel.attributedText = noFavouritesMessage
            emptyMessageLabel.isHidden = !allSongs.isEmpty
            if isFiltering
            {
                updateSearchResults(for: searchController)
            }
            else
            {
                tableView.reloadData()
            }
            resetPlayAndShuffleButtons()
        }
    }
    
    @objc func onShowAlbumNotification(_ notification: NSNotification)
    {
        guard let receiverId = notification.userInfo?["receiverId"] as? Int, receiverId == requesterId else
        {
            return
        }
        guard let song = notification.userInfo?["song"] as? Song else
        {
            return
        }
        let album = DataProcessor.shared.getAlbumThat(containsSong: song.title!)
        let albumVc = PlaylistViewController(style: .grouped)
        albumVc.delegate = GlobalVariables.shared.mainTabController
        albumVc.playlist = album
        self.navigationController?.pushViewController(albumVc, animated: true)
    }
}

extension LibrarySongViewController: PlaylistSelectionDelegate
{
    func onPlaylistSelection(selectedPlaylist: Playlist)
    {
        guard let songToBeAdded = songToBeAddedToPlaylist else { return }
        if selectedPlaylist.songs!.contains(where: { $0.title! == songToBeAdded.title! })
        {
            let alert = UIAlertController(title: "Song exists already in Playlist", message: "The chosen song is present already in Playlist", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel))
            self.present(alert, animated: true)
        }
        else
        {
            GlobalVariables.shared.currentUser!.add(song: songToBeAdded, toPlaylistNamed: selectedPlaylist.name!)
            NotificationCenter.default.post(name: .songAddedToPlaylistNotification, object: nil, userInfo: ["playlistName" : selectedPlaylist.name!])
            let alert = UIAlertController(title: "Song added to Playlist", message: "The chosen song was added to \(selectedPlaylist.name!) Playlist successfully!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel))
            self.present(alert, animated: true)
        }
        songToBeAddedToPlaylist = nil
    }
}
