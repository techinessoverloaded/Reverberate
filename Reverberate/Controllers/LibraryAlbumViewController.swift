//
//  LibraryAlbumViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 07/09/22.
//

import UIKit

class LibraryAlbumViewController: UICollectionViewController
{
    private let requesterId: Int = 1
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let contextSaveAction = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
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
    
    private lazy var backgroundView: UIView = UIView()
    
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
        sController.searchBar.placeholder = "Find in Albums"
        return sController
    }()
    
    private lazy var allAlbums = DataManager.shared.availableAlbums
    
    private lazy var sortedAlbums: [Alphabet : [Album]] = {
        var result: [Alphabet : [Album]] = [ : ]
        for alphabet in Alphabet.allCases
        {
            let startingLetter = alphabet.asString
            result[alphabet] = allAlbums.filter({ $0.name!.hasPrefix(startingLetter)}).sorted()
        }
        return result
    }()
    
    private var filteredAlbums: [Alphabet : [Album]] = [:]
    
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
        title = "All Albums"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        collectionView.register(PosterDetailCVCell.self, forCellWithReuseIdentifier: PosterDetailCVCell.identifier)
        collectionView.register(SectionHeaderCV.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderCV.identifier)
        (collectionViewLayout as! UICollectionViewFlowLayout).sectionHeadersPinToVisibleBounds = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 70, right: 20)
        backgroundView.addSubview(emptyMessageLabel)
        NSLayoutConstraint.activate([
            emptyMessageLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            emptyMessageLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            emptyMessageLabel.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.8)
        ])
        emptyMessageLabel.attributedText = noResultsMessage
        collectionView.backgroundView = backgroundView
        emptyMessageLabel.attributedText = noResultsMessage
        // Do any additional setup after loading the view.
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.collectionViewLayout.invalidateLayout()
        })
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        if SessionManager.shared.isUserLoggedIn
        {
            NotificationCenter.default.addObserver(self, selector: #selector(onAddAlbumToFavouritesNotification(_:)), name: .addAlbumToFavouritesNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(onRemoveAlbumFromFavouritesNotification(_:)), name: .removeAlbumFromFavouritesNotification, object: nil)
        }
        else
        {
            NotificationCenter.default.addObserver(self, selector: #selector(onLoginRequestNotification(_:)), name: .loginRequestNotification, object: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        if SessionManager.shared.isUserLoggedIn
        {
            NotificationCenter.default.removeObserver(self, name: .addAlbumToFavouritesNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: .removeAlbumFromFavouritesNotification, object: nil)
        }
        else
        {
            NotificationCenter.default.removeObserver(self, name: .loginRequestNotification, object: nil)
        }
        super.viewDidDisappear(animated)
    }
    
    private func createMenu(album: Album) -> UIMenu
    {
        return ContextMenuProvider.shared.getAlbumMenu(album: album, requesterId: requesterId)
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 26
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return isFiltering ? filteredAlbums[Alphabet(rawValue: section)!]?.count ?? 0 : sortedAlbums[Alphabet(rawValue: section)!]!.count
    }

    override func indexTitles(for collectionView: UICollectionView) -> [String]?
    {
        return Alphabet.allCases.map({ $0.asString })
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderCV.identifier, for: indexPath) as! SectionHeaderCV
        if kind == UICollectionView.elementKindSectionHeader
        {
            let alphabet = Alphabet(rawValue: indexPath.section)!
            if isFiltering
            {
               if filteredAlbums[alphabet]?.isEmpty ?? true
                {
                   return headerView
               }
                else
                {
                    headerView.configure(title: alphabet.asString)
                }
            }
            else
            {
                if sortedAlbums[alphabet]!.isEmpty 
                 {
                    return headerView
                }
                 else
                 {
                     headerView.configure(title: alphabet.asString)
                 }
            }
        }
        return headerView
    }
    
//    override func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath
//    {
//        return IndexPath(item: 0, section: index)
//    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterDetailCVCell.identifier, for: indexPath) as! PosterDetailCVCell
        let section = indexPath.section
        let item = indexPath.item
        let album = isFiltering ? filteredAlbums[Alphabet(rawValue: section)!]![item] : sortedAlbums[Alphabet(rawValue: section)!]![item]
        cell.configureCell(poster: album.coverArt!, title: album.name!, subtitle: album.songs![0].getArtistNamesAsString(artistType: .musicDirector))
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let section = indexPath.section
        let item = indexPath.item
        let albumVC = PlaylistViewController(style: .grouped)
        let album = isFiltering ? filteredAlbums[Alphabet(rawValue: section)!]![item] : sortedAlbums[Alphabet(rawValue: section)!]![item]
        albumVC.playlist = album
        albumVC.delegate = GlobalVariables.shared.mainTabController
        self.navigationController?.pushViewController(albumVC, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
    {
        let section = indexPath.section
        let item = indexPath.item
        let album = isFiltering ? filteredAlbums[Alphabet(rawValue: section)!]![item] : sortedAlbums[Alphabet(rawValue: section)!]![item]
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { [unowned self] _ in
            return createMenu(album: album)
        })
    }
}

extension LibraryAlbumViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellWidth = (collectionView.bounds.width / 2.4)
        return .init(width: cellWidth, height: 1.3 * cellWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        if self.collectionView(collectionView, numberOfItemsInSection: section) == 0
        {
            return .zero
        }
        else
        {
            return .init(top: 10, left: 0, bottom: 20, right: 15)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        if self.collectionView(collectionView, numberOfItemsInSection: section) == 0
        {
            return .zero
        }
        else
        {
            return CGSize(width: view.bounds.width, height: 20)
        }
    }
}

extension LibraryAlbumViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        guard let query = searchController.searchBar.text, !query.isEmpty else
        { return }
        filteredAlbums = DataProcessor.shared.getSortedAlbumsThatSatisfy(theQuery: query)
        emptyMessageLabel.isHidden = !filteredAlbums.isEmpty
        collectionView.reloadData()
    }
}

extension LibraryAlbumViewController: UISearchControllerDelegate
{
    func didPresentSearchController(_ searchController: UISearchController)
    {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: true)
    }
    
    func willDismissSearchController(_ searchController: UISearchController)
    {
        emptyMessageLabel.isHidden = true
    }
    
    func didDismissSearchController(_ searchController: UISearchController)
    {
        filteredAlbums = [:]
        collectionView.reloadData()
    }
}

extension LibraryAlbumViewController
{
    @objc func onAddAlbumToFavouritesNotification(_ notification: NSNotification)
    {
        guard let receiverId = notification.userInfo?["receiverId"] as? Int, receiverId == requesterId else
        {
            return
        }
        guard let album = notification.userInfo?["album"] as? Album else
        {
            return
        }
        GlobalVariables.shared.currentUser!.favouritePlaylists!.appendUniquely(album)
        contextSaveAction()
    }
    
    @objc func onRemoveAlbumFromFavouritesNotification(_ notification: NSNotification)
    {
        guard let receiverId = notification.userInfo?["receiverId"] as? Int, receiverId == requesterId else
        {
            return
        }
        guard let album = notification.userInfo?["album"] as? Album else
        {
            return
        }
        GlobalVariables.shared.currentUser!.favouritePlaylists!.removeUniquely(album)
        contextSaveAction()
    }
    
    @objc func onLoginRequestNotification(_ notification: NSNotification)
    {
        
    }
}
