//
//  PlaylistSelectionDelegate.swift
//  Reverberate
//
//  Created by arun-13930 on 09/09/22.
//

protocol PlaylistSelectionDelegate: AnyObject
{
    func onPlaylistSelection(selectedPlaylist: inout Playlist)
}
