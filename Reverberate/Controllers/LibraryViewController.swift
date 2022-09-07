//
//  LibraryViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//

import UIKit

class LibraryViewController: UITableViewController
{
    private let reverberateLibTitleLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.textAlignment = .left
        uiLabel.font = .preferredFont(forTextStyle: .footnote)
        uiLabel.textColor = .secondaryLabel
        uiLabel.text = " REVERBERATE LIBRARY"
        return uiLabel
    }()
    
    private let yourLibTitleLabel: UILabel = {
        let upLabel = UILabel()
        upLabel.textAlignment = .left
        upLabel.font = .preferredFont(forTextStyle: .footnote)
        upLabel.textColor = .secondaryLabel
        upLabel.text = " YOUR LIBRARY"
        return upLabel
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
//        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
        tableView.sectionHeaderTopPadding = 0
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 70, right: 0)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Table view data source and delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return section == 0 ? reverberateLibTitleLabel : yourLibTitleLabel
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let section = indexPath.section
        let item = indexPath.item
        if section == 0
        {
            var cellConfig = cell.defaultContentConfiguration()
            if item == 0
            {
                cellConfig.text = "All Songs"
                cellConfig.image = UIImage(systemName: "music.note")!
            }
            else if item == 1
            {
                cellConfig.text = "All Albums"
                cellConfig.image = UIImage(systemName: "square.stack")!
            }
            else
            {
                cellConfig.text = "All Artists"
                cellConfig.image = UIImage(systemName: "music.mic")!
            }
            cell.contentConfiguration = cellConfig
        }
        else
        {
            var cellConfig = cell.defaultContentConfiguration()
            if item == 0
            {
                cellConfig.text = "Your Favourite Songs"
                cellConfig.image = UIImage(systemName: "music.note")!
            }
            else if item == 1
            {
                cellConfig.text = "Your Favourite Playlists"
                cellConfig.image = UIImage(systemName: "music.note.list")!
            }
            else
            {
                cellConfig.text = "Your Favourite Artists"
                cellConfig.image = UIImage(systemName: "music.mic")!
            }
            cell.contentConfiguration = cellConfig
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let section = indexPath.section
        let item = indexPath.item
        tableView.deselectRow(at: indexPath, animated: true)
        if section == 0
        {
            if item == 0
            {
                navigationController?.pushViewController(LibrarySongViewController(style: .plain), animated: true)
            }
            else if item == 1
            {
                navigationController?.pushViewController(LibraryAlbumViewController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
            }
            else
            {
                navigationController?.pushViewController(LibraryArtistViewController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
            }
        }
        else
        {
            
        }
    }
}

extension LibraryViewController
{
    
}

extension LibraryViewController: UISearchControllerDelegate
{
    func willDismissSearchController(_ searchController: UISearchController)
    {
        
    }
}
