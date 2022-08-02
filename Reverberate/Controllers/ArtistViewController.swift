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
        config.buttonSize = .large
        let favButton = UIButton(configuration: config)
        favButton.setImage(heartIcon, for: .normal)
        return favButton
    }()
    
    private lazy var playButton: UIButton = {
        let pButton = UIButton(type: .roundedRect)
        pButton.backgroundColor = UIColor(named: GlobalConstants.darkGreenColor)!
        pButton.tintColor = .white
        pButton.setTitle("Play All", for: .normal)
        pButton.setImage(playIcon, for: .normal)
        pButton.layer.cornerRadius = 20
        pButton.enableAutoLayout()
        pButton.clipsToBounds = true
        return pButton
    }()
    
    private lazy var playButtonHeaderView: UIView = {
        let pbView = UIView()
        pbView.backgroundColor = .clear
        return pbView
    }()
    
    private lazy var songs = Array(artist.contributedSongs!)

    private lazy var albums = DataProcessor.shared.getAlbumsInvolving(artist: artist.name!)
    
    var artist: ArtistWrapper!
    
    weak var delegate: ArtistDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .clear
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favouriteButton)
        navigationItem.largeTitleDisplayMode = .never
        tableView.backgroundColor = .systemGroupedBackground
        tableView.contentInsetAdjustmentBehavior = .scrollableAxes
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        let headerView = StretchyArtistHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 300))
        headerView.setDetails(artistName: artist.name!, artistType: artist.getArtistTypesAsString(), artistPhoto: artist.photo!)
        tableView.tableHeaderView = headerView
        tableView.allowsMultipleSelection = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        //tableView.sectionHeaderTopPadding = 0
        favouriteButton.addTarget(self, action: #selector(onFavouriteButtonTap(_:)), for: .touchUpInside)
//        playButtonHeaderView.addSubview(playButton)
//        NSLayoutConstraint.activate([
//            playButton.heightAnchor.constraint(equalTo: playButtonHeaderView.heightAnchor),
//            playButton.widthAnchor.constraint(equalTo: playButtonHeaderView.widthAnchor, multiplier: 1),
//            playButton.topAnchor.constraint(equalTo: playButtonHeaderView.topAnchor),
//            playButton.centerXAnchor.constraint(equalTo: playButtonHeaderView.centerXAnchor)
//        ])
        songs.append(contentsOf: Array(artist.contributedSongs!))
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
            tableView.contentOffset.y > 0 ? headerView.changeAlphaOfSubviews(newAlphaValue: 0) : headerView.changeAlphaOfSubviews(newAlphaValue: 1)
            print(self.tableView.contentOffset.y)
            self.navigationItem.title = tableView.contentOffset.y > -89 ? artist.name! : nil
            self.navigationController?.navigationBar.tintColor = tableView.contentOffset.y > -89 ? .systemBlue : .white
            if favouriteButton.image(for: .normal)!.pngData() == heartIcon.pngData()
            {
                favouriteButton.configuration!.baseForegroundColor = tableView.contentOffset.y > -89 ? .label : .white
            }
        }, completion: nil)
    }
}

extension ArtistViewController
{
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
