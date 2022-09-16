//
//  LibraryPlaylistViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 19/07/22.
//

import UIKit

class LibraryPlaylistViewController: UITableViewController
{
    private let requesterId: Int = Int(NSDate().timeIntervalSince1970 * 1000)
    
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
    
    private lazy var noPlaylistsMessage: NSAttributedString = {
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
        var mutableAttrString = NSMutableAttributedString(string: "No Playlists were found\n\n", attributes: largeTextAttributes)
        mutableAttrString.append(NSMutableAttributedString(string: "Try adding some Playlists.", attributes: smallerTextAttributes))
        return mutableAttrString
    }()
    
    private lazy var emptyMessageLabel: UILabel = {
        let emLabel = UILabel(useAutoLayout: true)
        emLabel.textAlignment = .center
        emLabel.numberOfLines = 4
        return emLabel
    }()
    
     private lazy var searchController: UISearchController = {
        let sController = UISearchController(searchResultsController: nil)
        sController.searchResultsUpdater = self
        sController.delegate = self
        sController.hidesNavigationBarDuringPresentation = true
        sController.searchBar.placeholder = "Find in Playlists"
        return sController
    }()
    
    private lazy var allPlaylists: [Playlist] = GlobalVariables.shared.currentUser!.playlists!
    
    private lazy var sortedPlaylists: [Alphabet : [Playlist]] = sortPlaylists()
    
    private lazy var backgroundView: UIView = UIView()
    
    private var filteredPlaylists: [Alphabet : [Playlist]] = [:]
    
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
        title = "Your Playlists"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onCreatePlaylistButtonTap))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        tableView.sectionHeaderTopPadding = 0
        backgroundView.addSubview(emptyMessageLabel)
        NSLayoutConstraint.activate([
            emptyMessageLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            emptyMessageLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            emptyMessageLabel.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.8)
        ])
        emptyMessageLabel.attributedText = noPlaylistsMessage
        emptyMessageLabel.isHidden = !allPlaylists.isEmpty
        tableView.backgroundView = backgroundView
        if SessionManager.shared.isUserLoggedIn
        {
            NotificationCenter.default.addObserver(self, selector: #selector(onRemovePlaylistNotification(_:)), name: .removePlaylistNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(songAddedToPlaylistNotification(_:)), name: .songAddedToPlaylistNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(songRemovedFromPlaylistNotification(_:)), name: .songRemovedFromPlaylistNotification, object: nil)
        }
    }
    
    deinit
    {
        if SessionManager.shared.isUserLoggedIn
        {
            NotificationCenter.default.removeObserver(self, name: .removePlaylistNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: .songAddedToPlaylistNotification, object: nil)
        }
    }
    
    private func refetchPlaylists()
    {
        allPlaylists = GlobalVariables.shared.currentUser!.playlists!
        sortedPlaylists = sortPlaylists()
        tableView.reloadData()
        emptyMessageLabel.isHidden = isFiltering ? !filteredPlaylists.isEmpty : !allPlaylists.isEmpty
    }
    
    private func sortPlaylists() -> [Alphabet: [Playlist]]
    {
        var result: [Alphabet : [Playlist]] = [ : ]
        for alphabet in Alphabet.allCases
        {
            let startingLetter = alphabet.asString
            result[alphabet] = allPlaylists.filter({ $0.name!.lowercased().hasPrefix(startingLetter.lowercased())}).sorted()
        }
        return result
    }
    
    private func showCreationError(message: String)
    {
        let errorAlert = UIAlertController(title: "Failed to create Playlist", message: "\(message)\n Try creating a Playlist Again.", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { _ in
            DispatchQueue.main.async { [unowned self] in
                self.onCreatePlaylistButtonTap()
            }
        }))
        errorAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        self.present(errorAlert, animated: true)
    }
    
    private func createMenu(playlist: Playlist) -> UIMenu
    {
        return ContextMenuProvider.shared.getPlaylistMenu(playlist: playlist, requesterId: requesterId)
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
        return isFiltering ? filteredPlaylists[Alphabet(rawValue: section)!]?.count ?? 0 : sortedPlaylists[Alphabet(rawValue: section)!]!.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let alphabet = Alphabet(rawValue: section)!
        if isFiltering
        {
            return filteredPlaylists[alphabet]?.isEmpty ?? true ? nil : alphabet.asString
        }
        else
        {
            return sortedPlaylists[alphabet]!.isEmpty ? nil : alphabet.asString
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
        let playlist = isFiltering ? filteredPlaylists[Alphabet(rawValue: section)!]![item] : sortedPlaylists[Alphabet(rawValue: section)!]![item]
        var config = cell.defaultContentConfiguration()
        config.text = playlist.name!
        config.secondaryText = "\(playlist.songs?.count ?? 0) Songs"
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
        menuButton.menu = createMenu(playlist: playlist)
        menuButton.showsMenuAsPrimaryAction = true
        cell.accessoryView = menuButton
        cell.backgroundColor = .clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
    {
        let section = indexPath.section
        let item = indexPath.item
        let playlist = isFiltering ? filteredPlaylists[Alphabet(rawValue: section)!]![item] : sortedPlaylists[Alphabet(rawValue: section)!]![item]
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { [unowned self] _ in
            return createMenu(playlist: playlist)
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let section = indexPath.section
        let item = indexPath.item
        let playlist = isFiltering ? filteredPlaylists[Alphabet(rawValue: section)!]![item] : sortedPlaylists[Alphabet(rawValue: section)!]![item]
        tableView.deselectRow(at: indexPath, animated: true)
        let playlistVC = PlaylistViewController(style: .grouped)
        playlistVC.playlist = playlist
        playlistVC.delegate = GlobalVariables.shared.mainTabController
        self.navigationController?.pushViewController(playlistVC, animated: true)
    }
}

extension LibraryPlaylistViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        guard let query = searchController.searchBar.text, !query.isEmpty else
        {
            filteredPlaylists = sortedPlaylists
            emptyMessageLabel.attributedText = allPlaylists.isEmpty ? noPlaylistsMessage : noResultsMessage
            emptyMessageLabel.isHidden = !filteredPlaylists.isEmpty
            tableView.reloadData()
            return
        }
        filteredPlaylists = DataProcessor.shared.getSortedPlaylistsThatSatisfy(theQuery: query)
        emptyMessageLabel.attributedText = allPlaylists.isEmpty ? noPlaylistsMessage : noResultsMessage
        emptyMessageLabel.isHidden = !filteredPlaylists.isEmpty
        tableView.reloadData()
    }
}

extension LibraryPlaylistViewController: UISearchControllerDelegate
{
    func willDismissSearchController(_ searchController: UISearchController)
    {
        emptyMessageLabel.attributedText = noPlaylistsMessage
        emptyMessageLabel.isHidden = !allPlaylists.isEmpty
    }
    
    func didDismissSearchController(_ searchController: UISearchController)
    {
        tableView.reloadData()
        filteredPlaylists = [:]
    }
}

extension LibraryPlaylistViewController
{
    @objc func songAddedToPlaylistNotification(_ notification: NSNotification)
    {
        refetchPlaylists()
    }
    
    @objc func songRemovedFromPlaylistNotification(_ notification: NSNotification)
    {
        refetchPlaylists()
    }
    
    @objc func onCreatePlaylistButtonTap()
    {
        let alert = UIAlertController(title: "Create New Playlist", message: "Enter name of the New Playlist", preferredStyle: .alert)
        alert.addTextField()
        let nameField = alert.textFields![0]
        nameField.placeholder = "Name of Playlist"
        nameField.returnKeyType = .done
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [unowned self] _ in
            if nameField.text?.isEmpty ?? true
            {
                DispatchQueue.main.async { [unowned self] in
                    showCreationError(message: "Failed to create Playlist as no name was provided!")
                }
            }
            else if allPlaylists.contains(where: { $0.name! == nameField.text! })
            {
                DispatchQueue.main.async { [unowned self] in
                    showCreationError(message: "Failed to create Playlist as a Playlist exists with the same name already!")
                }
            }
            else
            {
                let newPlaylist = Playlist()
                newPlaylist.name = nameField.text!
                newPlaylist.songs = []
                GlobalVariables.shared.currentUser!.addToPlaylists(newPlaylist)
                DispatchQueue.main.async { [unowned self] in
                    self.refetchPlaylists()
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        self.present(alert, animated: true)
    }
    
    @objc func onRemovePlaylistNotification(_ notification: NSNotification)
    {
        guard let receiverId = notification.userInfo?["receiverId"] as? Int, receiverId == requesterId else
        {
            return
        }
        guard let playlist = notification.userInfo?["playlist"] as? Playlist else
        {
            return
        }
        GlobalVariables.shared.currentUser!.removeFromPlaylists(playlist)
        if isFiltering
        {
            updateSearchResults(for: searchController)
        }
        else
        {
            refetchPlaylists()
            emptyMessageLabel.attributedText = noPlaylistsMessage
            emptyMessageLabel.isHidden = !allPlaylists.isEmpty
        }
    }
}
