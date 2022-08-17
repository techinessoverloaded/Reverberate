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
    
    var playlist: Playlist!
    
    private lazy var playlistSearchController: UISearchController = {
        let sResultController = PlaylistResultsViewController(style: .plain)
        let sController = UISearchController(searchResultsController: sResultController)
        sController.searchResultsUpdater = sResultController
        sController.searchBar.delegate = self
        sController.showsSearchResultsController = true
        sController.hidesNavigationBarDuringPresentation = true
        sController.popoverPresentationController?.backgroundColor = .clear
        return sController
    }()
    
    private lazy var posterView: UIImageView = {
        let pView = UIImageView(useAutoLayout: true)
        pView.isUserInteractionEnabled = true
        pView.contentMode = .scaleAspectFill
        pView.image = UIImage(named: "glassmorphic_bg")!
        pView.layer.cornerRadius = 10
        pView.layer.cornerCurve = .continuous
        pView.clipsToBounds = true
        return pView
    }()
    
    private var searchButton: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
//        navigationItem.searchController = playlistSearchController
//        navigationItem.hidesSearchBarWhenScrolling = true
        searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(onSearchButtonTap(_:)))
        navigationItem.rightBarButtonItems = [searchButton]
        setPlaylistDetails()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 70, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.definesPresentationContext = true
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        self.definesPresentationContext = false
    }
    
    func setPlaylistDetails()
    {
        if playlist is Album
        {
            let album = playlist as! Album
            title = album.name!
            navigationItem.title = nil
            self.playlistSearchController.searchBar.placeholder = "Find in Album"
            posterView.image = album.coverArt!
//            let headerView = StretchyHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 260))
//            headerView.setDetails(title: album.name!, subtitle: "\(album.getComposersNameAsString()) · \(album.releaseDate!.get(.year))", photo: album.coverArt!, backgroundImage: album.coverArt!.averageColour!.image())
//            tableView.tableHeaderView = headerView
        }
        else
        {
            title = playlist.name!
            navigationItem.title = nil
            self.playlistSearchController.searchBar.placeholder = "Find in Playlist"
//            let headerView = StretchyHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 260))
//            headerView.setDetails(title: playlist.name!, subtitle: nil, photo: nil, backgroundImage: UIImage())
//            tableView.tableHeaderView = headerView
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? 1 : playlist.songs!.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let section = indexPath.section
        return section == 0 ? (isIpad ? 350 : 250) : 90
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = indexPath.section
        let item = indexPath.item
        if section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
            if item == 0
            {
                cell.addSubViewToContentView(posterView, useAutoLayout: true, useClearBackground: true)
            }
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var config = cell.defaultContentConfiguration()
            let song = playlist.songs![item]
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
            var favBtnconfig = UIButton.Configuration.plain()
            favBtnconfig.baseForegroundColor = .label
            favBtnconfig.buttonSize = .medium
            let favButton = UIButton(configuration: favBtnconfig)
            favButton.setImage(heartIcon, for: .normal)
            favButton.sizeToFit()
            favButton.tag = item
            favButton.addTarget(self, action: #selector(onSongFavouriteButtonTap(_:)), for: .touchUpInside)
            cell.accessoryView = favButton
            //cell.backgroundColor = .clear
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        return indexPath.section != 0 ? indexPath : nil
    }
}

extension PlaylistViewController: UISearchBarDelegate
{
    
}

extension PlaylistViewController
{
//    override func scrollViewDidScroll(_ scrollView: UIScrollView)
//    {
//        let headerView = tableView.tableHeaderView as! StretchyHeaderView
//        headerView.scrollViewDidScroll(scrollView: tableView)
//        UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: {
//            [unowned self] in
//            headerView.changeAlphaOfSubviews(newAlphaValue: 1-(tableView.contentOffset.y / headerView.bounds.height))
//            print("Alpha : \(1-(tableView.contentOffset.y / headerView.bounds.height))")
//            print(self.tableView.contentOffset.y)
//            self.navigationItem.title = tableView.contentOffset.y >= 0 ? title : nil
//            //self.navigationController?.navigationBar.tintColor = tableView.contentOffset.y >= 0 ? .systemBlue : .white
////            if favouriteButton.image(for: .normal)!.pngData() == heartIcon.pngData()
////            {
////                favouriteButton.configuration!.baseForegroundColor = tableView.contentOffset.y >= 0 ? .label : .white
////            }
////            playButton.configuration!.baseForegroundColor = tableView.contentOffset.y >= 0 ? .label : .white
//        }, completion: nil)
//    }
}

extension PlaylistViewController
{
    @objc func onSearchButtonTap(_ sender: UIBarButtonItem)
    {
        self.present(playlistSearchController, animated: true)
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
}
