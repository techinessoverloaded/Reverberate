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
    
    private var avAudioPlayer: AVAudioPlayer! = GlobalVariables.shared.avAudioPlayer
    
    private lazy var miniPlayerCompactConstraint: NSLayoutConstraint = miniPlayerView.heightAnchor.constraint(equalToConstant: 80)
    
    private lazy var miniPlayerExtendedConstraint: NSLayoutConstraint = miniPlayerView.heightAnchor.constraint(equalTo: view.heightAnchor)
    
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
            miniPlayerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            miniPlayerView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            miniPlayerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            miniPlayerCompactConstraint
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
    
    func showPlayerController(shouldPlaySongFromBeginning: Bool, isSongPaused: Bool? = nil)
    {
        playerController = PlayerViewController(style: .insetGrouped)
        let navController = UINavigationController(rootViewController: playerController)
        playerController.delegate = self
        playerController.setPlaying(shouldPlaySongFromBeginning: shouldPlaySongFromBeginning, isSongPaused: isSongPaused)
        navController.modalPresentationStyle = .overFullScreen
        navController.modalTransitionStyle = .crossDissolve
        navController.navigationBar.isTranslucent = true
        if let sheet = navController.sheetPresentationController
        {
            sheet.prefersGrabberVisible = true
        }
        UIView.animate(withDuration: 0.1, delay: 0, options: [.transitionCrossDissolve], animations: { [unowned self] in
            self.miniPlayerView.alpha = 0
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: [.transitionCurlUp], animations: { [unowned self] in
                self.present(navController, animated: false)
            }, completion: nil)
        })
    }
}

extension MainViewController: MiniPlayerDelegate
{
    func onPlayButtonTap(miniPlayerView: MiniPlayerView)
    {
        try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        avAudioPlayer.play()
    }
    
    func onPauseButtonTap(miniPlayerView: MiniPlayerView)
    {
        try! AVAudioSession.sharedInstance().setActive(false)
        avAudioPlayer.pause()
    }
    
    func onRewindButtonTap(miniPlayerView: MiniPlayerView)
    {
        avAudioPlayer.currentTime -= 10
    }
    
    func onForwardButtonTap(miniPlayerView: MiniPlayerView)
    {
        avAudioPlayer.currentTime += 10
    }
    
    func onPlayerExpansionRequest()
    {
        showPlayerController(shouldPlaySongFromBeginning: false, isSongPaused: !avAudioPlayer.isPlaying)
    }
}

extension MainViewController: PlayerDelegate
{
    func onLoopButtonTap(loopMode: Int)
    {
        avAudioPlayer.numberOfLoops = loopMode
    }
    
    func onFavouriteButtonTap(shouldMakeAsFavourite: Bool)
    {
        
    }
    
    func onAddToPlaylistsButtonTap(shouldAddToPlaylists: Bool)
    {
        
    }
    
    func onPlayButtonTap()
    {
        try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        avAudioPlayer.play()
        miniPlayerView.setPlaying(shouldPlaySong: true)
    }
    
    func onPauseButtonTap()
    {
        try! AVAudioSession.sharedInstance().setActive(false)
        avAudioPlayer.pause()
        miniPlayerView.setPlaying(shouldPlaySong: false)
    }
    
    func onRewindButtonTap()
    {
        avAudioPlayer.currentTime -= 10
    }
    
    func onForwardButtonTap()
    {
        avAudioPlayer.currentTime += 10
    }
    
    func onNextButtonTap()
    {
        
    }
    
    func onPreviousButtonTap()
    {
        
    }
    
    func onSongSeekRequest(songPosition value: Double)
    {
        avAudioPlayer.currentTime = value
    }
    
    func onShuffleButtonTap()
    {
        
    }
    
    func onPlayerShrinkRequest()
    {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.transitionCurlDown], animations: { [unowned self] in
                self.playerController.dismiss(animated: false)
                self.miniPlayerView.alpha = 1
        }, completion: nil)
    }
}

extension MainViewController
{
    @objc func onSongChange()
    {
        GlobalVariables.shared.avAudioPlayer = try! AVAudioPlayer(contentsOf: GlobalVariables.shared.currentSong!.url!)
        avAudioPlayer = GlobalVariables.shared.avAudioPlayer
        showPlayerController(shouldPlaySongFromBeginning: true)
    }
}
