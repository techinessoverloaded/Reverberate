//
//  SearchViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//

import UIKit

class SearchViewController: UICollectionViewController
{
    private lazy var browseLabel: UILabel = {
        let bLabel = UILabel(useAutoLayout: true)
        bLabel.textColor = .label
        bLabel.font = .preferredFont(forTextStyle: .title2, weight: .semibold)
        bLabel.text = "Browse All"
        return bLabel
    }()
    
    private lazy var categories: [[Int]] = [[1, 2], [3, 4], [5, 6], [7, 8], [9, 10], [11, 12]]
    
    private lazy var searchController: UISearchController = {
        let searchResultsVC = SearchResultsViewController(collectionViewLayout: UICollectionViewFlowLayout())
        searchResultsVC.delegate = self
        searchResultsVC.playlistDelegate = GlobalVariables.shared.mainTabController
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
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 70, right: 20)
        collectionView.register(TitleCardCVCell.self, forCellWithReuseIdentifier: TitleCardCVCell.identifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .clear
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.largeTitleDisplayMode = .always
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
        LifecycleLogger.viewWillAppearLog(self)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        LifecycleLogger.viewDidAppearLog(self)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        LifecycleLogger.viewDidDisappearLog(self)
    }
    
    deinit
    {
        LifecycleLogger.deinitLog(self)
    }
}

// UICollectionView Delegate and Datasource Methods
extension SearchViewController
{
    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return categories[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        guard kind == UICollectionView.elementKindSectionHeader, indexPath.section == 0 else
        {
            return UICollectionReusableView()
        }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
        headerView.addSubview(browseLabel)
        NSLayoutConstraint.activate([
            browseLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            browseLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        return headerView
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
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

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
        let categoricalVC = CategoricalSongsViewController(style: .grouped)
        categoricalVC.category = Category(rawValue: categories[indexPath.section][indexPath.item])
        categoricalVC.delegate = GlobalVariables.shared.mainTabController
        navigationController?.pushViewController(categoricalVC, animated: true)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellWidth = (collectionView.bounds.width / 2.3)
        return .init(width: cellWidth, height: cellWidth / 2.4)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return .init(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        return section == 0 ? CGSize(width: collectionView.bounds.width, height: 40) : .zero
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
        let artistVC = ArtistViewController(style: .grouped)
        artistVC.artist = selectedArtist
        artistVC.delegate = GlobalVariables.shared.mainTabController
        self.navigationController?.pushViewController(artistVC, animated: true)
    }
    
    func onAlbumSelection(selectedAlbum: Album)
    {
        let albumVC = PlaylistViewController(style: .grouped)
        albumVC.playlist = selectedAlbum
        albumVC.delegate = GlobalVariables.shared.mainTabController
        self.navigationController?.pushViewController(albumVC, animated: true)
    }
}
