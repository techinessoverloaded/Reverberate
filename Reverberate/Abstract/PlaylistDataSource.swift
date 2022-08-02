//
//  PlaylistDataSource.swift
//  Reverberate
//
//  Created by arun-13930 on 02/08/22.
//

protocol PlaylistDataSource: AnyObject
{
    func song(_ playlistViewController: PlaylistViewController, beforeSong: SongWrapper) -> SongWrapper?
    
    func song(_ playlistViewController: PlaylistViewController, afterSong: SongWrapper) -> SongWrapper?
}
