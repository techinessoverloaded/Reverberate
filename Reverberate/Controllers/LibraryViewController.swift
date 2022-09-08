//
//  LibraryViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//

import UIKit

class LibraryViewController: UITableViewController
{
    private var userMessage: String
    {
        get
        {
            return SessionManager.shared.isUserLoggedIn ? "Find your favourite Songs, Albums, Artists, Playlists and Reverberate's Whole Collection" : "Find Reverberate's Whole Collection of Songs, Albums, Artists and Playlists"
        }
    }
    
    private lazy var userMessageLabel: UILabel =
    {
        let umLabel = UILabel(useAutoLayout: true)
        umLabel.text = userMessage
        umLabel.font = .preferredFont(forTextStyle: .body, weight: .regular)
        umLabel.textColor = .secondaryLabel
        umLabel.textAlignment = .left
        umLabel.numberOfLines = 3
        return umLabel
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
//        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60))
        headerView.backgroundColor = .clear
        headerView.addSubview(userMessageLabel)
        NSLayoutConstraint.activate([
            userMessageLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            userMessageLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            userMessageLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        tableView.tableHeaderView = headerView
        tableView.sectionHeaderTopPadding = 0
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 70, right: 0)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(onUserLoginNotification(_:)), name: .userLoggedInNotification, object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: .userLoggedInNotification, object: nil)
    }
    
    // MARK: - Table view data source and delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return SessionManager.shared.isUserLoggedIn ? 4 : 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = indexPath.item
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
        else if item == 2
        {
            cellConfig.text = "All Artists"
            cellConfig.image = UIImage(systemName: "music.mic")!
        }
        else
        {
            if SessionManager.shared.isUserLoggedIn
            {
                cellConfig.text = "Favourite Playlists"
                cellConfig.image = UIImage(systemName: "music.note.list")!
            }
        }
        cell.contentConfiguration = cellConfig
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let item = indexPath.item
        tableView.deselectRow(at: indexPath, animated: true)
        if item == 0
        {
            navigationController?.pushViewController(LibrarySongViewController(style: .plain), animated: true)
        }
        else if item == 1
        {
            navigationController?.pushViewController(LibraryAlbumViewController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
        }
        else if item == 2
        {
            navigationController?.pushViewController(LibraryArtistViewController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
        }
        else
        {
            if SessionManager.shared.isUserLoggedIn
            {
                
            }
        }
    }
}

extension LibraryViewController
{
    @objc func onUserLoginNotification(_ notification: NSNotification)
    {
        print("Logged in")
        tableView.reloadData()
    }
}

extension LibraryViewController: UISearchControllerDelegate
{
    func willDismissSearchController(_ searchController: UISearchController)
    {
        
    }
}
