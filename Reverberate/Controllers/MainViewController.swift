//
//  ViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 05/07/22.
//

import UIKit

class MainViewController: UITabBarController
{
    private lazy var homeVC = HomeViewController(style: .insetGrouped)
    
    private lazy var searchVC = SearchViewController(style: .insetGrouped)
    
    private lazy var libraryVC = LibraryViewController(style: .insetGrouped)
    
    private lazy var profileVC = ProfileViewController(style: .insetGrouped)
    
    private lazy var imageNames = ["house", "magnifyingglass", "books.vertical", "person"]
    private lazy var selectedImageNames = ["house.fill", "magnifyingglass", "books.vertical.fill", "person.fill"]
    
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
    
    func replaceViewController(index: Int, newViewController: UIViewController)
    {
        self.viewControllers!.replaceSubrange(index...index, with: [newViewController])
        let item = self.tabBar.items![index]
        item.image = UIImage(systemName: self.imageNames[index])
        item.selectedImage = UIImage(systemName: self.selectedImageNames[index])
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
