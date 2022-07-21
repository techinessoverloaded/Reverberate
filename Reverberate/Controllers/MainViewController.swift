//
//  ViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 05/07/22.
//

import UIKit
import AVKit

class MainViewController: UITabBarController
{
    private lazy var homeVC = HomeViewController(style: .insetGrouped)

    private lazy var searchVC = SearchViewController(style: .insetGrouped)
    
    private lazy var libraryVC = LibraryViewController(style: .insetGrouped)
    
    private lazy var profileVC = ProfileViewController(style: .insetGrouped)
    
    private lazy var imageNames = ["house", "magnifyingglass", "books.vertical", "person"]
    
    private lazy var selectedImageNames = ["house.fill", "magnifyingglass", "books.vertical.fill", "person.fill"]
    
    private lazy var miniPlayerView: MiniPlayerView = {
        return MiniPlayerView(useAutoLayout: true)
    }()
    
    private var playerController: PlayerViewController!
    
    private var avAudioPlayer: AVAudioPlayer!
    
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
        view.addSubview(miniPlayerView)
        NSLayoutConstraint.activate([
            miniPlayerView.heightAnchor.constraint(equalToConstant: 80),
            miniPlayerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            miniPlayerView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            miniPlayerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        miniPlayerView.delegate = self
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
        NotificationCenter.default.addObserver(self, selector: #selector(onSongChange), name: NSNotification.Name.currentSongSetNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        print("Main View Controller")
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.currentSongSetNotification, object: nil)
    }
    
    func showPlayerController()
    {
        playerController = PlayerViewController(style: .insetGrouped)
        let navController = UINavigationController(rootViewController: playerController)
        playerController.delegate = self
        avAudioPlayer = try! AVAudioPlayer(contentsOf: GlobalVariables.shared.currentSong!.url!)
        playerController.avPlayerRef = avAudioPlayer
        playerController.title = GlobalVariables.shared.currentSong!.albumName!.components(separatedBy: .whitespaces).first!
        navController.modalPresentationStyle = .pageSheet
        navController.navigationBar.isTranslucent = true
        if let sheet = navController.sheetPresentationController
        {
            sheet.prefersGrabberVisible = true
        }
        self.present(navController, animated: false)
    }
}

extension MainViewController: MiniPlayerDelegate
{
    func onPlayButtonTap(miniPlayerView: MiniPlayerView)
    {
        if !avAudioPlayer.isPlaying
        {
            avAudioPlayer.play()
        }
    }
    
    func onPauseButtonTap(miniPlayerView: MiniPlayerView)
    {
        if avAudioPlayer.isPlaying
        {
            avAudioPlayer.pause()
        }
    }
    
    func onRewindButtonTap(miniPlayerView: MiniPlayerView)
    {
        
    }
    
    func onForwardButtonTap(miniPlayerView: MiniPlayerView)
    {
        
    }
    
    func onPlayerExpansionRequest()
    {
        showPlayerController()
    }
}

extension MainViewController: PlayerDelegate
{
    func onPlayButtonTap()
    {
        try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        avAudioPlayer!.play()
    }
    
    func onPauseButtonTap()
    {
        try! AVAudioSession.sharedInstance().setActive(false)
        avAudioPlayer!.pause()
    }
    
    func onRewindButtonTap()
    {
        
    }
    
    func onForwardButtonTap()
    {
        
    }
    
    func onNextButtonTap()
    {
        
    }
    
    func onPreviousButtonTap()
    {
        
    }
    
    func onSeekBarValueChange(songPosition value: Float)
    {
        
    }
    
    func onVolumeSeekBarValueChange(volumeValue value: Float)
    {
        
    }
    
    func onPlayerShrinkRequest()
    {
        playerController.dismiss(animated: true)
        playerController = nil
    }
}

extension MainViewController
{
    @objc func onSongChange()
    {
        miniPlayerView.setSong(song: GlobalVariables.shared.currentSong!)
        miniPlayerView.setPlaying(shouldPlaySong: true)
        showPlayerController()
    }
}
