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
    let requesterId: Int = Int(NSDate().timeIntervalSince1970 * 1000)
    
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
    
    private var avAudioPlayer: AVAudioPlayer! = GlobalVariables.shared.avAudioPlayer
    
    private var miniPlayerTimer: CADisplayLink!
    
    private var hasSetupMPCommandCenter: Bool = false
    
    private var songToBeAddedToPlaylist: Song? = nil
    
    override func loadView()
    {
        super.loadView()
        tabBar.isTranslucent = true
        searchVC.title = "Search"
        libraryVC.title = "Library"
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
        miniPlayerView.addInteraction(songContextMenuInteraction)
        miniPlayerTimer = CADisplayLink(target: self, selector: #selector(onTimerFire(_:)))
        miniPlayerTimer.add(to: .main, forMode: .common)
        miniPlayerTimer.isPaused = true
    }
    
    func replaceViewController(index: Int, newViewController: UIViewController)
    {
        if index == 0
        {
            homeVC = newViewController as! HomeViewController
            self.viewControllers!.replaceSubrange(index...index, with: [UINavigationController(rootViewController: homeVC)])
        }
        else if index == 1
        {
            searchVC = newViewController as! SearchViewController
            self.viewControllers!.replaceSubrange(index...index, with: [UINavigationController(rootViewController: searchVC)])
        }
        else if index == 2
        {
            libraryVC = newViewController as! LibraryViewController
            self.viewControllers!.replaceSubrange(index...index, with: [UINavigationController(rootViewController: libraryVC)])
        }
        else
        {
            profileVC = newViewController as! ProfileViewController
            self.viewControllers!.replaceSubrange(index...index, with: [UINavigationController(rootViewController: profileVC)])
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
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20)
            section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem.init(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: NSRectAlignment.top)]
            return section
        }))
        result.title = "Home"
        return result
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        NotificationCenter.default.addObserver(self, selector: #selector(onShowAlbumNotification(_:)), name: .showAlbumTapNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onSongChange), name: NSNotification.Name.currentSongSetNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onPlaylistChange), name: NSNotification.Name.currentPlaylistSetNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAudioSessionInterruptionChange(notification:)), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
        NotificationCenter.default.addObserver(self, selector: #selector(onUpcomingSongClickNotification(_:)), name: .upcomingSongClickedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onPreviousSongClickNotification(_:)), name: .previousSongClickedNotification, object: nil)
        if SessionManager.shared.isUserLoggedIn
        {
            NotificationCenter.default.addObserver(self, selector: #selector(onAddSongToFavouritesNotification(_:)), name: .addSongToFavouritesNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(onRemoveSongFromFavouritesNotification(_:)), name: .removeSongFromFavouritesNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(onAddSongToPlaylistNotification(_:)), name: .addSongToPlaylistNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(onAddAlbumToFavouritesNotification(_:)), name: .addAlbumToFavouritesNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(onRemoveAlbumFromFavouritesNotification(_:)), name: .removeAlbumFromFavouritesNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(onAddArtistToFavouritesNotification(_:)), name: .addArtistToFavouritesNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(onRemoveArtistFromFavouritesNotification(_:)), name: .removeArtistFromFavouritesNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(onRemoveSongFromPlaylistNotification(_:)), name: .removeSongFromPlaylistNotification, object: nil)
        }
        else
        {
            NotificationCenter.default.addObserver(self, selector: #selector(onLoginRequestNotification(_:)), name: .loginRequestNotification, object: nil)
        }
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.currentSongSetNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.currentPlaylistSetNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
        NotificationCenter.default.removeObserver(self, name: .showAlbumTapNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .previousSongClickedNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .upcomingSongClickedNotification, object: nil)
        if SessionManager.shared.isUserLoggedIn
        {
            NotificationCenter.default.removeObserver(self, name: .addSongToFavouritesNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: .removeSongFromFavouritesNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: .addSongToPlaylistNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: .addArtistToFavouritesNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: .addArtistToFavouritesNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: .removeAlbumFromFavouritesNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: .removeArtistFromFavouritesNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: .removeSongFromPlaylistNotification, object: nil)
        }
        else
        {
            NotificationCenter.default.removeObserver(self, name: .loginRequestNotification, object: nil)
        }
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
            self.present(navController, animated: true)
        }, completion: nil)
    }
    
    func setupMPCommandCenter()
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
            NotificationCenter.default.post(name: NSNotification.Name.playerPlayNotification, object: nil)
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
            NotificationCenter.default.post(name: NSNotification.Name.playerPausedNotification, object: nil)
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
        let commandCenter = MPRemoteCommandCenter.shared()
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
    
    func showLoginController()
    {
        selectedIndex = 3
        profileVC.showLoginViewController()
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
        NotificationCenter.default.post(name: NSNotification.Name.playerPlayNotification, object: nil)
    }
    
    func onMiniPlayerPauseButtonTap()
    {
        avAudioPlayer.pause()
        try! AVAudioSession.sharedInstance().setActive(false)
        miniPlayerTimer.isPaused = true
        setupNowPlayingNotification()
        NotificationCenter.default.post(name: NSNotification.Name.playerPausedNotification, object: nil)
    }
    
    func onPlayerExpansionRequest()
    {
        showPlayerController(shouldPlaySongFromBeginning: false, isSongPaused: !avAudioPlayer.isPlaying)
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
            avAudioPlayer.numberOfLoops = 0
        case .song:
            avAudioPlayer.numberOfLoops = -1
        case .playlist:
            avAudioPlayer.numberOfLoops = 0
        }
    }
    
    func onPlayButtonTap()
    {
        avAudioPlayer.play()
        try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        miniPlayerView.setPlaying(shouldPlaySong: true)
        setupNowPlayingNotification()
        NotificationCenter.default.post(name: NSNotification.Name.playerPlayNotification, object: nil)
    }
    
    func onPauseButtonTap()
    {
        avAudioPlayer.pause()
        try! AVAudioSession.sharedInstance().setActive(false)
        miniPlayerView.setPlaying(shouldPlaySong: false)
        setupNowPlayingNotification()
        NotificationCenter.default.post(name: NSNotification.Name.playerPausedNotification, object: nil)
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
        if currentShuffleMode == .on
        {
            let shuffledPlaylist = GlobalVariables.shared.currentShuffledPlaylist!
            if !isNextSongAvailable(playlist: shuffledPlaylist, currentSong: currentSong)
            {
                GlobalVariables.shared.currentSong = shuffledPlaylist.songs!.first!
            }
            else
            {
                let songs = shuffledPlaylist.songs!
                let index = songs.firstIndex(of: currentSong)!
                GlobalVariables.shared.currentSong = songs[index + 1]
            }
        }
        else
        {
            if !isNextSongAvailable(playlist: playlist, currentSong: currentSong)
            {
                GlobalVariables.shared.currentSong = playlist.songs!.first!
            }
            else
            {
                let songs = playlist.songs!
                let index = songs.firstIndex(of: currentSong)!
                GlobalVariables.shared.currentSong = songs[index + 1]
            }
        }
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
                GlobalVariables.shared.currentPlaylist = GlobalVariables.shared.currentShuffledPlaylist
            }
            GlobalVariables.shared.currentSong = newSong
        }
        else
        {
            if GlobalVariables.shared.currentPlaylist != playlist
            {
                GlobalVariables.shared.currentPlaylist = playlist
            }
            GlobalVariables.shared.currentSong = newSong
        }
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
        if GlobalVariables.shared.currentSong == song
        {
            if GlobalVariables.shared.currentPlaylist == playlist
            {
                if playlist.songs!.count - 1 > 0
                {
                    onNextSongRequest(playlist: playlist, currentSong: song)
                    GlobalVariables.shared.currentPlaylist!.songs!.removeUniquely(song)
                }
                else
                {
                    GlobalVariables.shared.currentPlaylist = nil
                }
                miniPlayerView.setPlaying(shouldPlaySong: true)
                miniPlayerTimer.isPaused = false
                setupNowPlayingNotification()
                if !hasSetupMPCommandCenter
                {
                    setupMPCommandCenter()
                    hasSetupMPCommandCenter = true
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
        self.present(playlistVcNavigationVc, animated: true)
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
        guard GlobalVariables.shared.currentSong != nil else
        {
            return
        }
        GlobalVariables.shared.avAudioPlayer = try! AVAudioPlayer(contentsOf: GlobalVariables.shared.currentSong!.url as URL)
        GlobalVariables.shared.avAudioPlayer.delegate = self
        avAudioPlayer = GlobalVariables.shared.avAudioPlayer
        avAudioPlayer.play()
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
        if GlobalVariables.shared.currentPlaylist != nil
        {
            GlobalVariables.shared.alreadyPlayedSongs.appendUniquely(song)
        }
        DataManager.shared.persistRecentlyPlayedItems(songName: song.title!, albumName: song.albumName!)
    }
    
    @objc func onPlaylistChange()
    {
        guard let playlist = GlobalVariables.shared.currentPlaylist else
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
                    onNextSongRequest(playlist: currentPlaylist, currentSong: GlobalVariables.shared.currentSong!)
                    try! AVAudioSession.sharedInstance().setActive(false)
                    miniPlayerView.setPlaying(shouldPlaySong: false)
                    miniPlayerTimer.isPaused = true
                    miniPlayerView.updateSongDurationView(newValue: 0)
                    playerController?.setPlaying(shouldPlaySongFromBeginning: true)
                    GlobalVariables.shared.alreadyPlayedSongs.removeAll()
                }
            }
            else
            {
                try! AVAudioSession.sharedInstance().setActive(false)
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
            GlobalVariables.shared.currentPlaylist = playlist
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
        guard let song = GlobalVariables.shared.currentSong else
        {
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
        contentView.frame = CGRect(x: 0, y: 0, width: 400, height: 70)
        contentView.layer.cornerRadius = 10
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .systemFill
        return UITargetedPreview(view: contentView, parameters: parameters, target: UIPreviewTarget(container: view, center: CGPoint(x: view.center.x, y: view.center.y), transform: CGAffineTransform(translationX: miniPlayerView.center.x, y: miniPlayerView.center.y)))
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
