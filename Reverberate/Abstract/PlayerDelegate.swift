//
//  PlayerDelegate.swift
//  Reverberate
//
//  Created by arun-13930 on 21/07/22.
//

protocol PlayerDelegate: AnyObject
{
    func onPlayButtonTap()
    
    func onPauseButtonTap()
    
    func onRewindButtonTap()
    
    func onForwardButtonTap()
    
    func onNextButtonTap()
    
    func onPreviousButtonTap()
    
    func onShuffleButtonTap()
    
    func onLoopButtonTap(loopMode: Int)
    
    func onSongSeekRequest(songPosition value: Double)
    
    func onPlayerShrinkRequest()
    
    func onFavouriteButtonTap(shouldMakeAsFavourite: Bool)
    
    func onAddToPlaylistsButtonTap(shouldAddToPlaylists: Bool)
}
