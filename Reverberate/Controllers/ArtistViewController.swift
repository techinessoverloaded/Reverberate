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
    
    private lazy var playButton: UIButton = {
        let pButton = UIButton(type: .roundedRect)
        pButton.backgroundColor = UIColor(named: GlobalConstants.darkGreenColor)!
        pButton.tintColor = .white
        pButton.setTitle("Play All", for: .normal)
        pButton.setImage(playIcon, for: .normal)
        pButton.layer.cornerRadius = 30
        //pButton.enableAutoLayout()
        pButton.clipsToBounds = true
        return pButton
    }()
    
//    private lazy var playButtonHeaderView: UIView = {
//        let pbView = UIView()
//        pbView.backgroundColor = .clear
//        return pbView
//    }()
    
    private lazy var artistPhotoView: UIImageView = {
        let apView = UIImageView(useAutoLayout: true)
        apView.isUserInteractionEnabled = true
        apView.contentMode = .scaleAspectFill
        apView.image = UIImage(named: "glassmorphic_bg")!
        apView.layer.cornerRadius = 10
        apView.layer.cornerCurve = .continuous
        apView.layer.borderColor = UIColor(named: GlobalConstants.techinessColor)!.cgColor
        apView.layer.borderWidth = 4
        apView.clipsToBounds = true
        return apView
    }()
    
    private lazy var artistNameView: UILabel = {
        let anView = UILabel(useAutoLayout: true)
        anView.textColor = .label
        anView.font = .preferredFont(forTextStyle: .title2, weight: .bold)
        anView.numberOfLines = 2
        anView.lineBreakMode = .byTruncatingTail
        anView.isUserInteractionEnabled = true
        anView.textAlignment = .center
        return anView
    }()
    
    private lazy var songs = Array(artist.contributedSongs!)

    private lazy var albums = DataProcessor.shared.getAlbumsInvolving(artist: artist.name!)
    
    var artist: ArtistWrapper!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .clear
        tableView.backgroundColor = .systemGroupedBackground
        tableView.contentInsetAdjustmentBehavior = .scrollableAxes
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
//        let headerView = StretchyTableHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 250))
//        headerView.imageView.image = UIImage(named: "glassmorphic_bg")!
//        headerView.titleView.text = artist.name!
        //tableView.tableHeaderView = UIImageView(image: UIImage(named: "dark_gradient_bg")!)
        tableView.allowsMultipleSelection = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        songs.append(contentsOf: Array(artist.contributedSongs!))
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 3
        }
        else if section == 1
        {
            return songs.count
        }
        else
        {
            return albums.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let item = indexPath.item
        let section = indexPath.section
        if section == 0
        {
            if item == 0
            {
                return 50
            }
            else if item == 1
            {
                return 200
            }
            else
            {
                return 40
            }
        }
        else
        {
            return 90
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if section == 1
        {
            return "Songs Featuring \(artist.name!)"
        }
        else if section == 2
        {
            return "Albums Featuring \(artist.name!)"
        }
        else
        {
            return nil
        }
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
                artistNameView.text = artist.name!
                cell.addSubViewToContentView(artistNameView, useAutoLayout: true)
            }
            else if item == 1
            {
                artistPhotoView.image = artist.photo!
                cell.addSubViewToContentView(artistPhotoView, useAutoLayout: true)
            }
            else
            {
                cell.addSubViewToContentView(playButton, useAutoLayout: false)
            }
            return cell
        }
        else if section == 1
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
        if section == 1
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
//    override func scrollViewDidScroll(_ scrollView: UIScrollView)
//    {
//        let headerView = tableView.tableHeaderView as! StretchyTableHeaderView
//        headerView.scrollViewDidScroll(scrollView: tableView)
//        UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: {
//            [unowned self] in
//            headerView.titleView.alpha = tableView.contentOffset.y > 0 ? 0 : 1
//            self.navigationItem.title = tableView.contentOffset.y > 0 ? artist.name! : nil
//            self.navigationController?.navigationBar.tintColor = tableView.contentOffset.y > 0 ? .systemBlue : .white
//        }, completion: nil)
//    }
}

extension ArtistViewController
{
    @objc func onCloseButtonTap(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true)
    }
}
