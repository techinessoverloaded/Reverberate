//
//  MiniPlayerDelegate.swift
//  Reverberate
//
//  Created by arun-13930 on 21/07/22.
//

protocol MiniPlayerDelegate: PlaylistControlsDelegate
{
    func onMiniPlayerPlayButtonTap()
    
    func onMiniPlayerPauseButtonTap()
    
    func onPlayerExpansionRequest()
}
