//
//  SearchViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//

import UIKit

class SearchViewController: UITableViewController
{
    private lazy var browseLabel: UILabel = {
        let bLabel = UILabel(useAutoLayout: true)
        bLabel.textColor = .label
        bLabel.font = .systemFont(ofSize: 26, weight: .semibold)
        bLabel.text = "Browse All"
        return bLabel
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return cView
    }()
    
    private lazy var categories: [[Int]] = [[1, 2], [3, 4], [5, 6], [7, 8], [9, 10], [11, 12]]
    
    private lazy var searchController: UISearchController = {
        let searchResultsVC = SearchResultsViewController(style: .grouped)
        searchResultsVC.delegate = self
        let sController = UISearchController(searchResultsController: searchResultsVC)
        sController.searchResultsUpdater = searchResultsVC
        searchResultsVC.searchBarRef = sController.searchBar
        sController.showsSearchResultsController = true
        sController.hidesNavigationBarDuringPresentation = true
        sController.searchBar.placeholder = "Songs, Albums, Artists"
        sController.searchBar.scopeButtonTitles = ["Songs", "Albums", "Artists"]
        sController.automaticallyShowsScopeBar = true
        sController.searchBar.delegate = searchResultsVC
        return sController
    }()
    
    private var previousColor: UIColor!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.contentInsetAdjustmentBehavior = .scrollableAxes
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.largeTitleDisplayMode = .always
        collectionView.register(TitleCardCVCell.self, forCellWithReuseIdentifier: TitleCardCVCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsSelection = true
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        coordinator.animate
        {
            [unowned self] _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .systemBlue
        print("Search will appear")
    }
}
//TableView Delegate and Datasource
extension SearchViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            if isInPortraitMode
            {
                let cellHeight = ((tableView.frame.width / 2.3) - 1) / 2
                let margin: CGFloat = 20
                return CGFloat(categories.count) * (cellHeight + margin)
            }
            else
            {
                let cellHeight = ((tableView.frame.width / 2.5) - 1) / 2.5
                let margin: CGFloat = 20
                return CGFloat(categories.count) * (cellHeight + margin)
            }
        }
        else
        {
            return .zero
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if section == 0
        {
            return browseLabel
        }
        else
        {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        cell.backgroundColor = .clear
        cell.addSubViewToContentView(collectionView)
        return cell
    }
}

extension SearchViewController: UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return categories[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let section = indexPath.section
        let item = indexPath.item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCardCVCell.identifier, for: indexPath) as! TitleCardCVCell
        var randomColor = UIColor.randomDarkColor()
        while randomColor == previousColor
        {
            randomColor = UIColor.randomDarkColor()
        }
        previousColor = randomColor
        return cell.configureCell(title: Category(rawValue: categories[section][item])!.description, backgroundColor: randomColor)
    }
}

extension SearchViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
        let categoricalVC = CategoricalSongsViewController(style: .grouped)
        categoricalVC.category = Category(rawValue: categories[indexPath.section][indexPath.item])
        navigationController?.pushViewController(categoricalVC, animated: true)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if isInPortraitMode
        {
            let cellWidth = (tableView.bounds.width / 2.3) - 1
            return .init(width: cellWidth, height: cellWidth / 2)
        }
        else
        {
            let cellWidth = (tableView.bounds.width / 2.5) - 1
            return .init(width: cellWidth, height: cellWidth / 2.5)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return .init(top: 10, left: 0, bottom: 10, right: 0)
    }
}

extension SearchViewController: UISearchControllerDelegate
{
    func didDismissSearchController(_ searchController: UISearchController)
    {
        
    }
}

extension SearchViewController: SearchResultDelegate
{
    func onArtistSelection(selectedArtist: Artist)
    {
        searchController.searchBar.text = nil
        searchController.searchBar.resignFirstResponder()
        let artistVC = ArtistViewController(style: .grouped)
        artistVC.artist = selectedArtist
        searchController.dismiss(animated: true) { [unowned self] in
            self.navigationController?.pushViewController(artistVC, animated: true)
        }
    }
    
    func onAlbumSelection(selectedAlbum: Album)
    {
        searchController.searchBar.text = nil
        searchController.searchBar.resignFirstResponder()
        let albumVC = PlaylistViewController(style: .grouped)
        albumVC.playlist = selectedAlbum
        albumVC.delegate = GlobalVariables.shared.mainTabController
        searchController.dismiss(animated: true)
        { [unowned self] in
            self.navigationController?.pushViewController(albumVC, animated: true)
        }
    }
}

extension SearchViewController: ArtistDelegate
{
    func onFavouriteButtonTap(artist: Artist, shouldMakeAsFavourite: Bool)
    {
        
    }
}
