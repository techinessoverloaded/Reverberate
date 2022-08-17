//
//  LibraryViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//

import UIKit

class LibraryViewController: UITableViewController
{
    private lazy var searchController: UISearchController = {
        let libraryResultsVC = LibraryResultsViewController(style: .insetGrouped)
        let sController = UISearchController(searchResultsController: libraryResultsVC)
        sController.searchResultsUpdater = libraryResultsVC
        sController.searchBar.delegate = self
        sController.showsSearchResultsController = true
        sController.hidesNavigationBarDuringPresentation = false
        sController.searchBar.placeholder = "Search your library"
        self.definesPresentationContext = true
        return sController
    }()
    
    private lazy var favOrPlayTabView: LibraryTabView = LibraryTabView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60))
    
    private lazy var viewControllers: [UIViewController] =
    [
        LibraryFavouritesViewController(style: .insetGrouped),
        LibraryPlaylistsViewController(style: .insetGrouped)
    ]
    
    private lazy var contentPager: UIPageViewController = {
        let pager = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        return pager
    }()
    
    private var addBarButton: UIBarButtonItem!
    
    private var searchButton: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 70, right: 0)
        tableView.tableHeaderView = favOrPlayTabView
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(onSearchButtonTap(_:)))
        addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddButtonTap(_:)))
        navigationItem.rightBarButtonItems = [addBarButton, searchButton]
        favOrPlayTabView.delegate = self
        contentPager.dataSource = self
        contentPager.delegate = self
        contentPager.setViewControllers([viewControllers[0]], direction: .forward, animated: true)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Table view data source and delegate
    
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
        return tableView.bounds.height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        addChild(contentPager)
        contentPager.didMove(toParent: self)
        contentPager.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(contentPager.view)
        cell.backgroundColor = .clear
        cell.clipsToBounds =  false
        return cell
    }
}

extension LibraryViewController
{
    @objc func onAddButtonTap(_ sender: UIBarButtonItem)
    {
        
    }
    
    @objc func onSearchButtonTap(_ sender: UIBarButtonItem)
    {
        navigationItem.titleView = searchController.searchBar
        navigationItem.title = nil
        navigationItem.rightBarButtonItems = nil
        searchController.searchBar.becomeFirstResponder()
//self.present(searchController, animated: true)
    }
    
    @objc func onFavouritesOrPlaylistsChange(_ sender: UISegmentedControl)
    {
        let index = sender.selectedSegmentIndex
        if index == 1
        {
            contentPager.setViewControllers([viewControllers[index]], direction: .forward, animated: true)
        }
        else
        {
            contentPager.setViewControllers([viewControllers[index]], direction: .reverse, animated: true)
        }
    }
}

extension LibraryViewController: UISearchControllerDelegate
{
    func willDismissSearchController(_ searchController: UISearchController)
    {
        
    }
}

extension LibraryViewController: UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        guard let index = viewControllers.firstIndex(of: viewController), index > viewControllers.startIndex else
        {
            return nil
        }
        let beforeIndex = index - 1
        return viewControllers[beforeIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let index = viewControllers.firstIndex(of: viewController), index < viewControllers.endIndex - 1 else
        {
            return nil
        }
        let afterIndex = index + 1
        return viewControllers[afterIndex]
    }
}

extension LibraryViewController: LibraryTabViewDelegate
{
    func onFavouritesTabTap(_ tabView: LibraryTabView)
    {
        contentPager.setViewControllers([viewControllers[0]], direction: .reverse, animated: true)
    }
    
    func onPlaylistsTabTap(_ tabView: LibraryTabView)
    {
        contentPager.setViewControllers([viewControllers[1]], direction: .forward, animated: true)
    }
}

extension LibraryViewController: UIPageViewControllerDelegate
{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if completed
        {
            if previousViewControllers.first! == viewControllers.first!
            {
                favOrPlayTabView.updateIndicator(forTab: .playlists)
            }
            else
            {
                favOrPlayTabView.updateIndicator(forTab: .favourites)
            }
        }
        else
        {
            if previousViewControllers.first! == viewControllers.first!
            {
                favOrPlayTabView.updateIndicator(forTab: .favourites)
            }
            else
            {
                favOrPlayTabView.updateIndicator(forTab: .playlists)
            }
        }
        
    }
}

extension LibraryViewController: UISearchBarDelegate
{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchController.searchBar.resignFirstResponder()
        navigationItem.titleView = nil
        navigationItem.title = title
        navigationItem.rightBarButtonItems = [addBarButton, searchButton]
    }
}
