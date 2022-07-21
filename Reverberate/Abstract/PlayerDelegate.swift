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
    
    func onSeekBarValueChange(songPosition value: Float)
    
    func onVolumeSeekBarValueChange(volumeValue value: Float)
    
    func onPlayerShrinkRequest()
    
}
