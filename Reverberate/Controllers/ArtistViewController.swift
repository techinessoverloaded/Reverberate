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
    
    lazy var playButton: UIButton = {
        let pButton = UIButton(type: .roundedRect)
        pButton.backgroundColor = UIColor(named: GlobalConstants.darkGreenColor)!
        pButton.tintColor = .white
        pButton.enableAutoLayout()
        pButton.clipsToBounds = false
        pButton.layer.cornerRadius = 40
        return pButton
    }()
    
    private lazy var songs = Array(artist.contributedSongs!)

    var artist: ArtistWrapper!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(onCloseButtonTap(_:)))
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .clear
        view.backgroundColor = .clear
        tableView.backgroundColor = .systemGroupedBackground
        tableView.contentInsetAdjustmentBehavior = .scrollableAxes
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        let headerView = StretchyTableHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 300))
        headerView.imageView.image = artist.photo!
        headerView.titleView.text = artist.name!
        tableView.tableHeaderView = headerView
        tableView.allowsMultipleSelection = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        songs.append(contentsOf: Array(artist.contributedSongs!))
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return songs.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        90
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let item = indexPath.item
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let item = indexPath.item
        let song = songs[item]
        if GlobalVariables.shared.currentSong != song
        {
            GlobalVariables.shared.currentSong = song
            let cell = tableView.cellForRow(at: indexPath)
            cell?.backgroundColor = .systemFill
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
        let headerView = tableView.tableHeaderView as! StretchyTableHeaderView
        headerView.scrollViewDidScroll(scrollView: tableView)
        UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: {
            [unowned self] in
            headerView.titleView.alpha = tableView.contentOffset.y > 0 ? 0 : 1
            self.navigationItem.title = tableView.contentOffset.y > 0 ? artist.name! : nil
            self.navigationController?.navigationBar.tintColor = tableView.contentOffset.y > 0 ? .systemBlue : .white
        }, completion: nil)
    }
}

extension ArtistViewController
{
    @objc func onCloseButtonTap(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true)
    }
}
