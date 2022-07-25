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
    
    var availableSongs: [Language: [MusicGenre: [SongWrapper]]] = [:]
    
    var availableAlbums: [AlbumWrapper] = []
    
    var avAudioPlayer: AVAudioPlayer!
    
    var currentSong: SongWrapper? = nil
    {
        didSet
        {
            NotificationCenter.default.post(name: NSNotification.Name.currentSongSetNotification, object: nil)
        }
    }
    
    var currentPlaylist: PlaylistWrapper?
}
