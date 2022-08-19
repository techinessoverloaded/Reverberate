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
    
    private lazy var songs: [Song] = DataProcessor.shared.getSongsOf(category: category)
    
    private lazy var albums: [Album] = DataProcessor.shared.getAlbumsOf(category: category)
    
    private lazy var playButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .white
        config.buttonSize = .medium
        config.image = UIImage(systemName: "play.fill")!
        config.imagePadding = 10
        let pButton = UIButton(configuration: config)
        return pButton
    }()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = category.description
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: playButton)
        playButton.addTarget(self, action: #selector(onShufflePlayButtonTap(_:)), for: .touchUpInside)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
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
            config.image = song.coverArt!
            config.textProperties.adjustsFontForContentSizeCategory = true
            config.textProperties.allowsDefaultTighteningForTruncation = true
            config.secondaryTextProperties.adjustsFontForContentSizeCategory = true
            config.secondaryTextProperties.color = .secondaryLabel
            config.secondaryTextProperties.allowsDefaultTighteningForTruncation = true
            config.secondaryTextProperties.font = .preferredFont(forTextStyle: .footnote)
            var menuButtonConfig = UIButton.Configuration.plain()
            menuButtonConfig.baseForegroundColor = UIColor(named: GlobalConstants.techinessColor)!
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
            let songMenu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [songFavMenuItem, addToPlaylistMenuItem])
            menuButton.menu = songMenu
            menuButton.showsMenuAsPrimaryAction = true
            cell.accessoryView = menuButton
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
            menuButtonConfig.baseForegroundColor = UIColor(named: GlobalConstants.techinessColor)!
            menuButtonConfig.image = UIImage(systemName: "ellipsis")!
            menuButtonConfig.buttonSize = .medium
            let menuButton = UIButton(configuration: menuButtonConfig)
            menuButton.tag = item
            menuButton.sizeToFit()
            let albumFavMenuItem = UIAction(title: "Add Album to Favourites", image: heartIcon) { [unowned self] menuItem in
                onAlbumFavouriteMenuItemTap(menuItem: menuItem, tag: item)
            }
            let albumMenu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [albumFavMenuItem])
            menuButton.menu = albumMenu
            menuButton.showsMenuAsPrimaryAction = true
            cell.accessoryView = menuButton
        }
        cell.contentConfiguration = config
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let section = indexPath.section
        let item = indexPath.item
        if section == 0
        {
            let song = songs[item]
            if GlobalVariables.shared.currentSong == song
            {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                if GlobalVariables.shared.avAudioPlayer!.isPlaying
                {
                    playButton.configuration!.image = pauseIcon
                }
                else
                {
                    playButton.configuration!.image = playIcon
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
                GlobalVariables.shared.currentSong = song
            }
        }
        else
        {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension CategoricalSongsViewController
{
    @objc func onShufflePlayButtonTap(_ sender: UIButton)
    {
        if sender.configuration!.image!.pngData() == playIcon.pngData()
        {
            print("Gonna Play")
            sender.configuration!.image = pauseIcon
        }
        else
        {
            print("Gonna Pause")
            sender.configuration!.image = playIcon
        }
    }
    
    func onSongFavouriteMenuItemTap(menuItem: UIAction, tag: Int)
    {
        
    }
    
    func onSongAddToPlaylistMenuItemTap(menuItem: UIAction, tag: Int)
    {
        
    }
    
    func onAlbumFavouriteMenuItemTap(menuItem: UIAction, tag: Int)
    {
        
    }
    
    @objc func onAlbumFavouriteButtonTap(_ sender: UIButton)
    {
        if sender.image(for: .normal)!.pngData() == heartIcon.pngData()
        {
            sender.setImage(heartFilledIcon, for: .normal)
            sender.configuration!.baseForegroundColor = .systemPink
        }
        else
        {
            sender.setImage(heartIcon, for: .normal)
            sender.configuration!.baseForegroundColor = tableView.contentOffset.y > 0 ? .label : .white
        }
    }
}
