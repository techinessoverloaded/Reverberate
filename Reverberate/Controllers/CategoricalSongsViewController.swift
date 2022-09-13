//
//  CategoricalSongsViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 19/07/22.
//

import UIKit

class CategoricalSongsViewController: UITableViewController
{
    private lazy var playIcon: UIImage = {
        return UIImage(systemName: "play.fill")!
    }()
    
    private lazy var pauseIcon: UIImage = {
        return UIImage(systemName: "pause.fill")!
    }()
    
    private lazy var heartIcon: UIImage = {
        return UIImage(systemName: "heart")!
    }()
    
    private lazy var heartFilledIcon: UIImage = {
        return UIImage(systemName: "heart.fill")!
    }()
    
    var category: Category!
    
    private lazy var playlist: Playlist = {
        let categoricalPlaylist = Playlist()
        categoricalPlaylist.name = category.description
        categoricalPlaylist.songs = songs
        return categoricalPlaylist
    }()
    
    weak var delegate: PlaylistDelegate?
    
    private lazy var songs: [Song] = DataProcessor.shared.getSongsOf(category: category)
    
    private lazy var albums: [Album] = DataProcessor.shared.getAlbumsOf(category: category)
    
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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = category.description
        playButton.addTarget(self, action: #selector(onPlayButtonTap(_:)), for: .touchUpInside)
        shuffleButton.addTarget(self, action: #selector(onShuffleButtonTap(_:)), for: .touchUpInside)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
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
        tableView.tableHeaderView = headerView
        if GlobalVariables.shared.currentPlaylist == playlist
        {
            if GlobalVariables.shared.avAudioPlayer!.isPlaying
            {
                onPlayNotificationReceipt()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(onPlayNotificationReceipt), name: NSNotification.Name.playerPlayNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onPausedNotificationReceipt), name: NSNotification.Name.playerPausedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onSongChange), name: NSNotification.Name.currentSongSetNotification, object: nil)
        if category == .recentlyPlayed
        {
            NotificationCenter.default.addObserver(self, selector: #selector(onRecentlyPlayedListChange), name: .recentlyPlayedListChangedNotification, object: nil)
        }
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.playerPlayNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.playerPausedNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .currentSongSetNotification, object: nil)
        if category == .recentlyPlayed
        {
            NotificationCenter.default.removeObserver(self, name: .recentlyPlayedListChangedNotification, object: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
    }
    
    private func getSongMenu(song: Song) -> UIMenu
    {
        return ContextMenuProvider.shared.getSongMenu(song: song, requesterId: GlobalVariables.shared.mainTabController.requesterId)
    }
    
    private func getAlbumMenu(album: Album) -> UIMenu
    {
        return ContextMenuProvider.shared.getAlbumMenu(album: album, requesterId: GlobalVariables.shared.mainTabController.requesterId)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return section == 0 ? songs.count : albums.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return section == 0 ? "Songs" : "Albums"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let section = indexPath.section
        let item = indexPath.item
        var config = cell.defaultContentConfiguration()
        if section == 0
        {
            let song = songs[item]
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
            menuButton.tag = item
            menuButton.sizeToFit()
            menuButton.menu = getSongMenu(song: song)
            menuButton.showsMenuAsPrimaryAction = true
            cell.accessoryView = menuButton
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
        }
        else
        {
            let album = albums[item]
            config.text = album.name!
            config.secondaryText = "\(album.composerNames) · \(album.releaseDate!.get(.year))"
            config.imageProperties.cornerRadius = 10
            config.image = album.coverArt!
            config.textProperties.adjustsFontForContentSizeCategory = true
            config.textProperties.allowsDefaultTighteningForTruncation = true
            config.secondaryTextProperties.adjustsFontForContentSizeCategory = true
            config.secondaryTextProperties.color = .secondaryLabel
            config.secondaryTextProperties.allowsDefaultTighteningForTruncation = true
            config.secondaryTextProperties.font = .preferredFont(forTextStyle: .footnote)
            var menuButtonConfig = UIButton.Configuration.plain()
            menuButtonConfig.baseForegroundColor = .systemGray
            menuButtonConfig.image = UIImage(systemName: "ellipsis")!
            menuButtonConfig.buttonSize = .medium
            let menuButton = UIButton(configuration: menuButtonConfig)
            menuButton.tag = item
            menuButton.sizeToFit()
            menuButton.menu = getAlbumMenu(album: album)
            menuButton.showsMenuAsPrimaryAction = true
            cell.accessoryView = menuButton
        }
        cell.contentConfiguration = config
        cell.backgroundColor = .clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let section = indexPath.section
        let item = indexPath.item
        if section == 0
        {
            let song = songs[item]
            if GlobalVariables.shared.currentPlaylist == playlist
            {
                if GlobalVariables.shared.currentSong == song
                {
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
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
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let section = indexPath.section
        let item = indexPath.item
        if section == 0
        {
            let song = songs[item]
            if GlobalVariables.shared.currentSong != song
            {
                delegate?.onPlaylistSongChangeRequest(playlist: playlist, newSong: song)
            }
            onPlayNotificationReceipt()
        }
        else
        {
            tableView.deselectRow(at: indexPath, animated: true)
            let albumVC = PlaylistViewController(style: .grouped)
            albumVC.playlist = albums[item]
            albumVC.delegate = GlobalVariables.shared.mainTabController
            self.navigationController?.pushViewController(albumVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
    {
        let section = indexPath.section
        let item = indexPath.item
        if section == 0
        {
            let song = songs[item]
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { [unowned self] _ in
                return getSongMenu(song: song)
            })
        }
        else
        {
            let album = albums[item]
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { [unowned self] _ in
                return getAlbumMenu(album: album)
            })
        }
    }
}

extension CategoricalSongsViewController
{
    @objc func onRecentlyPlayedListChange()
    {
        songs = DataProcessor.shared.getSongsOf(category: .recentlyPlayed)
        albums = DataProcessor.shared.getAlbumsOf(category: .recentlyPlayed)
        tableView.reloadSections(IndexSet(integersIn: 0...1), with: .automatic)
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
        guard let item = playlist.songs!.firstIndex(of: currentSong) else
        {
            return
        }
        let indexPath = IndexPath(item: item, section: 0)
        guard let selectedIndexPath = tableView.indexPathForSelectedRow, selectedIndexPath == indexPath else
        {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            return
        }
    }
    
    @objc func onShuffleButtonTap(_ sender: UIButton)
    {
        delegate?.onPlaylistShuffleRequest(playlist: playlist, shuffleMode: .on)
        playButton.configuration!.image = pauseIcon
        playButton.configuration!.title = "Pause"
    }
    
    @objc func onPlayButtonTap(_ sender: UIButton)
    {
        if sender.configuration!.image!.pngData() == playIcon.pngData()
        {
            print("Gonna Play")
            delegate?.onPlaylistPlayRequest(playlist: playlist)
            sender.configuration!.image = pauseIcon
            sender.configuration!.title = "Pause"
        }
        else
        {
            print("Gonna Pause")
            delegate?.onPlaylistPauseRequest(playlist: playlist)
            sender.configuration!.image = playIcon
            sender.configuration!.title = "Play"
        }
    }
}
