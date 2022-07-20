//
//  PlaylistWrapper.swift
//  Reverberate
//
//  Created by arun-13930 on 20/07/22.
//

import UIKit

class PlaylistWrapper: Identifiable
{
    private lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public var name: String?
    public var songs: [SongWrapper]?
    public var parentUser: User?
    
    func emitAsCoreDataObject() -> Playlist
    {
        let playlist = Playlist(context: context)
        playlist.name = self.name
        var songSet = Set<Song>()
        songs!.forEach {
            songSet.insert($0.emitAsCoreDataObject())
        }
        playlist.addToSongs(NSSet(set: songSet))
        playlist.parentUser = self.parentUser
        return playlist
    }
}
