//
//  LibrarySongViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 19/07/22.
//

import UIKit

class LibrarySongViewController: UITableViewController
{
    private let requesterId: Int = 0
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let contextSaveAction = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
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
         let libraryResultsVC = LibraryResultsViewController(style: .insetGrouped)
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
    
    private var viewOnlyFavSongs: Bool = false
    
    private lazy var allSongs: [Song] = DataManager.shared.availableSongs
    
    private lazy var sortedSongs: [Alphabet : [Song]] = sortSongs()
    
    private lazy var tableHeaderView: UIView = createTableHeaderView()
    
    private lazy var backgroundView: UIView = UIView()
    
    private var filteredSongs: [Alphabet : [Song]] = [:]
    
    private var isSearchBarEmpty: Bool
    {
       return searchController.searchBar.text?.isEmpty ?? true
    }

    private var isFiltering: Bool
    {
       return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "All Songs"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        if SessionManager.shared.isUserLoggedIn
        {
            setupFilterMenu()
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
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(onShowAlbumNotification(_:)), name: .showAlbumTapNotification, object: nil)
        if SessionManager.shared.isUserLoggedIn
        {
            NotificationCenter.default.addObserver(self, selector: #selector(onAddSongToFavouritesNotification(_:)), name: .addSongToFavouritesNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(onRemoveSongFromFavouritesNotification(_:)), name: .removeSongFromFavouritesNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(onAddSongToPlaylistNotification(_:)), name: .addSongToPlaylistNotification, object: nil)
        }
        else
        {
            NotificationCenter.default.addObserver(self, selector: #selector(onLoginRequestNotification(_:)), name: .loginRequestNotification, object: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: .showAlbumTapNotification, object: nil)
        if SessionManager.shared.isUserLoggedIn
        {
            NotificationCenter.default.removeObserver(self, name: .addSongToFavouritesNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: .removeSongFromFavouritesNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: .addSongToPlaylistNotification, object: nil)
        }
        else
        {
            NotificationCenter.default.removeObserver(self, name: .loginRequestNotification, object: nil)
        }
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
    
    private func setupFilterMenu()
    {
        let menuBarItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease")!, style: .plain, target: nil, action: nil)
        menuBarItem.menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [
            UIDeferredMenuElement.uncached({ completion in
                DispatchQueue.main.async { [unowned self] in
                    let allSongsMenuItem = UIAction(title: "All Songs", image: UIImage(systemName: "music.note")!, handler: { [unowned self] _ in
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
                    })
                    let favouriteSongsMenuItem = UIAction(title: "Favourite Songs", image: UIImage(systemName: "heart")!, handler: { [unowned self] _ in
                        if viewOnlyFavSongs
                        {
                            return
                        }
                        title = "Favourite Songs"
                        searchController.searchBar.placeholder = "Find in Favourite Songs"
                        allSongs = allSongs.filter({ GlobalVariables.shared.currentUser!.isFavouriteSong($0) })
                        sortedSongs = sortSongs()
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
                    })
                    if viewOnlyFavSongs
                    {
                        favouriteSongsMenuItem.state = .on
                        allSongsMenuItem.state = .off
                        completion([allSongsMenuItem,favouriteSongsMenuItem])
                    }
                    else
                    {
                        favouriteSongsMenuItem.state = .off
                        allSongsMenuItem.state = .on
                        completion([allSongsMenuItem,favouriteSongsMenuItem])
                    }
                }
            })
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
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let section = indexPath.section
        let item = indexPath.item
        let song = isFiltering ? filteredSongs[Alphabet(rawValue: section)!]![item] : sortedSongs[Alphabet(rawValue: section)!]![item]
        var config = cell.defaultContentConfiguration()
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
        var menuButtonConfig = UIButton.Configuration.plain()
        menuButtonConfig.baseForegroundColor = .systemGray
        menuButtonConfig.image = UIImage(systemName: "ellipsis")!
        menuButtonConfig.buttonSize = .medium
        let menuButton = UIButton(configuration: menuButtonConfig)
        menuButton.tag = item
        menuButton.sizeToFit()
        menuButton.menu = createMenu(song: song)
        menuButton.showsMenuAsPrimaryAction = true
        cell.accessoryView = menuButton
        cell.backgroundColor = .clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
    {
        let section = indexPath.section
        let item = indexPath.item
        let song = isFiltering ? filteredSongs[Alphabet(rawValue: section)!]![item] : sortedSongs[Alphabet(rawValue: section)!]![item]
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { [unowned self] _ in
            return createMenu(song: song)
        })
    }
}

extension LibrarySongViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        guard let query = searchController.searchBar.text, !query.isEmpty else
        { return }
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
    @objc func onPlayButtonTap(_ sender: UIButton)
    {
        if sender.configuration!.title == "Play"
        {
            print("Gonna Play")
//           delegate?.onPlaylistPlayRequest(playlist: playlist)
            sender.configuration!.title = "Pause"
            sender.configuration!.image = pauseIcon
        }
        else
        {
            print("Gonna Pause")
//            delegate?.onPlaylistPauseRequest(playlist: playlist)
            sender.configuration!.title = "Play"
            sender.configuration!.image = playIcon
        }
    }
    
    @objc func onShuffleButtonTap(_ sender: UIButton)
    {
        
    }
    
    @objc func onLoginRequestNotification(_ notification: NSNotification)
    {
        
    }
    
    @objc func onAddSongToPlaylistNotification(_ notification: NSNotification)
    {
        
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
        GlobalVariables.shared.currentUser!.favouriteSongs!.appendUniquely(song)
        contextSaveAction()
        print(GlobalVariables.shared.currentUser!.id!)
        print(UserDefaults.standard.string(forKey: GlobalConstants.currentUserId)!)
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
        GlobalVariables.shared.currentUser!.favouriteSongs!.removeUniquely(song)
        contextSaveAction()
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
