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

    private lazy var favouriteButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .white
        config.buttonSize = .medium
        let favButton = UIButton(configuration: config)
        favButton.setImage(heartIcon, for: .normal)
        return favButton
    }()
    
    private lazy var playButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .white
        config.buttonSize = .medium
        config.image = UIImage(systemName: "play.fill")!
        config.imagePadding = 10
        let pButton = UIButton(configuration: config)
//        favButton.setImage(heartIcon, for: .normal)
        return pButton
    }()
    
    private lazy var seeAllSongsButton: UIButton = {
        let saButton = UIButton(type: .system)
        saButton.setTitle("See All Songs", for: .normal)
        saButton.enableAutoLayout()
        return saButton
    }()
    
    private lazy var seeAllAlbumsButton: UIButton = {
        let saaButton = UIButton(type: .system)
        saaButton.setTitle("See All Albums", for: .normal)
        saaButton.enableAutoLayout()
        return saaButton
    }()
    
    private lazy var songs = Array(artist.contributedSongs!)

    private lazy var albums = DataProcessor.shared.getAlbumsInvolving(artist: artist.name!)
    
    private lazy var minimumVisibleSongsCount: Int = min(songs.count, 5)
    
    private lazy var minimumVisibleAlbumsCount: Int = min(albums.count, 5)
    
    private lazy var shouldSeeAllSongs: Bool = false
    
    private lazy var shouldSeeAllAlbums: Bool = false
    
    var artist: Artist!
    
    weak var delegate: ArtistDelegate?
    
    private var user: User!
    
    private lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private lazy var contextSaveAction = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .clear
        //navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favouriteButton)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: playButton), UIBarButtonItem(customView: favouriteButton)]
        
        navigationItem.largeTitleDisplayMode = .never
        tableView.backgroundColor = .systemGroupedBackground
        tableView.contentInsetAdjustmentBehavior = .scrollableAxes
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        let headerView = StretchyArtistHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 260))
        headerView.setDetails(artistName: artist.name!, artistType: artist.getArtistTypesAsString(), artistPhoto: artist.photo!)
        tableView.tableHeaderView = headerView
        tableView.allowsMultipleSelection = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        //tableView.sectionHeaderTopPadding = 0
        favouriteButton.addTarget(self, action: #selector(onFavouriteButtonTap(_:)), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(onShufflePlayButtonTap(_:)), for: .touchUpInside)
        seeAllSongsButton.addTarget(self, action: #selector(onSeeAllSongsButtonTap(_:)), for: .touchUpInside)
        seeAllAlbumsButton.addTarget(self, action: #selector(onSeeAllAlbumsButtonTap(_:)), for: .touchUpInside)
//        playButtonHeaderView.addSubview(playButton)
//        NSLayoutConstraint.activate([
//            playButton.heightAnchor.constraint(equalTo: playButtonHeaderView.heightAnchor),
//            playButton.widthAnchor.constraint(equalTo: playButtonHeaderView.widthAnchor, multiplier: 1),
//            playButton.topAnchor.constraint(equalTo: playButtonHeaderView.topAnchor),
//            playButton.centerXAnchor.constraint(equalTo: playButtonHeaderView.centerXAnchor)
//        ])
        songs.append(contentsOf: Array(artist.contributedSongs!))
        fetchUser()
    }
    
    func fetchUser()
    {
        user = try! context.fetch(User.fetchRequest()).first {
            $0.id == UserDefaults.standard.string(forKey: GlobalConstants.currentUserId)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return section == 0 ? (shouldSeeAllSongs ? songs.count : minimumVisibleSongsCount) : (shouldSeeAllAlbums ? albums.count : minimumVisibleAlbumsCount)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
//        let item = indexPath.item
//        let section = indexPath.section
        return 90
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        if section == 0
//        {
//            return playButtonHeaderView
//        }
//        else
//        {
//            return nil
//        }
//    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        if section == 0
        {
            if songs.count == minimumVisibleSongsCount
            {
                return nil
            }
            else
            {
                let footerView = UITableViewHeaderFooterView()
                footerView.backgroundColor = .clear
                footerView.contentView.addSubview(seeAllSongsButton)
                NSLayoutConstraint.activate([
                    seeAllSongsButton.heightAnchor.constraint(equalTo: footerView.contentView.heightAnchor),
                    seeAllSongsButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor)
                ])
                return footerView
            }
        }
        else
        {
            if albums.count == minimumVisibleAlbumsCount
            {
                return nil
            }
            else
            {
                let footerView = UITableViewHeaderFooterView()
                footerView.backgroundColor = .clear
                footerView.contentView.addSubview(seeAllAlbumsButton)
                NSLayoutConstraint.activate([
                    seeAllAlbumsButton.heightAnchor.constraint(equalTo: footerView.contentView.heightAnchor),
                    seeAllAlbumsButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor)
                ])
                return footerView
            }
        }
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
            config.image = song.coverArt!
            config.textProperties.adjustsFontForContentSizeCategory = true
            config.textProperties.allowsDefaultTighteningForTruncation = true
            config.secondaryTextProperties.adjustsFontForContentSizeCategory = true
            config.secondaryTextProperties.color = .secondaryLabel
            config.secondaryTextProperties.allowsDefaultTighteningForTruncation = true
            config.secondaryTextProperties.font = .preferredFont(forTextStyle: .footnote)
            cell.contentConfiguration = config
            cell.selectionStyle = .none
            var favBtnconfig = UIButton.Configuration.plain()
            favBtnconfig.baseForegroundColor = .label
            favBtnconfig.buttonSize = .medium
            let favButton = UIButton(configuration: favBtnconfig)
            favButton.setImage(heartIcon, for: .normal)
            favButton.sizeToFit()
            favButton.tag = item
            favButton.addTarget(self, action: #selector(onSongFavouriteButtonTap(_:)), for: .touchUpInside)
            cell.accessoryView = favButton
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var config = cell.defaultContentConfiguration()
            let album = albums[item]
            config.text = album.name!
            config.secondaryText = "\(album.getComposersNameAsString()) · \(album.releaseDate!.get(.year))"
            config.imageProperties.cornerRadius = 10
            config.image = album.coverArt!
            config.textProperties.adjustsFontForContentSizeCategory = true
            config.textProperties.allowsDefaultTighteningForTruncation = true
            config.secondaryTextProperties.adjustsFontForContentSizeCategory = true
            config.secondaryTextProperties.color = .secondaryLabel
            config.secondaryTextProperties.allowsDefaultTighteningForTruncation = true
            config.secondaryTextProperties.font = .preferredFont(forTextStyle: .footnote)
            cell.contentConfiguration = config
            cell.selectionStyle = .none
            var favBtnconfig = UIButton.Configuration.plain()
            favBtnconfig.baseForegroundColor = .label
            favBtnconfig.buttonSize = .medium
            let favButton = UIButton(configuration: favBtnconfig)
            favButton.setImage(heartIcon, for: .normal)
            favButton.sizeToFit()
            favButton.tag = item
            favButton.addTarget(self, action: #selector(onAlbumFavouriteButtonTap(_:)), for: .touchUpInside)
            cell.accessoryView = favButton
            return cell
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
                let cell = tableView.cellForRow(at: indexPath)
                cell?.backgroundColor = .systemFill
            }
        }
        else
        {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .secondarySystemGroupedBackground
    }
}

extension ArtistViewController
{
    override func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let headerView = tableView.tableHeaderView as! StretchyArtistHeaderView
        headerView.scrollViewDidScroll(scrollView: tableView)
        UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: {
            [unowned self] in
            headerView.changeAlphaOfSubviews(newAlphaValue: 1-(tableView.contentOffset.y / headerView.bounds.height))
            print("Alpha : \(1-(tableView.contentOffset.y / headerView.bounds.height))")
            print(self.tableView.contentOffset.y)
            self.navigationItem.title = tableView.contentOffset.y >= 0 ? artist.name! : nil
            self.navigationController?.navigationBar.tintColor = tableView.contentOffset.y >= 0 ? .systemBlue : .white
            if favouriteButton.image(for: .normal)!.pngData() == heartIcon.pngData()
            {
                favouriteButton.configuration!.baseForegroundColor = tableView.contentOffset.y >= 0 ? .label : .white
            }
            playButton.configuration!.baseForegroundColor = tableView.contentOffset.y >= 0 ? .label : .white
        }, completion: nil)
    }
}

extension ArtistViewController
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
        print("Request to favourite song at: \(sender.tag)")
        let song = songs[sender.tag]
        if sender.image(for: .normal)!.pngData() == heartIcon.pngData()
        {
            if user.favSongs == nil
            {
                user.favSongs = []
            }
            user.favSongs!.appendUniquely(song)
            contextSaveAction()
            print(user)
            sender.setImage(heartFilledIcon, for: .normal)
            sender.configuration!.baseForegroundColor = .systemPink
        }
        else
        {
            user.favSongs!.removeUniquely(song)
            contextSaveAction()
            print(user)
            sender.setImage(heartIcon, for: .normal)
            sender.configuration!.baseForegroundColor = .label
        }
    }
    
    @objc func onAlbumFavouriteButtonTap(_ sender: UIButton)
    {
        print("Request to favourite album at: \(sender.tag)")
        if sender.image(for: .normal)!.pngData() == heartIcon.pngData()
        {
            sender.setImage(heartFilledIcon, for: .normal)
            sender.configuration!.baseForegroundColor = .systemPink
        }
        else
        {
            sender.setImage(heartIcon, for: .normal)
            sender.configuration!.baseForegroundColor = .label
        }
    }
    
    @objc func onSeeAllSongsButtonTap(_ sender: UIButton)
    {
        if sender.title(for: .normal)! == "See All Songs"
        {
            shouldSeeAllSongs = true
            tableView.reloadSections(IndexSet(integer: 0), with: .top, onCompletion: {
                [unowned self] in
                self.tableView.scrollToRow(at: IndexPath(item: songs.endIndex - 1, section: 0), at: .bottom, animated: true)
                sender.setTitle("See Less Songs", for: .normal)
            })
        }
        else
        {
            shouldSeeAllSongs = false
            tableView.reloadSections(IndexSet(integer: 0), with: .top, onCompletion: { [unowned self] in
                self.tableView.scrollToRow(at: IndexPath(item: minimumVisibleSongsCount - 1, section: 0), at: .bottom, animated: true)
                sender.setTitle("See All Songs", for: .normal)
            })
        }
    }
    
    @objc func onSeeAllAlbumsButtonTap(_ sender: UIButton)
    {
        if sender.title(for: .normal)! == "See All Albums"
        {
            shouldSeeAllAlbums = true
            tableView.reloadSections(IndexSet(integer: 1), with: .top, onCompletion: { [unowned self] in
                self.tableView.scrollToRow(at: IndexPath(item: albums.endIndex - 1, section: 1), at: .bottom, animated: true)
                sender.setTitle("See Less Albums", for: .normal)
            })
        }
        else
        {
            shouldSeeAllAlbums = false
            tableView.reloadSections(IndexSet(integer: 1), with: .top, onCompletion:
            { [unowned self] in
                self.tableView.scrollToRow(at: IndexPath(item: minimumVisibleAlbumsCount - 1, section: 1), at: .bottom, animated: true)
                sender.setTitle("See All Albums", for: .normal)
            })
        }
    }
    
    @objc func onFavouriteButtonTap(_ sender: UIButton)
    {
        if sender.image(for: .normal)!.pngData() == heartIcon.pngData()
        {
            delegate?.onFavouriteButtonTap(artist: artist, shouldMakeAsFavourite: true)
            sender.setImage(heartFilledIcon, for: .normal)
            sender.configuration!.baseForegroundColor = .systemPink
        }
        else
        {
            delegate?.onFavouriteButtonTap(artist: artist, shouldMakeAsFavourite: false)
            sender.setImage(heartIcon, for: .normal)
            sender.configuration!.baseForegroundColor = tableView.contentOffset.y > 0 ? .label : .white
        }
    }
}
