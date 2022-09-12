//
//  PlaylistDelegate.swift
//  Reverberate
//
//  Created by arun-13930 on 02/08/22.
//

protocol PlaylistDelegate: AnyObject
{
    func onPlaylistPauseRequest(playlist: Playlist)
    
    func onPlaylistPlayRequest(playlist: Playlist)
    
    func onPlaylistShuffleRequest(playlist: Playlist, shuffleMode: MusicShuffleMode)
    
    func onPlaylistSongChangeRequest(playlist: Playlist, newSong: Song)
}
