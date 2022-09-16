//
//  PlaylistViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 01/08/22.
//

import UIKit

class PlaylistViewController: UITableViewController
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
    
    private lazy var heartCircleIcon: UIImage = {
        return UIImage(systemName: "heart.circle")!
    }()
    
    private lazy var heartCircleFilledIcon: UIImage = {
        return UIImage(systemName: "heart.circle.fill")!
    }()
    
    private lazy var posterView: UIImageView = {
        let pView = UIImageView(useAutoLayout: true)
        pView.isUserInteractionEnabled = true
        pView.contentMode = .scaleAspectFill
        pView.image = UIImage(named: "glassmorphic_bg")!
        pView.layer.cornerRadius = 10
        pView.layer.cornerCurve = .continuous
        pView.clipsToBounds = true
        pView.isUserInteractionEnabled = true
        return pView
    }()
    
    private lazy var titleView: MarqueeLabel = {
        let tView = MarqueeLabel(useAutoLayout: true)
        tView.font = .preferredFont(forTextStyle: .title1, weight: .semibold)
        tView.textColor = .label
        tView.textAlignment = .center
        tView.fadeLength = 10
        return tView
    }()
    
    private lazy var artistView: UILabel = {
        let aView = UILabel(useAutoLayout: true)
        aView.font = .preferredFont(forTextStyle: .body, weight: .regular)
        aView.textColor = UIColor(named: GlobalConstants.techinessColor)!
        aView.textAlignment = .center
        aView.isUserInteractionEnabled = true
        aView.adjustsFontSizeToFitWidth = true
        return aView
    }()
    
    private lazy var detailsView: UILabel = {
        let dView = UILabel(useAutoLayout: true)
        dView.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        dView.textColor = .secondaryLabel
        dView.textAlignment = .center
        dView.adjustsFontSizeToFitWidth = true
        return dView
    }()
    
    private lazy var artistTapRecognizer: UITapGestureRecognizer = {
        let aTapRecognizer = UITapGestureRecognizer()
        aTapRecognizer.numberOfTapsRequired = 1
        aTapRecognizer.numberOfTouchesRequired = 1
        return aTapRecognizer
    }()
    
    private lazy var posterTapRecognizer: UITapGestureRecognizer = {
        let pTapRecognizer = UITapGestureRecognizer()
        pTapRecognizer.numberOfTapsRequired = 2
        pTapRecognizer.numberOfTouchesRequired = 1
        return pTapRecognizer
    }()
    
    private lazy var albumFavouriteButton: UIButton = {
        let favButton = UIButton(type: .system)
        favButton.setImage(heartIcon, for: .normal)
        favButton.tintColor = .label
        favButton.enableAutoLayout()
        favButton.contentVerticalAlignment = .fill
        favButton.contentHorizontalAlignment = .fill
        favButton.isHidden = true
        return favButton
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
    
    private lazy var noSongsMessage: NSAttributedString = {
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
        var mutableAttrString = NSMutableAttributedString(string: "No Songs were added\n\n", attributes: largeTextAttributes)
        mutableAttrString.append(NSMutableAttributedString(string: "Try adding some Songs to Playlist.", attributes: smallerTextAttributes))
        return mutableAttrString
    }()
    
    private lazy var backgroundView: UIView = UIView()
    
    private lazy var emptyMessageLabel: UILabel = {
        let emLabel = UILabel(useAutoLayout: true)
        emLabel.textAlignment = .center
        emLabel.numberOfLines = 4
        emLabel.isHidden = true
        return emLabel
    }()
    
    var playlist: Playlist!
    
    weak var delegate: PlaylistDelegate?
    
    private var defaultOffset: CGFloat = 0.0
    
    private var defaultPosterHeight: CGFloat = 0.0
    
    private var searchButton: UIBarButtonItem!
    
    private var headerView: UIView!
    
    private lazy var tableHeaderHeight: CGFloat = isIpad ? 560 : 460
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableHeaderHeight, height: tableHeaderHeight))
        headerView.addSubview(posterView)
        headerView.addSubview(titleView)
        headerView.addSubview(artistView)
        headerView.addSubview(detailsView)
        headerView.addSubview(albumFavouriteButton)
        headerView.addSubview(playButton)
        headerView.addSubview(shuffleButton)
        NSLayoutConstraint.activate([
            posterView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            posterView.topAnchor.constraint(equalTo: headerView.topAnchor),
            posterView.heightAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: 0.65),
            posterView.widthAnchor.constraint(equalTo: posterView.heightAnchor),
            titleView.topAnchor.constraint(equalTo: posterView.bottomAnchor, constant: 10),
            titleView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleView.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.67),
            artistView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 2),
            artistView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            artistView.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.6),
            detailsView.topAnchor.constraint(equalTo: artistView.bottomAnchor, constant: 3),
            detailsView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            detailsView.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.6),
            playButton.trailingAnchor.constraint(equalTo: headerView.centerXAnchor, constant: -10),
            playButton.topAnchor.constraint(equalTo: detailsView.bottomAnchor, constant: 10),
            playButton.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.4),
            shuffleButton.leadingAnchor.constraint(equalTo: headerView.centerXAnchor, constant: 10),
            shuffleButton.topAnchor.constraint(equalTo: detailsView.bottomAnchor, constant: 10),
            shuffleButton.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.4),
            albumFavouriteButton.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            albumFavouriteButton.trailingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: 10)
        ])
        headerView.backgroundColor = .clear
        tableView.tableHeaderView = headerView
        clearsSelectionOnViewWillAppear = false
        defaultPosterHeight = headerView.bounds.height * 0.6
        setPlaylistDetails()
        albumFavouriteButton.addTarget(self, action: #selector(onAlbumFavouriteButtonTap(_:)), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(onPlayButtonTap(_:)), for: .touchUpInside)
        shuffleButton.addTarget(self, action: #selector(onShuffleButtonTap(_:)), for: .touchUpInside)
        let backgroundView = UIView()
        backgroundView.addSubview(emptyMessageLabel)
        NSLayoutConstraint.activate([
            emptyMessageLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            emptyMessageLabel.topAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: 150),
            emptyMessageLabel.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.8)
        ])
        emptyMessageLabel.attributedText = noSongsMessage
        tableView.backgroundView = backgroundView
        NotificationCenter.default.addObserver(self, selector: #selector(onPlayNotificationReceipt), name: NSNotification.Name.playerPlayNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onPausedNotificationReceipt), name: NSNotification.Name.playerPausedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onSongChange), name: NSNotification.Name.currentSongSetNotification, object: nil)
        if SessionManager.shared.isUserLoggedIn
        {
            NotificationCenter.default.addObserver(self, selector: #selector(songRemovedFromPlaylistNotification(_:)), name: .songRemovedFromPlaylistNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(songAddedToPlaylistNotification(_:)), name: .songAddedToPlaylistNotification, object: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.definesPresentationContext = true
        self.navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        defaultOffset = tableView.contentOffset.y
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.playerPlayNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.playerPausedNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.currentSongSetNotification, object: nil)
        if SessionManager.shared.isUserLoggedIn
        {
            NotificationCenter.default.removeObserver(self, name: .songRemovedFromPlaylistNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: .songAddedToPlaylistNotification, object: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        self.definesPresentationContext = false
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    }
    
    private func getSongMenu(song: Song) -> UIMenu
    {
        return (playlist is Album) ? ContextMenuProvider.shared.getAlbumSongMenu(song: song, requesterId: GlobalVariables.shared.mainTabController.requesterId) : ContextMenuProvider.shared.getPlaylistSongMenu(song: song, playlist: playlist, requesterId: GlobalVariables.shared.mainTabController.requesterId)
    }
    
    func setPlaylistDetails()
    {
        albumFavouriteButton.isHidden = !(playlist is Album && SessionManager.shared.isUserLoggedIn)
        if playlist is Album
        {
            let album = playlist as! Album
            title = album.name!
            navigationItem.title = nil
            posterView.image = album.coverArt
            titleView.text = title
            artistView.text = "\(album.composerNames) ›"
            detailsView.text = "\(album.language) · \(album.releaseDate!.getFormattedString())"
            if SessionManager.shared.isUserLoggedIn
            {
                artistTapRecognizer.addTarget(self, action: #selector(onArtistTap(_:)))
                artistView.addGestureRecognizer(artistTapRecognizer)
                posterTapRecognizer.addTarget(self, action: #selector(onPosterDoubleTap(_:)))
                posterView.addGestureRecognizer(posterTapRecognizer)
                if GlobalVariables.shared.currentUser!.isFavouriteAlbum(album)
                {
                    albumFavouriteButton.setImage(heartFilledIcon, for: .normal)
                    albumFavouriteButton.tintColor = .systemPink
                }
                else
                {
                    albumFavouriteButton.setImage(heartIcon, for: .normal)
                    albumFavouriteButton.tintColor = .label
                }
            }
        }
        else
        {
            title = playlist.name!
            navigationItem.title = nil
            titleView.text = title
            if playlist.songs!.isEmpty
            {
                emptyMessageLabel.isHidden = false
                playButton.isEnabled = false
                shuffleButton.isEnabled = false
            }
        }
        if GlobalVariables.shared.currentPlaylist == playlist
        {
            if GlobalVariables.shared.avAudioPlayer!.isPlaying
            {
                onPlayNotificationReceipt()
            }
        }
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return playlist.songs!.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let item = indexPath.item
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        let song = playlist.songs![item]
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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if GlobalVariables.shared.currentPlaylist == playlist
        {
            let currentSong = GlobalVariables.shared.currentSong!
            let song = playlist.songs![indexPath.item]
            if currentSong == song
            {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let item = indexPath.item
        let song = playlist.songs![item]
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
        let item = indexPath.item
        let song = playlist.songs![item]
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { [unowned self] _ in
            return getSongMenu(song: song)
        })
    }
}

extension PlaylistViewController
{
    override func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let finalSize = CGFloat(1.0 / defaultPosterHeight)
        let offset = tableView.contentOffset.y
        let titleOffset = defaultOffset + defaultPosterHeight + 10 + titleView.frame.height
        print("Offset: \(offset)")
        let scale = min(max(1.0 - offset / defaultPosterHeight, finalSize), 1.0)
        let newAlphaValue = 1.0 - (offset / tableHeaderHeight)
        UIView.animate(withDuration: 0.1, delay: 0, options: [.transitionCrossDissolve], animations: { [unowned self] in
            titleView.alpha = newAlphaValue
            posterView.alpha = newAlphaValue
            artistView.alpha = newAlphaValue
            detailsView.alpha = newAlphaValue
            playButton.alpha = offset >= defaultOffset + tableHeaderHeight ? 0.0 : 1.0
            shuffleButton.alpha = offset >= defaultOffset + tableHeaderHeight ? 0.0 : 1.0
            self.navigationItem.title = offset >= titleOffset ? title : nil
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: [], animations: { [unowned self] in
                posterView.transform = CGAffineTransform(scaleX: scale, y: scale)
                }, completion: nil)
        })
    }
}

extension PlaylistViewController
{
    @objc func songAddedToPlaylistNotification(_ notification: NSNotification)
    {
        guard let playlistName = notification.userInfo?["playlistName"] as? String, playlistName == playlist.name! else
        {
            return
        }
        tableView.reloadData()
        emptyMessageLabel.isHidden = !playlist.songs!.isEmpty
        if !playButton.isEnabled
        {
            playButton.isEnabled = true
        }
        if !shuffleButton.isEnabled
        {
            shuffleButton.isEnabled = true
        }
    }
    
    @objc func songRemovedFromPlaylistNotification(_ notification: NSNotification)
    {
        guard let playlistName = notification.userInfo?["playlistName"] as? String, playlistName == playlist.name! else
        {
            return
        }
        tableView.reloadData()
        emptyMessageLabel.attributedText = noSongsMessage
        emptyMessageLabel.isHidden = !playlist.songs!.isEmpty
        if playlist.songs!.isEmpty
        {
            playButton.isEnabled = false
            shuffleButton.isEnabled = false
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
        guard let currentSong = GlobalVariables.shared.currentSong else
        {
            return
        }
        guard let item = playlist.songs!.firstIndex(of: currentSong) else
        {
            return
        }
        let indexPath = IndexPath(item: item, section: 0)
        guard let selectedIndexPath = tableView.indexPathForSelectedRow, selectedIndexPath == indexPath else
        {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            return
        }
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
    
    func onSongAddToPlaylistMenuItemTap(menuItem: UIAction, tag: Int)
    {
        print("\(playlist.songs![tag].title!)'s Menu Item was clicked")
    }
    
    
    @objc func onAlbumFavouriteButtonTap(_ sender: UIButton)
    {
        if sender.image(for: .normal)!.pngData() == heartIcon.pngData()
        {
            GlobalVariables.shared.currentUser!.addToFavouriteAlbums(playlist as! Album)
            sender.setImage(heartFilledIcon, for: .normal)
            UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                sender.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                    sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                }, completion: { _ in
                    UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                        sender.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }, completion: nil)
                })
            })
            sender.tintColor = .systemPink
        }
        else
        {
            GlobalVariables.shared.currentUser!.removeFromFavouriteAlbums(playlist as! Album)
            UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                    sender.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                }, completion: { _ in
                    UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: { [unowned self] in
                        sender.transform = CGAffineTransform(scaleX: 1, y: 1)
                        sender.setImage(heartIcon, for: .normal)
                        sender.tintColor = .label
                    }, completion: nil)
                })
            })
        }
    }
    
    @objc func onArtistTap(_ sender: UITapGestureRecognizer)
    {
        let artistVc = ArtistViewController(style: .grouped)
        artistVc.artist = DataProcessor.shared.getArtist(named: (playlist as! Album).composerNames)
        artistVc.delegate = GlobalVariables.shared.mainTabController
        self.navigationController?.pushViewController(artistVc, animated: true)
    }
    
    @objc func onPosterDoubleTap(_ sender: UITapGestureRecognizer)
    {
        albumFavouriteButton.sendActions(for: .touchUpInside)
    }
}

extension PlaylistViewController : UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController)
    {
        
    }
}
