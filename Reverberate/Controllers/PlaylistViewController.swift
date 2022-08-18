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
    
    private lazy var titleView: UILabel = {
        let tView = UILabel(useAutoLayout: true)
        tView.font = .preferredFont(forTextStyle: .title1, weight: .semibold)
        tView.textColor = .label
        tView.textAlignment = .center
        tView.numberOfLines = 2
        return tView
    }()
    
    private lazy var artistView: UILabel = {
        let aView = UILabel(useAutoLayout: true)
        aView.font = .preferredFont(forTextStyle: .body, weight: .regular)
        aView.textColor = UIColor(named: GlobalConstants.techinessColor)!
        aView.textAlignment = .center
        aView.isUserInteractionEnabled = true
        return aView
    }()
    
    private lazy var detailsView: UILabel = {
        let dView = UILabel(useAutoLayout: true)
        dView.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        dView.textColor = .secondaryLabel
        dView.textAlignment = .center
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
    
    private lazy var playlistFavouriteButton: UIButton = {
        let favButton = UIButton(type: .system)
        favButton.setImage(heartIcon, for: .normal)
        favButton.tintColor = .label
        favButton.enableAutoLayout()
        favButton.contentVerticalAlignment = .fill
        favButton.contentHorizontalAlignment = .fill
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
    
    var playlist: Playlist!
    
    private var defaultOffset: CGFloat = 0.0
    
    private var defaultPosterHeight: CGFloat = 0.0
    
    private var searchButton: UIBarButtonItem!
    
    private var headerView: UIView!
    
    private lazy var tableHeaderHeight: CGFloat = isIpad ? 560 : 460
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
//        navigationItem.searchController = playlistSearchController
//        navigationItem.hidesSearchBarWhenScrolling = true
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableHeaderHeight, height: tableHeaderHeight))
        headerView.addSubview(posterView)
        headerView.addSubview(titleView)
        headerView.addSubview(artistView)
        headerView.addSubview(detailsView)
        headerView.addSubview(playlistFavouriteButton)
        headerView.addSubview(playButton)
        headerView.addSubview(shuffleButton)
        NSLayoutConstraint.activate([
            playlistFavouriteButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            playlistFavouriteButton.leadingAnchor.constraint(equalTo: posterView.trailingAnchor),
            posterView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            posterView.topAnchor.constraint(equalTo: playlistFavouriteButton.bottomAnchor),
            posterView.heightAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: 0.6),
            posterView.widthAnchor.constraint(equalTo: posterView.heightAnchor),
            titleView.topAnchor.constraint(equalTo: posterView.bottomAnchor, constant: 10),
            titleView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            artistView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 2),
            artistView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            detailsView.topAnchor.constraint(equalTo: artistView.bottomAnchor, constant: 3),
            detailsView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            playButton.trailingAnchor.constraint(equalTo: headerView.centerXAnchor, constant: -10),
            playButton.topAnchor.constraint(equalTo: detailsView.bottomAnchor, constant: 10),
            playButton.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.4),
            shuffleButton.leadingAnchor.constraint(equalTo: headerView.centerXAnchor, constant: 10),
            shuffleButton.topAnchor.constraint(equalTo: detailsView.bottomAnchor, constant: 10),
            shuffleButton.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.4)
        ])
        headerView.backgroundColor = .clear
        tableView.tableHeaderView = headerView
        defaultPosterHeight = headerView.bounds.height * 0.6
        setPlaylistDetails()
        playlistFavouriteButton.addTarget(self, action: #selector(onArtistFavouriteButtonTap(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.definesPresentationContext = true
        self.navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        defaultOffset = tableView.contentOffset.y
        print("Default Offset: \(defaultOffset)")
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
    
    func setPlaylistDetails()
    {
        if playlist is Album
        {
            let album = playlist as! Album
            title = album.name!
            navigationItem.title = nil
            posterView.image = album.coverArt!
            titleView.text = title
            artistView.text = "\(album.composerNames) ›"
            detailsView.text = "\(album.language) · \(album.releaseDate!.getFormattedString())"
            artistTapRecognizer.addTarget(self, action: #selector(onArtistTap(_:)))
            artistView.addGestureRecognizer(artistTapRecognizer)
            posterTapRecognizer.addTarget(self, action: #selector(onPosterDoubleTap(_:)))
            posterView.addGestureRecognizer(posterTapRecognizer)
//            let headerView = StretchyHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 260))
//            headerView.setDetails(title: album.name!, subtitle: "\(album.getComposersNameAsString()) · \(album.releaseDate!.get(.year))", photo: album.coverArt!, backgroundImage: album.coverArt!.averageColour!.image())
//            tableView.tableHeaderView = headerView
        }
        else
        {
            title = playlist.name!
            navigationItem.title = nil
            titleView.text = title
//            let headerView = StretchyHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 260))
//            headerView.setDetails(title: playlist.name!, subtitle: nil, photo: nil, backgroundImage: UIImage())
//            tableView.tableHeaderView = headerView
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
        favButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cell.accessoryView = favButton
        cell.backgroundColor = .clear
        return cell
    }
}

extension PlaylistViewController: UISearchBarDelegate
{
    
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
            sender.configuration!.baseForegroundColor = .label
        }
    }
    
    @objc func onArtistFavouriteButtonTap(_ sender: UIButton)
    {
        if sender.image(for: .normal)!.pngData() == heartIcon.pngData()
        {
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
        self.navigationController?.pushViewController(artistVc, animated: true)
    }
    
    @objc func onPosterDoubleTap(_ sender: UITapGestureRecognizer)
    {
        playlistFavouriteButton.sendActions(for: .touchUpInside)
    }
}

extension PlaylistViewController : UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        
    }
}
