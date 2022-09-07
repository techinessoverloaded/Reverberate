//
//  LibrarySongViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 19/07/22.
//

import UIKit

class LibrarySongViewController: UITableViewController
{
    private lazy var noResultsMessage: NSAttributedString = {
        let largeTextAttributes: [NSAttributedString.Key : Any] =
        [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 19, weight: .bold),
            NSAttributedString.Key.foregroundColor : UIColor.label
        ]
        let smallerTextAttributes: [NSAttributedString.Key : Any] =
        [
            NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .body),
            NSAttributedString.Key.foregroundColor : UIColor.secondaryLabel
        ]
        var mutableAttrString = NSMutableAttributedString(string: "Couldn't find any result\n\n", attributes: largeTextAttributes)
        mutableAttrString.append(NSMutableAttributedString(string: "Try searching again using a different spelling or keyword.", attributes: smallerTextAttributes))
        return mutableAttrString
    }()
    
    private lazy var emptyMessageLabel: UILabel = {
        let emLabel = UILabel(useAutoLayout: true)
        emLabel.textAlignment = .center
        emLabel.numberOfLines = 4
        emLabel.isHidden = true
        return emLabel
    }()
    
     private lazy var searchController: UISearchController = {
         let libraryResultsVC = LibraryResultsViewController(style: .insetGrouped)
        let sController = UISearchController(searchResultsController: nil)
        sController.searchResultsUpdater = self
        sController.delegate = self
        sController.hidesNavigationBarDuringPresentation = true
        sController.searchBar.placeholder = "Find in Songs"
        return sController
    }()
    
    private lazy var playIcon: UIImage = {
        return UIImage(systemName: "play.fill")!
    }()
    
    private lazy var pauseIcon: UIImage = {
        return UIImage(systemName: "pause.fill")!
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
    
    private lazy var allSongs = DataManager.shared.availableSongs
    
    private lazy var sortedSongs: [Alphabet : [Song]] = {
        var result: [Alphabet : [Song]] = [ : ]
        for alphabet in Alphabet.allCases
        {
            let startingLetter = alphabet.asString
            result[alphabet] = allSongs.filter({ $0.title!.hasPrefix(startingLetter)}).sorted()
        }
        return result
    }()
    
    private lazy var tableHeaderView: UIView = createTableHeaderView()
    
    private lazy var backgroundView: UIView = UIView()
    
    private var filteredSongs: [Alphabet : [Song]] = [:]
    
    private var isSearchBarEmpty: Bool
    {
       return searchController.searchBar.text?.isEmpty ?? true
    }

    private var isFiltering: Bool
    {
       return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "All Songs"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        //setupSortMenu()
        tableView.tableHeaderView = tableHeaderView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        tableView.sectionHeaderTopPadding = 0
        backgroundView.addSubview(emptyMessageLabel)
        NSLayoutConstraint.activate([
            emptyMessageLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            emptyMessageLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            emptyMessageLabel.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.8)
        ])
        emptyMessageLabel.attributedText = noResultsMessage
        tableView.backgroundView = backgroundView
        playButton.addTarget(self, action: #selector(onPlayButtonTap(_:)), for: .touchUpInside)
        shuffleButton.addTarget(self, action: #selector(onShuffleButtonTap(_:)), for: .touchUpInside)
    }

    func createTableHeaderView() -> UIView
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60))
        headerView.addSubview(playButton)
        headerView.addSubview(shuffleButton)
        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            playButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            playButton.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.42),
            shuffleButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            shuffleButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            shuffleButton.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.42),
        ])
        return headerView
    }
    
    
//    func setupSortMenu()
//    {
//        let menuBarItem = UIBarButtonItem(title: "Sort", style: .plain, target: nil, action: nil)
//        menuBarItem.menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [
//            UIAction(title: "Title", image: nil, state: .on, handler: { _ in
//
//            })
//        ])
//        navigationItem.rightBarButtonItem = menuBarItem
//    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    // MARK: - Table view data source and Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 26
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return isFiltering ? filteredSongs[Alphabet(rawValue: section)!]?.count ?? 0 : sortedSongs[Alphabet(rawValue: section)!]!.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let alphabet = Alphabet(rawValue: section)!
        if isFiltering
        {
            return filteredSongs[alphabet]?.isEmpty ?? true ? nil : alphabet.asString
        }
        else
        {
            return sortedSongs[alphabet]!.isEmpty ? nil : alphabet.asString
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]?
    {
        return Alphabet.allCases.map({ $0.asString })
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
    {
        return index
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let section = indexPath.section
        let item = indexPath.item
        let song = isFiltering ? filteredSongs[Alphabet(rawValue: section)!]![item] : sortedSongs[Alphabet(rawValue: section)!]![item]
        var config = cell.defaultContentConfiguration()
        config.text = song.title!
        config.secondaryText = song.getArtistNamesAsString(artistType: nil)
        config.imageProperties.cornerRadius = 10
        config.image = song.coverArt
        config.textProperties.adjustsFontForContentSizeCategory = true
        config.textProperties.allowsDefaultTighteningForTruncation = true
        config.secondaryTextProperties.adjustsFontForContentSizeCategory = true
        config.secondaryTextProperties.color = .secondaryLabel
        config.secondaryTextProperties.allowsDefaultTighteningForTruncation = true
        config.secondaryTextProperties.font = .preferredFont(forTextStyle: .footnote)
        cell.contentConfiguration = config
        var menuButtonConfig = UIButton.Configuration.plain()
        menuButtonConfig.baseForegroundColor = .systemGray
        menuButtonConfig.image = UIImage(systemName: "ellipsis")!
        menuButtonConfig.buttonSize = .medium
        let menuButton = UIButton(configuration: menuButtonConfig)
        menuButton.tag = item
        menuButton.sizeToFit()
        cell.accessoryView = menuButton
        cell.backgroundColor = .clear
        return cell
    }
}

extension LibrarySongViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellWidth = collectionView.bounds.width//(collectionView.bounds.width / 2.3)
        return .init(width: cellWidth, height: 70)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return .init(top: 10, left: 20, bottom: 10, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
}

extension LibrarySongViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        guard let query = searchController.searchBar.text, !query.isEmpty else
        { return }
        filteredSongs = DataProcessor.shared.getSortedSongsThatSatisfy(theQuery: query)
        emptyMessageLabel.isHidden = !filteredSongs.isEmpty
        tableView.reloadData()
    }
}

extension LibrarySongViewController: UISearchControllerDelegate
{
    func willPresentSearchController(_ searchController: UISearchController)
    {
        tableView.tableHeaderView = nil
    }
    
    func didPresentSearchController(_ searchController: UISearchController)
    {
        tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    func willDismissSearchController(_ searchController: UISearchController)
    {
        emptyMessageLabel.isHidden = true
        tableView.tableHeaderView = tableHeaderView
    }
    
    func didDismissSearchController(_ searchController: UISearchController)
    {
        tableView.reloadData()
        filteredSongs = [:]
    }
}
extension LibrarySongViewController
{
    @objc func onPlayButtonTap(_ sender: UIButton)
    {
        if sender.configuration!.title == "Play"
        {
            print("Gonna Play")
//           delegate?.onPlaylistPlayRequest(playlist: playlist)
            sender.configuration!.title = "Pause"
            sender.configuration!.image = pauseIcon
        }
        else
        {
            print("Gonna Pause")
//            delegate?.onPlaylistPauseRequest(playlist: playlist)
            sender.configuration!.title = "Play"
            sender.configuration!.image = playIcon
        }
    }
    
    @objc func onShuffleButtonTap(_ sender: UIButton)
    {
        
    }
}