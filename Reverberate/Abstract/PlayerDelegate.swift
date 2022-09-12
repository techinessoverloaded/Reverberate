//
//  PlayerDelegate.swift
//  Reverberate
//
//  Created by arun-13930 on 21/07/22.
//

protocol PlayerDelegate: PlaylistControlsDelegate
{
    func onPlayButtonTap()
    
    func onPauseButtonTap()
    
    func onRewindButtonTap()
    
    func onForwardButtonTap()
    
    func onLoopButtonTap(loopMode: MusicLoopMode)
    
    func onSongSeekRequest(songPosition value: Double)
    
    func onPlayerShrinkRequest()
}
