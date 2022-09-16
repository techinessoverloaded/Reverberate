//
//  GlobalVariables.swift
//  Reverberate
//
//  Created by arun-13930 on 19/07/22.
//

import Foundation
import AVKit

class GlobalVariables
{
    // Singleton object
    static let shared: GlobalVariables = GlobalVariables()
    
    // Prevent Initialization
    private init() {}
    
    var avAudioPlayer: AVAudioPlayer!
    
    var currentSong: Song? = nil
    {
        didSet
        {
            NotificationCenter.default.post(name: NSNotification.Name.currentSongSetNotification, object: nil)
        }
    }
    
    var currentPlaylist: Playlist? = nil
    {
        didSet
        {
            NotificationCenter.default.post(name: NSNotification.Name.currentPlaylistSetNotification, object: nil)
        }
    }
    
    var currentShuffledPlaylist: Playlist? = nil
    
    var currentLoopMode: MusicLoopMode = .off
    
    var currentShuffleMode: MusicShuffleMode = .off
    
    var recentlyPlayedSongNames: [String] = []
    
    var recentlyPlayedAlbumNames: [String] = []
    
    var alreadyPlayedSongs: [Song] = []
    
    var currentUser: User? = nil
    
    var userPlaylists: [Playlist]? = nil
    
    var mainTabController: MainViewController!
}
