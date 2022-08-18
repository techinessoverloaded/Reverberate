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
            var favBtnconfig = UIButton.Configuration.plain()
            favBtnconfig.baseForegroundColor = .label
            favBtnconfig.buttonSize = .medium
            let favButton = UIButton(configuration: favBtnconfig)
            favButton.setImage(heartIcon, for: .normal)
            favButton.sizeToFit()
            favButton.tag = item
            favButton.addTarget(self, action: #selector(onSongFavouriteButtonTap(_:)), for: .touchUpInside)
            cell.accessoryView = favButton
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
            var favBtnconfig = UIButton.Configuration.plain()
            favBtnconfig.baseForegroundColor = .label
            favBtnconfig.buttonSize = .medium
            let favButton = UIButton(configuration: favBtnconfig)
            favButton.setImage(heartIcon, for: .normal)
            favButton.sizeToFit()
            favButton.tag = item
            favButton.addTarget(self, action: #selector(onAlbumFavouriteButtonTap(_:)), for: .touchUpInside)
            cell.accessoryView = favButton
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
    
    @objc func onSongFavouriteButtonTap(_ sender: UIButton)
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
