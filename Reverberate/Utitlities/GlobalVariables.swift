//
//  GlobalVariables.swift
//  Reverberate
//
//  Created by arun-13930 on 19/07/22.
//

import Foundation

class GlobalVariables
{
    static let shared: GlobalVariables = GlobalVariables()
    
    // Prevent Initialization
    private init() {}
    
    var availableSongs: [Language: [MusicGenre: Song]] = [:]
    
    var currentSong: SongWrapper? = nil
    {
        didSet
        {
            NotificationCenter.default.post(name: NSNotification.Name.currentSongSetNotification, object: nil)
        }
    }
    
    var currentPlaylist: PlaylistWrapper?
}
