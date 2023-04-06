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
    let requesterId: Int = 0
    
    private lazy var homeVC = createHomeVc()

    private lazy var searchVC = SearchViewController(collectionViewLayout: UICollectionViewFlowLayout())
    
    private lazy var libraryVC = LibraryViewController(style: .insetGrouped)
    
    private lazy var profileVC = ProfileViewController(style: .insetGrouped)
    
    private lazy var imageNames = ["house", "magnifyingglass", "books.vertical", "person"]
    
    private lazy var selectedImageNames = ["house.fill", "magnifyingglass", "books.vertical.fill", "person.fill"]
    
    private lazy var miniPlayerView: MiniPlayerView = {
        return MiniPlayerView(useAutoLayout: true)
    }()
    
    private lazy var songContextMenuInteraction: UIContextMenuInteraction = {
        return UIContextMenuInteraction(delegate: self)
    }()
    
    private var playerController: PlayerViewController!
    
    private var miniPlayerTimer: CADisplayLink!
    
    private var hasSetupMPCommandCenter: Bool = false
    
    private var songToBeAddedToPlaylist: Song? = nil
    
    func replaceViewController(index: Int, newViewController: UIViewController)
    {
        if index == 0
        {
            homeVC = newViewController as! HomeViewController
            var existingViewControllers = viewControllers!
            existingViewControllers.replaceSubrange(index...index, with: [UINavigationController(rootViewController: homeVC)])
            setViewControllers(existingViewControllers, animated: true)
        }
        else if index == 1
        {
            searchVC = newViewController as! SearchViewController
            var existingViewControllers = viewControllers!
            existingViewControllers.replaceSubrange(index...index, with: [UINavigationController(rootViewController: searchVC)])
            setViewControllers(existingViewControllers, animated: true)
        }
        else if index == 2
        {
            libraryVC = newViewController as! LibraryViewController
            var existingViewControllers = viewControllers!
            existingViewControllers.replaceSubrange(index...index, with: [UINavigationController(rootViewController: libraryVC)])
            setViewControllers(existingViewControllers, animated: true)
        }
        else
        {
            profileVC = newViewController as! ProfileViewController
            var existingViewControllers = viewControllers!
            existingViewControllers.remove(at: 3)
            existingViewControllers.insert(UINavigationController(rootViewController: profileVC), at: 3)
            setViewControllers(existingViewControllers, animated: true)
        }
        let item = self.tabBar.items![index]
        item.image = UIImage(systemName: self.imageNames[index])
        item.selectedImage = UIImage(systemName: self.selectedImageNames[index])
    }
    
    func createHomeVc() -> HomeViewController
    {
        let result = HomeViewController(collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex , _ -> NSCollectionLayoutSection? in
            
            //Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(520), heightDimension: .absolute(220)))
            
            //Group
            let groupSize: NSCollectionLayoutSize!
            let group: NSCollectionLayoutGroup!
            groupSize = NSCollectionLayoutSize(widthDimension: .absolute(520), heightDimension: .absolute(220))
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(15)
            
            //Section
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 15
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 5)
            section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem.init(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: NSRectAlignment.top)]
            return section
        }))
        result.title = "Home"
        return result
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tabBar.isTranslucent = true
        searchVC.title = "Search"
        libraryVC.title = "Library"
        profileVC.title = "Your Profile"
        self.delegate = self
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
        miniPlayerView.addInteraction(songContextMenuInteraction)
        miniPlayerTimer = CADisplayLink(target: self, selector: #selector(onTimerFire))
        miniPlayerTimer.add(to: .main, forMode: .common)
        miniPlayerTimer.isPaused = true
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        LifecycleLogger.viewWillAppearLog(self)
        selectedIndex = UserDefaults.standard.integer(forKey: GlobalConstants.previouslySelectedTabIndex)
        NotificationCenter.default.setObserver(self, selector: #selector(onShowAlbumNotification(_:)), name: .showAlbumTapNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(onSongChange), name: NSNotification.Name.currentSongSetNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(onPlaylistChange), name: NSNotification.Name.currentPlaylistSetNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(handleAudioSessionInterruptionChange(notification:)), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
        NotificationCenter.default.setObserver(self, selector: #selector(onUpcomingSongClickNotification(_:)), name: .upcomingSongClickedNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(onPreviousSongClickNotification(_:)), name: .previousSongClickedNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(onAddSongToFavouritesNotification(_:)), name: .addSongToFavouritesNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(onRemoveSongFromFavouritesNotification(_:)), name: .removeSongFromFavouritesNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(onAddSongToPlaylistNotification(_:)), name: .addSongToPlaylistNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(onAddAlbumToFavouritesNotification(_:)), name: .addAlbumToFavouritesNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(onRemoveAlbumFromFavouritesNotification(_:)), name: .removeAlbumFromFavouritesNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(onAddArtistToFavouritesNotification(_:)), name: .addArtistToFavouritesNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(onRemoveArtistFromFavouritesNotification(_:)), name: .removeArtistFromFavouritesNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(onRemoveSongFromPlaylistNotification(_:)), name: .removeSongFromPlaylistNotification, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(onLoginRequestNotification(_:)), name: .loginRequestNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        LifecycleLogger.viewDidDisappearLog(self)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.currentSongSetNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.currentPlaylistSetNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
        NotificationCenter.default.removeObserver(self, name: .showAlbumTapNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .previousSongClickedNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .upcomingSongClickedNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .addSongToFavouritesNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .removeSongFromFavouritesNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .addSongToPlaylistNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .addArtistToFavouritesNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .addArtistToFavouritesNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .removeAlbumFromFavouritesNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .removeArtistFromFavouritesNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .removeSongFromPlaylistNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .loginRequestNotification, object: nil)
        miniPlayerTimer.invalidate()
        super.viewDidDisappear(animated)
    }
    
    deinit
    {
        LifecycleLogger.deinitLog(self)
    }
    
    func showPlayerController(shouldPlaySongFromBeginning: Bool, isSongPaused: Bool? = nil)
    {
        playerController = PlayerViewController(style: .insetGrouped)
        let navController = UINavigationController(rootViewController: playerController)
        playerController.delegate = self
        playerController.setPlaying(shouldPlaySongFromBeginning: shouldPlaySongFromBeginning, isSongPaused: isSongPaused)
        navController.modalPresentationStyle = .overFullScreen
        navController.modalTransitionStyle = .coverVertical
        navController.navigationBar.isTranslucent = true
        UIView.animate(withDuration: 0.1, delay: 0, options: [.transitionCrossDissolve], animations: { [unowned self] in
            self.miniPlayerView.alpha = 0
            topMostViewController.present(navController, animated: true)
        }, completion: nil)
    }
    
    func setupMPCommandCenter()
    {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget
        { [unowned self] event in
            GlobalVariables.shared.avAudioPlayer.play()
            try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            if playerController != nil
            {
                playerController!.setPlaying(shouldPlaySongFromBeginning: GlobalVariables.shared.avAudioPlayer.currentTime == 0, isSongPaused: false)
            }
            miniPlayerView.setPlaying(shouldPlaySong: true)
            miniPlayerTimer.isPaused = false
            NotificationCenter.default.post(name: NSNotification.Name.playerPlayNotification, object: nil)
            return .success
        }
        
        commandCenter.pauseCommand.addTarget
        { [unowned self] event in
            GlobalVariables.shared.avAudioPlayer.pause()
            try! AVAudioSession.sharedInstance().setActive(false)
            if playerController != nil
            {
                playerController?.setPlaying(shouldPlaySongFromBeginning: GlobalVariables.shared.avAudioPlayer.currentTime == 0, isSongPaused: true)
            }
            miniPlayerView.setPlaying(shouldPlaySong: false)
            miniPlayerTimer.isPaused = true
            NotificationCenter.default.post(name: NSNotification.Name.playerPausedNotification, object: nil)
            return .success
        }
        
        commandCenter.skipForwardCommand.addTarget {
            event in
            GlobalVariables.shared.avAudioPlayer.currentTime += 10
            MPNowPlayingInfoCenter.default().nowPlayingInfo![MPNowPlayingInfoPropertyElapsedPlaybackTime] = GlobalVariables.shared.avAudioPlayer.currentTime
            return .success
        }
        
        commandCenter.skipBackwardCommand.addTarget {
            event in
            GlobalVariables.shared.avAudioPlayer.currentTime -= 10
            MPNowPlayingInfoCenter.default().nowPlayingInfo![MPNowPlayingInfoPropertyElapsedPlaybackTime] = GlobalVariables.shared.avAudioPlayer.currentTime
            return .success
        }
        
        commandCenter.changePlaybackPositionCommand.addTarget {
            event in
            let changeEvent = event as! MPChangePlaybackPositionCommandEvent
            GlobalVariables.shared.avAudioPlayer.currentTime = changeEvent.positionTime
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget {
            [unowned self] _ in
            onNextSongRequest(playlist: GlobalVariables.shared.currentPlaylist!, currentSong: GlobalVariables.shared.currentSong!)
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget {
            [unowned self] _ in
            onPreviousSongRequest(playlist: GlobalVariables.shared.currentPlaylist!, currentSong: GlobalVariables.shared.currentSong!)
            return .success
        }
    }
    
    func setupNowPlayingNotification()
    {
        let commandCenter = MPRemoteCommandCenter.shared()
        guard let currentSong = GlobalVariables.shared.currentSong else
        {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
            let commandCenter = MPRemoteCommandCenter.shared()
            commandCenter.playCommand.isEnabled = false
            commandCenter.pauseCommand.isEnabled = false
            commandCenter.skipForwardCommand.isEnabled = false
            commandCenter.skipBackwardCommand.isEnabled = false
            commandCenter.changePlaybackPositionCommand.isEnabled = false
            commandCenter.nextTrackCommand.isEnabled = false
            commandCenter.previousTrackCommand.isEnabled = false
            return
        }
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = currentSong.title!
        nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: currentSong.coverArt!.size, requestHandler: { _ in
            return currentSong.coverArt!
        })
        nowPlayingInfo[MPMediaItemPropertyArtist] = currentSong.getArtistNamesAsString(artistType: nil)
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = currentSong.albumName!
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = GlobalVariables.shared.avAudioPlayer.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = GlobalVariables.shared.avAudioPlayer.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = GlobalVariables.shared.avAudioPlayer.rate
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        let playlist = GlobalVariables.shared.currentPlaylist
        if playlist != nil
        {
            commandCenter.nextTrackCommand.isEnabled = true
            commandCenter.previousTrackCommand.isEnabled = true
            commandCenter.skipForwardCommand.isEnabled = false
            commandCenter.skipBackwardCommand.isEnabled = false
        }
        else
        {
            commandCenter.skipForwardCommand.isEnabled = true
            commandCenter.skipBackwardCommand.isEnabled = true
            commandCenter.nextTrackCommand.isEnabled = false
            commandCenter.previousTrackCommand.isEnabled = false
        }
    }
    
    func showLoginController(afterDelay: Bool = true)
    {
        if afterDelay
        {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: { [unowned self] in
                selectedIndex = 3
                profileVC.showLoginViewController()
            })
        }
        else
        {
            selectedIndex = 3
            profileVC.showLoginViewController()
        }
    }
}

extension MainViewController: MiniPlayerDelegate
{
    func onMiniPlayerPlayButtonTap()
    {
        GlobalVariables.shared.avAudioPlayer.play()
        try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        miniPlayerTimer.isPaused = false
        setupNowPlayingNotification()
        NotificationCenter.default.post(name: NSNotification.Name.playerPlayNotification, object: nil)
    }
    
    func onMiniPlayerPauseButtonTap()
    {
        GlobalVariables.shared.avAudioPlayer.pause()
        try! AVAudioSession.sharedInstance().setActive(false)
        miniPlayerTimer.isPaused = true
        setupNowPlayingNotification()
        NotificationCenter.default.post(name: NSNotification.Name.playerPausedNotification, object: nil)
    }
    
    func onPlayerExpansionRequest()
    {
        showPlayerController(shouldPlaySongFromBeginning: false, isSongPaused: !GlobalVariables.shared.avAudioPlayer.isPlaying)
    }
}

extension MainViewController: PlayerDelegate
{
    func onArtistDetailViewRequest(artist: Artist)
    {
        let artistVc = ArtistViewController(style: .grouped)
        artistVc.artist = DataProcessor.shared.getArtist(named: artist.name!)
        artistVc.delegate = self
        (selectedViewController as! UINavigationController).pushViewController(artistVc, animated: true)
    }
    
    func onPlaylistDetailViewRequest(playlist: Playlist)
    {
        onPlayerShrinkRequest()
        let playlistName = playlist.name!
        if playlist is Album
        {
            let albumVc = PlaylistViewController(style: .grouped)
            albumVc.delegate = self
            albumVc.playlist = playlist as! Album
            (selectedViewController as! UINavigationController).pushViewController(albumVc, animated: true)
        }
        else
        {
            if Category.allCases.map({ $0.description }).contains(playlistName)
            {
                let categoricalVC = CategoricalSongsViewController(style: .grouped)
                let category = Category.getCategoryFromDescription(playlistName)!
                categoricalVC.category = category
                categoricalVC.delegate = self
                (selectedViewController as! UINavigationController).pushViewController(categoricalVC, animated: true)
            }
            else if DataManager.shared.availableArtists.map({ $0.name! }).contains(playlistName)
            {
                let artistVc = ArtistViewController(style: .grouped)
                artistVc.artist = DataProcessor.shared.getArtist(named: playlistName)
                artistVc.delegate = self
                (selectedViewController as! UINavigationController).pushViewController(artistVc, animated: true)
            }
            else if playlistName == "All Songs"
            {
                let librarySongVc = LibrarySongViewController(style: .plain)
                librarySongVc.delegate = self
                librarySongVc.viewOnlyFavSongs = false
                (selectedViewController as! UINavigationController).pushViewController(librarySongVc, animated: true)
            }
            else if playlistName == "Favourite Songs"
            {
                let libraryFavSongVc = LibrarySongViewController(style: .plain)
                libraryFavSongVc.delegate = self
                libraryFavSongVc.viewOnlyFavSongs = true
                (selectedViewController as! UINavigationController).pushViewController(libraryFavSongVc, animated: true)
            }
            else
            {
                let playlistVc = PlaylistViewController(style: .grouped)
                playlistVc.playlist = playlist
                playlistVc.delegate = self
                (selectedViewController as! UINavigationController).pushViewController(playlistVc, animated: true)
            }
        }
    }
    
    func onShuffleRequest(playlist: Playlist, shuffleMode: MusicShuffleMode)
    {
        onPlaylistShuffleRequest(playlist: playlist, shuffleMode: shuffleMode)
    }
    
    func onLoopButtonTap(loopMode: MusicLoopMode)
    {
        GlobalVariables.shared.currentLoopMode = loopMode
        switch loopMode
        {
        case .off:
            GlobalVariables.shared.avAudioPlayer.numberOfLoops = 0
        case .song:
            GlobalVariables.shared.avAudioPlayer.numberOfLoops = -1
        case .playlist:
            GlobalVariables.shared.avAudioPlayer.numberOfLoops = 0
        }
    }
    
    func onPlayButtonTap()
    {
        GlobalVariables.shared.avAudioPlayer.play()
        try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        miniPlayerView.setPlaying(shouldPlaySong: true)
        miniPlayerTimer.isPaused = false
        setupNowPlayingNotification()
        NotificationCenter.default.post(name: NSNotification.Name.playerPlayNotification, object: nil)
    }
    
    func onPauseButtonTap()
    {
        GlobalVariables.shared.avAudioPlayer.pause()
        try! AVAudioSession.sharedInstance().setActive(false)
        miniPlayerView.setPlaying(shouldPlaySong: false)
        miniPlayerTimer.isPaused = true
        setupNowPlayingNotification()
        NotificationCenter.default.post(name: NSNotification.Name.playerPausedNotification, object: nil)
    }
    
    func onRewindButtonTap()
    {
        GlobalVariables.shared.avAudioPlayer.currentTime -= 10
        setupNowPlayingNotification()
    }
    
    func onForwardButtonTap()
    {
        GlobalVariables.shared.avAudioPlayer.currentTime += 10
        setupNowPlayingNotification()
    }
    
    func isNextSongAvailable(playlist: Playlist, currentSong: Song) -> Bool
    {
        let shuffleMode = GlobalVariables.shared.currentShuffleMode
        if shuffleMode == .on
        {
            let songs = GlobalVariables.shared.currentShuffledPlaylist!.songs!
            guard let index = songs.firstIndex(of: currentSong) else
            {
                return false
            }
            return songs.index(after: index) != songs.endIndex
        }
        else
        {
            let songs = playlist.songs!
            guard let index = songs.firstIndex(of: currentSong) else
            {
                return false
            }
            return songs.index(after: index) != songs.endIndex
        }
    }
    
    func isPreviousSongAvailable(playlist: Playlist, currentSong: Song) -> Bool
    {
        let shuffleMode = GlobalVariables.shared.currentShuffleMode
        if shuffleMode == .on
        {
            let songs = GlobalVariables.shared.currentShuffledPlaylist!.songs!
            guard let index = songs.firstIndex(of: currentSong) else
            {
                return false
            }
            return songs.index(before: index) >= songs.startIndex
        }
        else
        {
            let songs = playlist.songs!
            guard let index = songs.firstIndex(of: currentSong) else
            {
                return false
            }
            return songs.index(before: index) >= songs.startIndex
        }
    }
    
    func onNextSongRequest(playlist: Playlist, currentSong: Song)
    {
        let currentShuffleMode = GlobalVariables.shared.currentShuffleMode
        var song: Song!
        if currentShuffleMode == .on
        {
            let shuffledPlaylist = GlobalVariables.shared.currentShuffledPlaylist!
            if !isNextSongAvailable(playlist: shuffledPlaylist, currentSong: currentSong)
            {
                song = shuffledPlaylist.songs!.first!
            }
            else
            {
                let songs = shuffledPlaylist.songs!
                let index = songs.firstIndex(of: currentSong)!
                song = songs[index + 1]
            }
        }
        else
        {
            if !isNextSongAvailable(playlist: playlist, currentSong: currentSong)
            {
                song = playlist.songs!.first!
            }
            else
            {
                let songs = playlist.songs!
                let index = songs.firstIndex(of: currentSong)!
                song = songs[index + 1]
            }
        }
        GlobalVariables.shared.currentSong = song
    }
    
    func onPreviousSongRequest(playlist: Playlist, currentSong: Song)
    {
        let currentShuffleMode = GlobalVariables.shared.currentShuffleMode
        if currentShuffleMode == .on
        {
            let shuffledPlaylist = GlobalVariables.shared.currentShuffledPlaylist!
            if !isPreviousSongAvailable(playlist: shuffledPlaylist, currentSong: currentSong)
            {
                GlobalVariables.shared.currentSong = shuffledPlaylist.songs!.last!
            }
            else
            {
                let songs = shuffledPlaylist.songs!
                let index = songs.firstIndex(of: currentSong)!
                GlobalVariables.shared.currentSong = songs[index - 1]
            }
        }
        else
        {
            if !isPreviousSongAvailable(playlist: playlist, currentSong: currentSong)
            {
                GlobalVariables.shared.currentSong = playlist.songs!.last!
            }
            else
            {
                let songs = playlist.songs!
                let index = songs.firstIndex(of: currentSong)!
                GlobalVariables.shared.currentSong = songs[index - 1]
            }
        }
    }
    
    func onSongChangeRequest(playlist: Playlist, newSong: Song)
    {
        let shuffleMode = GlobalVariables.shared.currentShuffleMode
        if shuffleMode == .on
        {
            if GlobalVariables.shared.currentPlaylist != playlist
            {
                let shuffledPlaylist = playlist.copy() as! Playlist
                shuffledPlaylist.songs = playlist.songs!.shuffled()
                GlobalVariables.shared.currentShuffledPlaylist = shuffledPlaylist
                GlobalVariables.shared.automaticallyDeducePlaylistSong = false
                GlobalVariables.shared.currentPlaylist = GlobalVariables.shared.currentShuffledPlaylist
            }
            GlobalVariables.shared.alreadyPlayedSongs.removeAll()
            GlobalVariables.shared.currentSong = newSong
            GlobalVariables.shared.automaticallyDeducePlaylistSong = true
        }
        else
        {
            if GlobalVariables.shared.currentPlaylist != playlist
            {
                GlobalVariables.shared.automaticallyDeducePlaylistSong = false
                GlobalVariables.shared.currentPlaylist = playlist
            }
            GlobalVariables.shared.alreadyPlayedSongs.removeAll()
            GlobalVariables.shared.currentSong = newSong
            GlobalVariables.shared.automaticallyDeducePlaylistSong = true
        }
    }
    
    func onSongSeekRequest(songPosition value: Double)
    {
        GlobalVariables.shared.avAudioPlayer.currentTime = value
        setupNowPlayingNotification()
        if miniPlayerTimer.isPaused
        {
            miniPlayerView.updateSongDurationView(newValue: Float(value))
        }
    }
    
    func onPlayerShrinkRequest()
    {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.transitionCurlDown], animations: { [unowned self] in
                self.playerController.dismiss(animated: false)
                self.playerController = nil
                self.miniPlayerView.alpha = 1
        }, completion: nil)
        if GlobalVariables.shared.avAudioPlayer.isPlaying
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
    @objc func onPreviousSongClickNotification(_ notification: NSNotification)
    {
        guard let receiverId = notification.userInfo?["receiverId"] as? Int, receiverId == requesterId else
        {
            return
        }
        guard let song = notification.userInfo?["song"] as? Song else
        {
            return
        }
        onSongChangeRequest(playlist: GlobalVariables.shared.currentPlaylist!, newSong: song)
    }
    
    @objc func onUpcomingSongClickNotification(_ notification: NSNotification)
    {
        guard let receiverId = notification.userInfo?["receiverId"] as? Int, receiverId == requesterId else
        {
            return
        }
        guard let song = notification.userInfo?["song"] as? Song else
        {
            return
        }
        onSongChangeRequest(playlist: GlobalVariables.shared.currentPlaylist!, newSong: song)
    }
    
    @objc func onRemoveSongFromPlaylistNotification(_ notification: NSNotification)
    {
        guard let receiverId = notification.userInfo?["receiverId"] as? Int, receiverId == requesterId else
        {
            return
        }
        guard let song = notification.userInfo?["song"] as? Song else
        {
            return
        }
        guard let playlist = notification.userInfo?["playlist"] as? Playlist else
        {
            return
        }
        if GlobalVariables.shared.currentPlaylist == playlist
        {
            if GlobalVariables.shared.currentSong == song
            {
                if playlist.songs!.count - 1 > 0
                {
                    print("remaining song count: \(playlist.songs!.count)")
                    onNextSongRequest(playlist: playlist, currentSong: song)
                    GlobalVariables.shared.currentPlaylist!.songs!.removeUniquely(song)
                    if GlobalVariables.shared.currentShuffleMode == .on
                    {
                        GlobalVariables.shared.currentShuffleMode = .off
                    }
                }
                else
                {
                    print("no more remaining songs")
                    GlobalVariables.shared.currentPlaylist = nil
                    GlobalVariables.shared.currentSong = nil
                    if GlobalVariables.shared.currentLoopMode == .playlist
                    {
                        GlobalVariables.shared.currentLoopMode = .off
                    }
                    if GlobalVariables.shared.currentShuffleMode == .on
                    {
                        GlobalVariables.shared.currentShuffleMode = .off
                    }
                }
                DataManager.shared.persistRecentlyPlayedItems(songName: song.title!, albumName: song.albumName!)
            }
        }
        GlobalVariables.shared.currentUser!.remove(song: song, fromPlaylistNamed: playlist.name!, completionHandler: {
            NotificationCenter.default.post(name: .songRemovedFromPlaylistNotification, object: nil, userInfo: ["playlistName": playlist.name!])
        })
    }
    
    @objc func onAddSongToPlaylistNotification(_ notification: NSNotification)
    {
        guard let receiverId = notification.userInfo?["receiverId"] as? Int, receiverId == requesterId else
        {
            return
        }
        guard let song = notification.userInfo?["song"] as? Song else
        {
            return
        }
        guard let isTranslucent = notification.userInfo?["isTranslucent"] as? Bool else
        {
            return
        }
        songToBeAddedToPlaylist = song
        let playlistSelectionVc = PlaylistSelectionViewController(style: .plain)
        playlistSelectionVc.delegate = self
        playlistSelectionVc.isTranslucent = isTranslucent
        let playlistVcNavigationVc = UINavigationController(rootViewController: playlistSelectionVc)
        if let sheet = playlistVcNavigationVc.sheetPresentationController
        {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
        }
        topMostViewController.present(playlistVcNavigationVc, animated: true)
    }
    
    @objc func onAddSongToFavouritesNotification(_ notification: NSNotification)
    {
        guard let receiverId = notification.userInfo?["receiverId"] as? Int, receiverId == requesterId else
        {
            return
        }
        guard let song = notification.userInfo?["song"] as? Song else
        {
            return
        }
        GlobalVariables.shared.currentUser!.addToFavouriteSongs(song)
    }
    
    @objc func onRemoveSongFromFavouritesNotification(_ notification: NSNotification)
    {
        guard let receiverId = notification.userInfo?["receiverId"] as? Int, receiverId == requesterId else
        {
            return
        }
        guard let song = notification.userInfo?["song"] as? Song else
        {
            return
        }
        GlobalVariables.shared.currentUser!.removeFromFavouriteSongs(song)
    }
    
    @objc func onAddAlbumToFavouritesNotification(_ notification: NSNotification)
    {
        guard let receiverId = notification.userInfo?["receiverId"] as? Int, receiverId == requesterId else
        {
            return
        }
        guard let album = notification.userInfo?["album"] as? Album else
        {
            return
        }
        GlobalVariables.shared.currentUser!.addToFavouriteAlbums(album)
    }
    
    @objc func onRemoveAlbumFromFavouritesNotification(_ notification: NSNotification)
    {
        guard let receiverId = notification.userInfo?["receiverId"] as? Int, receiverId == requesterId else
        {
            return
        }
        guard let album = notification.userInfo?["album"] as? Album else
        {
            return
        }
        GlobalVariables.shared.currentUser!.removeFromFavouriteAlbums(album)
        GlobalConstants.contextSaveAction()
    }
    
    @objc func onAddArtistToFavouritesNotification(_ notification: NSNotification)
    {
        guard let receiverId = notification.userInfo?["receiverId"] as? Int, receiverId == requesterId else
        {
            return
        }
        guard let artist = notification.userInfo?["artist"] as? Artist else
        {
            return
        }
        GlobalVariables.shared.currentUser!.addToFavouriteArtists(artist)
    }
    
    @objc func onRemoveArtistFromFavouritesNotification(_ notification: NSNotification)
    {
        guard let receiverId = notification.userInfo?["receiverId"] as? Int, receiverId == requesterId else
        {
            return
        }
        guard let artist = notification.userInfo?["artist"] as? Artist else
        {
            return
        }
        GlobalVariables.shared.currentUser!.removeFromFavouriteArtists(artist)
    }
    
    @objc func onTimerFire()
    {
        guard let avAudioPlayer = GlobalVariables.shared.avAudioPlayer else
        {
            return
        }
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
            GlobalVariables.shared.avAudioPlayer.pause()
            print("Interruption Began")
            if playerController != nil
            {
                playerController?.setPlaying(shouldPlaySongFromBeginning: GlobalVariables.shared.avAudioPlayer.currentTime == 0, isSongPaused: true)
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
                print(GlobalVariables.shared.avAudioPlayer.prepareToPlay())
                GlobalVariables.shared.avAudioPlayer.play()
                if playerController != nil
                {
                    playerController!.setPlaying(shouldPlaySongFromBeginning: GlobalVariables.shared.avAudioPlayer.currentTime == 0, isSongPaused: false)
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
        guard GlobalVariables.shared.currentSong != nil else
        {
            guard GlobalVariables.shared.avAudioPlayer != nil else
            {
                return
            }
            GlobalVariables.shared.avAudioPlayer.stop()
            GlobalVariables.shared.avAudioPlayer = nil
            try! AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
            miniPlayerView.setDetails()
            setupNowPlayingNotification()
            if !hasSetupMPCommandCenter
            {
                setupMPCommandCenter()
                hasSetupMPCommandCenter = true
            }
            return
        }
        GlobalVariables.shared.avAudioPlayer = try! AVAudioPlayer(contentsOf: GlobalVariables.shared.currentSong!.url as URL)
        GlobalVariables.shared.avAudioPlayer.delegate = self
        GlobalVariables.shared.avAudioPlayer.play()
        try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        miniPlayerView.setPlaying(shouldPlaySong: true)
        miniPlayerTimer.isPaused = false
        setupNowPlayingNotification()
        if !hasSetupMPCommandCenter
        {
            setupMPCommandCenter()
            hasSetupMPCommandCenter = true
        }
        let song = GlobalVariables.shared.currentSong!
        GlobalVariables.shared.alreadyPlayedSongs.appendUniquely(song)
        DataManager.shared.persistRecentlyPlayedItems(songName: song.title!, albumName: song.albumName!)
    }
    
    @objc func onPlaylistChange()
    {
        guard let playlist = GlobalVariables.shared.currentPlaylist else
        {
            return
        }
        guard GlobalVariables.shared.automaticallyDeducePlaylistSong else
        {
            return
        }
        GlobalVariables.shared.alreadyPlayedSongs.removeAll()
        if let song = GlobalVariables.shared.currentSong
        {
            if playlist.songs!.contains(song)
            {
                miniPlayerView.setPlaying(shouldPlaySong: true)
                miniPlayerTimer.isPaused = false
                setupNowPlayingNotification()
                if !hasSetupMPCommandCenter
                {
                    setupMPCommandCenter()
                    hasSetupMPCommandCenter = true
                }
                return
            }
        }
        if GlobalVariables.shared.currentShuffleMode == .on
        {
            var randomSong = playlist.songs!.randomElement()!
            if let currentSong = GlobalVariables.shared.currentSong
            {
                while randomSong == currentSong
                {
                    randomSong = playlist.songs!.randomElement()!
                }
            }
            GlobalVariables.shared.currentSong = randomSong
        }
        else
        {
            GlobalVariables.shared.currentSong = playlist.songs!.first!
        }
    }
    
    @objc func onShowAlbumNotification(_ notification: NSNotification)
    {
        guard let receiverId = notification.userInfo?["receiverId"] as? Int, receiverId == requesterId else
        {
            return
        }
        guard let song = notification.userInfo?["song"] as? Song else
        {
            return
        }
        let album = DataProcessor.shared.getAlbumThat(containsSong: song.title!)
        let albumVc = PlaylistViewController(style: .grouped)
        albumVc.delegate = self
        albumVc.playlist = album
        (selectedViewController as! UINavigationController).pushViewController(albumVc, animated: true)
    }
    
    @objc func onLoginRequestNotification(_ notification: NSNotification)
    {
        showLoginController()
    }
}

extension MainViewController: AVAudioPlayerDelegate
{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        let loopMode = GlobalVariables.shared.currentLoopMode
        print(loopMode)
        if loopMode == .off
        {
            print("No Repeat")
            let alreadyPlayedSongs = GlobalVariables.shared.alreadyPlayedSongs
            print("Number of already played songs: \(alreadyPlayedSongs.count)")
            if let currentPlaylist = GlobalVariables.shared.currentPlaylist
            {
                if alreadyPlayedSongs.count < currentPlaylist.songs!.count
                {
                    onNextSongRequest(playlist: currentPlaylist, currentSong: GlobalVariables.shared.currentSong!)
                }
                else
                {
                    GlobalVariables.shared.alreadyPlayedSongs.removeAll()
                    onNextSongRequest(playlist: currentPlaylist, currentSong: GlobalVariables.shared.currentSong!)
                    if GlobalVariables.shared.avAudioPlayer != nil
                    {
                        if GlobalVariables.shared.avAudioPlayer.isPlaying
                        {
                            GlobalVariables.shared.avAudioPlayer.pause()
                        }
                    }
                    miniPlayerView.setPlaying(shouldPlaySong: false)
                    miniPlayerTimer.isPaused = true
                    miniPlayerView.updateSongDurationView(newValue: 0)
                    playerController?.setPlaying(shouldPlaySongFromBeginning: true)
                }
            }
            else
            {
                GlobalVariables.shared.alreadyPlayedSongs.removeAll()
                if GlobalVariables.shared.avAudioPlayer != nil
                {
                    if GlobalVariables.shared.avAudioPlayer.isPlaying
                    {
                        GlobalVariables.shared.avAudioPlayer.pause()
                    }
                }
                miniPlayerView.setPlaying(shouldPlaySong: false)
                miniPlayerTimer.isPaused = true
                miniPlayerView.updateSongDurationView(newValue: 0)
                playerController?.setPlaying(shouldPlaySongFromBeginning: true)
            }
        }
        else if loopMode == .playlist
        {
            print("Repeat Playlist")
            onNextSongRequest(playlist: GlobalVariables.shared.currentPlaylist!, currentSong: GlobalVariables.shared.currentSong!)
        }
        else
        {
            print("Repeat single song")
            GlobalVariables.shared.currentSong = GlobalVariables.shared.currentSong!
        }
        setupNowPlayingNotification()
    }
}

extension MainViewController: PlaylistDelegate
{
    func onPlaylistSongChangeRequest(playlist: Playlist, newSong: Song)
    {
        onSongChangeRequest(playlist: playlist, newSong: newSong)
    }
    
    func onPlaylistPauseRequest(playlist: Playlist)
    {
        onPauseButtonTap()
    }
    
    func onPlaylistPlayRequest(playlist: Playlist)
    {
        if GlobalVariables.shared.currentPlaylist != playlist
        {
            onSongChangeRequest(playlist: playlist, newSong: playlist.songs!.first!)
        }
        onPlayButtonTap()
    }
    
    func onPlaylistShuffleRequest(playlist: Playlist, shuffleMode: MusicShuffleMode)
    {
        GlobalVariables.shared.currentShuffleMode = shuffleMode
        if shuffleMode == .on
        {
            let shuffledPlaylist = playlist.copy() as! Playlist
            shuffledPlaylist.songs = playlist.songs!.shuffled()
            GlobalVariables.shared.currentShuffledPlaylist = shuffledPlaylist
            GlobalVariables.shared.currentPlaylist = GlobalVariables.shared.currentShuffledPlaylist
        }
        else
        {
            GlobalVariables.shared.currentPlaylist = playlist
        }
    }
}

extension MainViewController: UIContextMenuInteractionDelegate
{
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration?
    {
        guard let song = GlobalVariables.shared.currentSong else
        {
            return nil
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { [unowned self] _ in
           return ContextMenuProvider.shared.getSongMenu(song: song, requesterId: requesterId)
        })
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?
    {
        guard let song = GlobalVariables.shared.currentSong else {
            return nil
        }
        var config = UIListContentConfiguration.cell()
        config.text = song.title!
        config.secondaryText = song.getArtistNamesAsString(artistType: nil)
        config.imageProperties.cornerRadius = 10
        config.image = song.coverArt
        config.textProperties.adjustsFontForContentSizeCategory = true
        config.textProperties.allowsDefaultTighteningForTruncation = true
        config.secondaryTextProperties.adjustsFontForContentSizeCategory = true
        config.secondaryTextProperties.color = .secondaryLabel
        config.secondaryTextProperties.allowsDefaultTighteningForTruncation = true
        config.secondaryTextProperties.font = .preferredFont(forTextStyle: .footnote)
        let contentView = config.makeContentView()
        contentView.layer.cornerRadius = 10
        contentView.frame = CGRect(x: 0, y: 0, width: 400, height: 80)
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        blurView.layer.cornerRadius = 10
        blurView.frame = contentView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(blurView)
        contentView.sendSubviewToBack(blurView)
        contentView.backgroundColor = .clear
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        return UITargetedPreview(view: contentView, parameters: parameters, target: UIPreviewTarget(container: view, center: CGPoint(x: view.center.x, y: view.center.y), transform: CGAffineTransform(translationX: miniPlayerView.center.x, y: miniPlayerView.center.y)))
    }
    
    @available(iOS 16.0, *)
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configuration: UIContextMenuConfiguration,
        highlightPreviewForItemWithIdentifier identifier: NSCopying
    ) -> UITargetedPreview? {
        guard let song = GlobalVariables.shared.currentSong else {
            return nil
        }
        var config = UIListContentConfiguration.cell()
        config.text = song.title!
        config.secondaryText = song.getArtistNamesAsString(artistType: nil)
        config.imageProperties.cornerRadius = 10
        config.image = song.coverArt
        config.textProperties.adjustsFontForContentSizeCategory = true
        config.textProperties.allowsDefaultTighteningForTruncation = true
        config.secondaryTextProperties.adjustsFontForContentSizeCategory = true
        config.secondaryTextProperties.color = .secondaryLabel
        config.secondaryTextProperties.allowsDefaultTighteningForTruncation = true
        config.secondaryTextProperties.font = .preferredFont(forTextStyle: .footnote)
        let contentView = config.makeContentView()
        contentView.layer.cornerRadius = 10
        contentView.frame = CGRect(x: 0, y: 0, width: 400, height: 80)
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        blurView.layer.cornerRadius = 10
        blurView.frame = contentView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(blurView)
        contentView.sendSubviewToBack(blurView)
        contentView.backgroundColor = .clear
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        return UITargetedPreview(view: contentView, parameters: parameters, target: UIPreviewTarget(container: view, center: CGPoint(x: view.center.x, y: view.center.y), transform: CGAffineTransform(translationX: miniPlayerView.center.x, y: miniPlayerView.center.y)))
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating)
    {
        animator.preferredCommitStyle = .dismiss
        animator.addAnimations { [unowned self] in
            onPlayerExpansionRequest()
        }
    }
}

extension MainViewController: PlaylistSelectionDelegate
{
    func onPlaylistSelection(selectedPlaylist: Playlist)
    {
        guard let songToBeAdded = songToBeAddedToPlaylist else { return }
        if selectedPlaylist.songs!.contains(where: { $0.title! == songToBeAdded.title! })
        {
            let alert = UIAlertController(title: "Song exists already in Playlist", message: "The chosen song is present already in Playlist", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel))
            selectedViewController!.present(alert, animated: true)
        }
        else
        {
            GlobalVariables.shared.currentUser!.add(song: songToBeAdded, toPlaylistNamed: selectedPlaylist.name!)
            NotificationCenter.default.post(name: .songAddedToPlaylistNotification, object: nil, userInfo: ["playlistName" : selectedPlaylist.name!])
            let alert = UIAlertController(title: "Song added to Playlist", message: "The chosen song was added to \(selectedPlaylist.name!) Playlist successfully!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel))
            selectedViewController!.present(alert, animated: true)
        }
        songToBeAddedToPlaylist = nil
    }
}
extension MainViewController: UITabBarControllerDelegate
{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        UserDefaults.standard.set(selectedIndex, forKey: GlobalConstants.previouslySelectedTabIndex)
    }
}
