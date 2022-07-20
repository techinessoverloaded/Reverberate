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
        sController.showsSearchResultsController = true
        sController.hidesNavigationBarDuringPresentation = true
        sController.searchBar.placeholder = "Search your library"
        return sController
    }()
    
    private lazy var favouritesOrPlaylistsSelector: UISegmentedControl = {
        let selector = UISegmentedControl(items: ["Favourites", "Playlists"])
        selector.selectedSegmentIndex = 0
        selector.selectedSegmentTintColor = UIColor(named: GlobalConstants.techinessColor)!
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        selector.setTitleTextAttributes(titleTextAttributes, for: .selected)
        selector.enableAutoLayout()
        return selector
    }()
    
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddButtonTapped(_:)))
        navigationItem.rightBarButtonItem = addBarButton
        favouritesOrPlaylistsSelector.addTarget(self, action: #selector(onFavouritesOrPlaylistsChange(_:)), for: .valueChanged)
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
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 50
        }
        else
        {
            return tableView.bounds.height * 0.8
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = indexPath.section
        if section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
            cell.addSubViewToContentView(favouritesOrPlaylistsSelector, useAutoLayout: true)
            return cell
        }
        else
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
}

extension LibraryViewController
{
    @objc func onAddButtonTapped(_ sender: UIBarButtonItem)
    {
        
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
    func willDismissSearchController(_ searchController: UISearchController) {
        //navigationItem.searchController = nil
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

extension LibraryViewController: UIPageViewControllerDelegate
{
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        favouritesOrPlaylistsSelector.selectedSegmentIndex = viewControllers.firstIndex(of: pendingViewControllers.first!)!
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        
    }
}
