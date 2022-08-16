//
//  ViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 05/07/22.
//

import UIKit
import AVKit
import MediaPlayer

class MainViewController: UITabBarController
{
    private lazy var homeVC = HomeViewController(style: .insetGrouped)

    private lazy var searchVC = SearchViewController(style: .insetGrouped)
    
    private lazy var libraryVC = LibraryViewController(style: .plain)
    
    private lazy var profileVC = ProfileViewController(style: .insetGrouped)
    
    private lazy var imageNames = ["house", "magnifyingglass", "books.vertical", "person"]
    
    private lazy var selectedImageNames = ["house.fill", "magnifyingglass", "books.vertical.fill", "person.fill"]
    
    private lazy var miniPlayerView: MiniPlayerView = {
        return MiniPlayerView(useAutoLayout: true)
    }()
    
    private var playerController: PlayerViewController!
    
    private var avAudioPlayer: AVAudioPlayer! = GlobalVariables.shared.avAudioPlayer
    
    private var miniPlayerTimer: CADisplayLink!
    
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
        miniPlayerTimer = CADisplayLink(target: self, selector: #selector(onTimerFire(_:)))
        miniPlayerTimer.add(to: .main, forMode: .common)
        miniPlayerTimer.isPaused = true
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleAudioSessionInterruptionChange(notification:)), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.currentSongSetNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
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
    
    func handleMPNotificationActions()
    {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget
        { [unowned self] event in
            avAudioPlayer.play()
            try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            if playerController != nil
            {
                playerController!.setPlaying(shouldPlaySongFromBeginning: avAudioPlayer.currentTime == 0, isSongPaused: false)
            }
            else
            {
                miniPlayerView.setPlaying(shouldPlaySong: true)
            }
            return .success
        }
        
        commandCenter.pauseCommand.addTarget
        { [unowned self] event in
            avAudioPlayer.pause()
            try! AVAudioSession.sharedInstance().setActive(false)
            if playerController != nil
            {
                playerController?.setPlaying(shouldPlaySongFromBeginning: avAudioPlayer.currentTime == 0, isSongPaused: true)
            }
            else
            {
                miniPlayerView.setPlaying(shouldPlaySong: false)
            }
            return .success
        }
        
        commandCenter.skipForwardCommand.addTarget {
            [unowned self] event in
            avAudioPlayer.currentTime += 10
            MPNowPlayingInfoCenter.default().nowPlayingInfo![MPNowPlayingInfoPropertyElapsedPlaybackTime] = avAudioPlayer.currentTime
            return .success
        }
        
        commandCenter.skipBackwardCommand.addTarget {
            [unowned self] event in
            avAudioPlayer.currentTime -= 10
            MPNowPlayingInfoCenter.default().nowPlayingInfo![MPNowPlayingInfoPropertyElapsedPlaybackTime] = avAudioPlayer.currentTime
            return .success
        }
        
        commandCenter.changePlaybackPositionCommand.addTarget {
            [unowned self] event in
            let changeEvent = event as! MPChangePlaybackPositionCommandEvent
            avAudioPlayer.currentTime = changeEvent.positionTime
            return .success
        }
    }
    
    func setupNowPlayingNotification()
    {
        var nowPlayingInfo = [String: Any]()
        let currentSong = GlobalVariables.shared.currentSong!
        nowPlayingInfo[MPMediaItemPropertyTitle] = currentSong.title!
        nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: currentSong.coverArt!.size, requestHandler: { _ in
            return currentSong.coverArt!
        })
        nowPlayingInfo[MPMediaItemPropertyArtist] = currentSong.getArtistNamesAsString(artistType: nil)
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = currentSong.albumName!
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = avAudioPlayer.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = avAudioPlayer.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = avAudioPlayer.rate
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}

extension MainViewController: MiniPlayerDelegate
{
    func onMiniPlayerPlayButtonTap()
    {
        avAudioPlayer.play()
        try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        miniPlayerTimer.isPaused = false
        setupNowPlayingNotification()
    }
    
    func onMiniPlayerPauseButtonTap()
    {
        avAudioPlayer.pause()
        try! AVAudioSession.sharedInstance().setActive(false)
        miniPlayerTimer.isPaused = true
        setupNowPlayingNotification()
    }
    
    func onMiniPlayerPreviousButtonTap()
    {
        
    }
    
    func onMiniPlayerNextButtonTap()
    {
        
    }
    
    func onPlayerExpansionRequest()
    {
        showPlayerController(shouldPlaySongFromBeginning: false, isSongPaused: !avAudioPlayer.isPlaying)
    }
}

extension MainViewController: PlayerDelegate
{
    func onShuffle()
    {
        
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
        setupNowPlayingNotification()
    }
    
    func onPauseButtonTap()
    {
        avAudioPlayer.pause()
        try! AVAudioSession.sharedInstance().setActive(false)
        miniPlayerView.setPlaying(shouldPlaySong: false)
        setupNowPlayingNotification()
    }
    
    func onRewindButtonTap()
    {
        avAudioPlayer.currentTime -= 10
        setupNowPlayingNotification()
    }
    
    func onForwardButtonTap()
    {
        avAudioPlayer.currentTime += 10
        setupNowPlayingNotification()
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
        setupNowPlayingNotification()
        if miniPlayerTimer.isPaused
        {
            miniPlayerView.updateSongDurationView(newValue: Float(value))
        }
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
        if avAudioPlayer.isPlaying
        {
            miniPlayerTimer.isPaused = false
        }
        else
        {
            miniPlayerTimer.isPaused = true
        }
    }
}

extension MainViewController
{
    @objc func onTimerFire(_ sender: Timer)
    {
        let currentTime = Float(avAudioPlayer.currentTime)
        miniPlayerView.updateSongDurationView(newValue: currentTime)
    }
    
    @objc func handleAudioSessionInterruptionChange(notification: Notification)
    {
        guard let userInfo = notification.userInfo,
        let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
        let type = AVAudioSession.InterruptionType(rawValue: typeValue) else
        {
            return
        }
        switch type
        {
            case .began:
            avAudioPlayer.pause()
            print("Interruption Began")
            if playerController != nil
            {
                playerController?.setPlaying(shouldPlaySongFromBeginning: avAudioPlayer.currentTime == 0, isSongPaused: true)
            }
            else
            {
                miniPlayerView.setPlaying(shouldPlaySong: false)
            }
            setupNowPlayingNotification()
            case .ended:
            print("An interruption ended. Resume playback, if appropriate.")
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume)
            {
                print("An interruption ended. Resume playback.")
                print(avAudioPlayer.prepareToPlay())
                avAudioPlayer.play()
                if playerController != nil
                {
                    playerController!.setPlaying(shouldPlaySongFromBeginning: avAudioPlayer.currentTime == 0, isSongPaused: false)
                }
                else
                {
                    miniPlayerView.setPlaying(shouldPlaySong: true)
                }
                setupNowPlayingNotification()
            }
            else
            {
                print("An interruption ended. Don't resume playback.")
            }
            default: ()
        }
    }
    
    @objc func onSongChange()
    {
        GlobalVariables.shared.avAudioPlayer = try! AVAudioPlayer(contentsOf: GlobalVariables.shared.currentSong!.url!)
        GlobalVariables.shared.avAudioPlayer.delegate = self
        avAudioPlayer = GlobalVariables.shared.avAudioPlayer
        avAudioPlayer.play()
        try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        miniPlayerView.setPlaying(shouldPlaySong: true)
        miniPlayerTimer.isPaused = false
        setupNowPlayingNotification()
        handleMPNotificationActions()
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
            miniPlayerView.setPlaying(shouldPlaySong: false)
            miniPlayerTimer.isPaused = true
            miniPlayerView.updateSongDurationView(newValue: 0)
            playerController?.setPlaying(shouldPlaySongFromBeginning: true)
        }
        if player.numberOfLoops == 1
        {
            print("Loop Once in Delegate")
            player.play()
            try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            miniPlayerView.setPlaying(shouldPlaySong: true)
            miniPlayerTimer.isPaused = false
            playerController?.setPlaying(shouldPlaySongFromBeginning: true, isSongPaused: false)
            playerController?.setLoopButton(loopMode: 0)
            player.numberOfLoops = 0
        }
        if player.numberOfLoops == -1
        {
            player.play()
            try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            miniPlayerView.setPlaying(shouldPlaySong: true)
            miniPlayerTimer.isPaused = false
            playerController?.setPlaying(shouldPlaySongFromBeginning: true, isSongPaused: false)
        }
        setupNowPlayingNotification()
    }
}
