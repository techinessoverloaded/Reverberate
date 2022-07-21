//
//  MiniPlayerDelegate.swift
//  Reverberate
//
//  Created by arun-13930 on 21/07/22.
//

protocol MiniPlayerDelegate: AnyObject
{
    func onPlayButtonTap(miniPlayerView: MiniPlayerView)
    
    func onPauseButtonTap(miniPlayerView: MiniPlayerView)
    
    func onRewindButtonTap(miniPlayerView: MiniPlayerView)
    
    func onForwardButtonTap(miniPlayerView: MiniPlayerView)
    
    func onPlayerExpansionRequest()
}
