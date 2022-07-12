//
//  ViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 05/07/22.
//

import UIKit

class MainViewController: UITabBarController
{
    private lazy var homeVC = HomeViewController()
    
    private lazy var searchVC = SearchViewController()
    
    private lazy var libraryVC = LibraryViewController()
    
    private lazy var profileVC = ProfileViewController(style: .insetGrouped)
    
    override func loadView()
    {
        super.loadView()
        tabBar.isTranslucent = true
        homeVC.title = "Home"
        searchVC.title = "Search"
        libraryVC.title = "Your Library"
        profileVC.title = "Your Profile"
        setViewControllers([
            UINavigationController(rootViewController: homeVC),
            UINavigationController(rootViewController: searchVC),
            UINavigationController(rootViewController: libraryVC),
            UINavigationController(rootViewController: profileVC)
        ], animated: false)
        
        let imageNames = ["house", "magnifyingglass", "books.vertical", "person"]
        let selectedImageNames = ["house.fill", "magnifyingglass", "books.vertical.fill", "person.fill"]
        guard let items = tabBar.items else
        {
            return
        }
        for x in 0..<items.count
        {
            items[x].image = UIImage(systemName: imageNames[x])
            items[x].selectedImage = UIImage(systemName: selectedImageNames[x])
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        print("Main View Controller")
    }
}
