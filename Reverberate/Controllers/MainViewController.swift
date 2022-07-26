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
            miniPlayerView.heightAnchor.constraint(equalToConstant: 70)
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
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        print("Main View Controller")
        NotificationCenter.default.addObserver(self, selector: #selector(onSongChange), name: NSNotification.Name.currentSongSetNotification, object: nil)
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
        playerController.setLoopButton(loopMode: avAudioPlayer.numberOfLoops)
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
        avAudioPlayer.play()
        try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
    }
    
    func onPauseButtonTap(miniPlayerView: MiniPlayerView)
    {
        avAudioPlayer.pause()
        try! AVAudioSession.sharedInstance().setActive(false)
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
    func onShuffle() {
        
    }
    
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
        avAudioPlayer.play()
        try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        miniPlayerView.setPlaying(shouldPlaySong: true)
    }
    
    func onPauseButtonTap()
    {
        avAudioPlayer.pause()
        try! AVAudioSession.sharedInstance().setActive(false)
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
        GlobalVariables.shared.avAudioPlayer.delegate = self
        avAudioPlayer = GlobalVariables.shared.avAudioPlayer
        avAudioPlayer.play()
        try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        miniPlayerView.setPlaying(shouldPlaySong: true)
    }
}

extension MainViewController: AVAudioPlayerDelegate
{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        print(player.numberOfLoops)
        if player.numberOfLoops == 0
        {
            print("Finished Playing")
            try! AVAudioSession.sharedInstance().setActive(false)
            playerController.setPlaying(shouldPlaySongFromBeginning: true)
        }
        if player.numberOfLoops == 1
        {
            print("Loop Once in Delegate")
            player.play()
            try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            playerController.setPlaying(shouldPlaySongFromBeginning: true, isSongPaused: false)
            playerController.setLoopButton(loopMode: 0)
            player.numberOfLoops = 0
        }
        if player.numberOfLoops == -1
        {
            player.play()
            try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            playerController.setPlaying(shouldPlaySongFromBeginning: true, isSongPaused: false)
        }
    }
}
