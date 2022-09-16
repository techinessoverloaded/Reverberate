//
//  ArtistViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 29/07/22.
//

import UIKit

class ArtistViewController: UITableViewController
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

    private lazy var artistFavouriteButton: UIButton = {
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
    
    private lazy var songs = Array(artist.contributedSongs!)

    private lazy var playlist: Playlist = {
        let artistPlaylist = Playlist()
        artistPlaylist.name = artist.name!
        artistPlaylist.songs = songs
        return artistPlaylist
    }()
    
    private lazy var albums = DataProcessor.shared.getAlbumsInvolving(artist: artist.name!)
    
    private var headerView: UIView!
    
    private lazy var tableHeaderHeight: CGFloat = isIpad ? 450 : 350
    
    private var defaultOffset: CGFloat = 0.0
    
    private lazy var defaultPosterHeight: CGFloat = headerView.bounds.height * 0.6
    
    var artist: Artist!
    
    weak var delegate: PlaylistDelegate?
    
    private lazy var artistPhotoView: UIImageView = {
        let pView = UIImageView(useAutoLayout: true)
        pView.isUserInteractionEnabled = true
        pView.contentMode = .scaleAspectFill
        pView.image = UIImage(systemName: "person.crop.circle.fill")!
        pView.layer.cornerCurve = .circular
        pView.clipsToBounds = true
        pView.isUserInteractionEnabled = true
        return pView
    }()
    
    private lazy var artistNameView: MarqueeLabel = {
        let tView = MarqueeLabel(useAutoLayout: true)
        tView.font = .preferredFont(forTextStyle: .title1, weight: .semibold)
        tView.textColor = .label
        tView.textAlignment = .center
        tView.fadeLength = 10
        return tView
    }()
    
    private lazy var artistRoleView: UILabel = {
        let aView = UILabel(useAutoLayout: true)
        aView.font = .preferredFont(forTextStyle: .body, weight: .regular)
        aView.textColor = UIColor(named: GlobalConstants.techinessColor)!
        aView.textAlignment = .center
        aView.isUserInteractionEnabled = true
        aView.adjustsFontSizeToFitWidth = true
        return aView
    }()
    
    private lazy var posterTapRecognizer: UITapGestureRecognizer = {
        let pTapRecognizer = UITapGestureRecognizer()
        pTapRecognizer.numberOfTapsRequired = 2
        pTapRecognizer.numberOfTouchesRequired = 1
        return pTapRecognizer
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tableView.backgroundColor = .systemGroupedBackground
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableHeaderHeight, height: tableHeaderHeight))
        headerView.addSubview(artistPhotoView)
        headerView.addSubview(artistNameView)
        headerView.addSubview(artistRoleView)
        headerView.addSubview(artistFavouriteButton)
        headerView.addSubview(playButton)
        headerView.addSubview(shuffleButton)
        NSLayoutConstraint.activate([
            artistPhotoView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            artistPhotoView.topAnchor.constraint(equalTo: headerView.topAnchor),
            artistPhotoView.heightAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: 0.6),
            artistPhotoView.widthAnchor.constraint(equalTo: artistPhotoView.heightAnchor),
            artistNameView.topAnchor.constraint(equalTo: artistPhotoView.bottomAnchor, constant: 10),
            artistNameView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            artistNameView.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.6),
            artistRoleView.topAnchor.constraint(equalTo: artistNameView.bottomAnchor, constant: 2),
            artistRoleView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            artistRoleView.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.67),
            playButton.trailingAnchor.constraint(equalTo: headerView.centerXAnchor, constant: -10),
            playButton.topAnchor.constraint(equalTo: artistRoleView.bottomAnchor, constant: 10),
            playButton.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.4),
            shuffleButton.leadingAnchor.constraint(equalTo: headerView.centerXAnchor, constant: 10),
            shuffleButton.topAnchor.constraint(equalTo: artistRoleView.bottomAnchor, constant: 10),
            shuffleButton.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.4),
            artistFavouriteButton.centerYAnchor.constraint(equalTo: artistNameView.centerYAnchor),
            artistFavouriteButton.trailingAnchor.constraint(equalTo: artistNameView.trailingAnchor, constant: 10)
        ])
        headerView.backgroundColor = .clear
        tableView.tableHeaderView = headerView
        tableView.allowsMultipleSelection = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        artistFavouriteButton.addTarget(self, action: #selector(onArtistFavouriteButtonTap(_:)), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(onPlayButtonTap(_:)), for: .touchUpInside)
        shuffleButton.addTarget(self, action: #selector(onShuffleButtonTap(_:)), for: .touchUpInside)
        setDetails()
        if GlobalVariables.shared.currentPlaylist == playlist
        {
            if GlobalVariables.shared.avAudioPlayer!.isPlaying
            {
                onPlayNotificationReceipt()
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(onPlayNotificationReceipt), name: NSNotification.Name.playerPlayNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onPausedNotificationReceipt), name: NSNotification.Name.playerPausedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onSongChange), name: NSNotification.Name.currentSongSetNotification, object: nil)
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
        NotificationCenter.default.removeObserver(self, name: .currentSongSetNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        artistPhotoView.layer.cornerRadius = artistPhotoView.bounds.height * 0.5
    }
    
    private func setDetails()
    {
        artistFavouriteButton.isHidden = !(SessionManager.shared.isUserLoggedIn)
        artistPhotoView.image = artist.photo!
        artistNameView.text = artist.name!
        title = artist.name!
        navigationItem.title = nil
        artistRoleView.text = artist.getArtistTypesAsString()
        if SessionManager.shared.isUserLoggedIn
        {
            posterTapRecognizer.addTarget(self, action: #selector(onPosterDoubleTap(_:)))
            artistPhotoView.addGestureRecognizer(posterTapRecognizer)
        }
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if section == 0
        {
            return "Songs Featuring \(artist.name!)"
        }
        else
        {
            return "Albums Featuring \(artist.name!)"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = indexPath.section
        let item = indexPath.item
        if section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var config = cell.defaultContentConfiguration()
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
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var config = cell.defaultContentConfiguration()
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
            cell.contentConfiguration = config
            cell.backgroundColor = .clear
            return cell
        }
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
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let section = indexPath.section
        let item = indexPath.item
        if section == 0
        {
            let song = songs[item]
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
        else
        {
            tableView.deselectRow(at: indexPath, animated: true)
            let album = albums[item]
            let albumVc = PlaylistViewController(style: .grouped)
            albumVc.playlist = album
            albumVc.delegate = GlobalVariables.shared.mainTabController
            self.navigationController?.pushViewController(albumVc, animated: true)
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

extension ArtistViewController
{
    override func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let finalSize = CGFloat(1.0 / defaultPosterHeight)
        let offset = tableView.contentOffset.y
        let titleOffset = defaultOffset + defaultPosterHeight + 10 + artistNameView.frame.height
        print("Offset: \(offset)")
        let scale = min(max(1.0 - offset / defaultPosterHeight, finalSize), 1.0)
        let newAlphaValue = 1.0 - (offset / tableHeaderHeight)
        UIView.animate(withDuration: 0.1, delay: 0, options: [.transitionCrossDissolve], animations: { [unowned self] in
            artistNameView.alpha = newAlphaValue
            artistPhotoView.alpha = newAlphaValue
            artistRoleView.alpha = newAlphaValue
            playButton.alpha = offset >= defaultOffset + tableHeaderHeight ? 0.0 : 1.0
            shuffleButton.alpha = offset >= defaultOffset + tableHeaderHeight ? 0.0 : 1.0
            self.navigationItem.title = offset >= titleOffset ? title : nil
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: [], animations: { [unowned self] in
                artistPhotoView.transform = CGAffineTransform(scaleX: scale, y: scale)
                }, completion: nil)
        })
    }
}

extension ArtistViewController
{
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
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
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
        
    @objc func onArtistFavouriteButtonTap(_ sender: UIButton)
    {
        if sender.image(for: .normal)!.pngData() == heartIcon.pngData()
        {
            GlobalVariables.shared.currentUser!.addToFavouriteArtists(artist)
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
            GlobalVariables.shared.currentUser!.removeFromFavouriteArtists(artist)
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
    
    @objc func onPosterDoubleTap(_ sender: UITapGestureRecognizer)
    {
        artistFavouriteButton.sendActions(for: .touchUpInside)
    }
}
