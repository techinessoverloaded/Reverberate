//
//  LibraryArtistViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 07/09/22.
//

import UIKit

class LibraryArtistViewController: UICollectionViewController
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
        sController.searchBar.placeholder = "Find in Artists"
        return sController
    }()
    
    private lazy var allArtists = DataManager.shared.availableArtists
    
    private lazy var sortedArtists: [Alphabet : [Artist]] = {
        var result: [Alphabet : [Artist]] = [ : ]
        for alphabet in Alphabet.allCases
        {
            let startingLetter = alphabet.asString
            result[alphabet] = allArtists.filter({ $0.name!.hasPrefix(startingLetter)}).sorted()
        }
        return result
    }()
    
    private var filteredArtists: [Alphabet : [Artist]] = [:]
    
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
        title = "All Artists"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        collectionView.register(ArtistCVCell.self, forCellWithReuseIdentifier: ArtistCVCell.identifier)
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
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 26
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return isFiltering ? filteredArtists[Alphabet(rawValue: section)!]?.count ?? 0 : sortedArtists[Alphabet(rawValue: section)!]!.count
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
               if filteredArtists[alphabet]?.isEmpty ?? true
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
                if sortedArtists[alphabet]!.isEmpty
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistCVCell.identifier, for: indexPath) as! ArtistCVCell
        let section = indexPath.section
        let item = indexPath.item
        let artist = isFiltering ? filteredArtists[Alphabet(rawValue: section)!]![item] : sortedArtists[Alphabet(rawValue: section)!]![item]
        cell.configureCell(artistPicture: artist.photo!, artistName: artist.name!)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let section = indexPath.section
        let item = indexPath.item
        let artistVC = ArtistViewController(style: .grouped)
        let artist = isFiltering ? filteredArtists[Alphabet(rawValue: section)!]![item] : sortedArtists[Alphabet(rawValue: section)!]![item]
        artistVC.artist = artist
        self.navigationController?.pushViewController(artistVC, animated: true)
    }
}

extension LibraryArtistViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellWidth = (collectionView.bounds.width / 2.4)
        return .init(width: cellWidth, height: 1.35 * cellWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        if self.collectionView(collectionView, numberOfItemsInSection: section) == 0
        {
            return .zero
        }
        else
        {
            return .init(top: 10, left: 0, bottom: 10, right: 15)
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

extension LibraryArtistViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        guard let query = searchController.searchBar.text, !query.isEmpty else
        { return }
        filteredArtists = DataProcessor.shared.getSortedArtistsThatSatisfy(theQuery: query)
        emptyMessageLabel.isHidden = !filteredArtists.isEmpty
        collectionView.reloadData()
    }
}

extension LibraryArtistViewController: UISearchControllerDelegate
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
        filteredArtists = [:]
        collectionView.reloadData()
    }
}
