//
//  PlaylistWrapper.swift
//  Reverberate
//
//  Created by arun-13930 on 20/07/22.
//

import UIKit

class PlaylistWrapper: Identifiable, Comparable, Hashable, CustomStringConvertible
{
    private lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public var name: String? = nil
    public var songs: [SongWrapper]? = nil
    
    var description: String
    {
        "Playlist(name = \(name!), songs = \(songs!)"
    }
    
    init(playlist: Playlist)
    {
        self.name = playlist.name
        let songArray = playlist.songs!.allObjects as! [Song]
        self.songs = []
        for song in songArray
        {
            self.songs?.append(SongWrapper(song: song))
        }
    }
    
    init()
    {
        
    }
    
    func emitAsCoreDataObject() -> Playlist
    {
        let playlist = Playlist(context: context)
        playlist.name = self.name
        var songSet = Set<Song>()
        songs!.forEach {
            songSet.insert($0.emitAsCoreDataObject())
        }
        playlist.addToSongs(NSSet(set: songSet))
        return playlist
    }
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.name!)
    }
    
    static func == (lhs: PlaylistWrapper, rhs: PlaylistWrapper) -> Bool
    {
        return lhs.name! == rhs.name!
    }
    
    static func < (lhs: PlaylistWrapper, rhs: PlaylistWrapper) -> Bool
    {
        return lhs.name! < rhs.name!
    }
}
