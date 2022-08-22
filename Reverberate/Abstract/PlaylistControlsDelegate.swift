//
//  PlaylistControlsDelegate.swift
//  Reverberate
//
//  Created by arun-13930 on 22/08/22.
//

protocol PlaylistControlsDelegate: AnyObject
{
    func isNextSongAvailable(playlist: Playlist, currentSong: Song) -> Bool
    
    func isPreviousSongAvailable(playlist: Playlist, currentSong: Song) -> Bool
    
    func onNextSongRequest(playlist: Playlist, currentSong: Song)
    
    func onPreviousSongRequest(playlist: Playlist, currentSong: Song)
    
    func onSongChangeRequest(playlist: Playlist, newSong: Song)
    
    func onShuffleRequest()
}
