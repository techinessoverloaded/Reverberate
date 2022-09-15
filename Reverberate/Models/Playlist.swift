//
//  PlaylistWrapper.swift
//  Reverberate
//
//  Created by arun-13930 on 20/07/22.
//

import Foundation
import UIKit

public class Playlist: NSObject, NSSecureCoding, Identifiable, Comparable, NSCopying
{
    private enum CoderKeys: String
    {
        case nameKey = "playlistNameKey"
        case songsKey = "playlistSongsKey"
        case songNamesKey = "playlistSongNamesKey"
    }
    
    public class var supportsSecureCoding: Bool
    {
        return true
    }
    
    public var name: String? = nil
    public var rawSongs: NSArray? = []
    public var songNames: NSArray? = []
    
    public var songs: [Song]?
    {
        return rawSongs as? [Song]
    }
    
    public override var description: String
    {
        "Playlist(name = \(name!), songs = \(songs!))"
    }
    
    public func encode(with coder: NSCoder)
    {
        coder.encode(name, forKey: CoderKeys.nameKey.rawValue)
        coder.encode(rawSongs, forKey: CoderKeys.songsKey.rawValue)
        coder.encode(songNames, forKey: CoderKeys.songNamesKey.rawValue)
    }
    
    public required convenience init?(coder: NSCoder)
    {
        self.init()
        self.name = coder.decodeObject(forKey: CoderKeys.nameKey.rawValue) as? String
        self.rawSongs = coder.decodeObject(forKey: CoderKeys.songsKey.rawValue) as? NSArray
        self.songNames = coder.decodeObject(forKey: CoderKeys.songNamesKey.rawValue) as? NSArray
    }
    
    public override init()
    {
        
    }
    
    public static func == (lhs: Playlist, rhs: Playlist) -> Bool
    {
        return lhs.name! == rhs.name!
    }
    
    public override func isEqual(_ object: Any?) -> Bool
    {
        return self.name! == (object as! Playlist).name!
    }
    
    public static func < (lhs: Playlist, rhs: Playlist) -> Bool
    {
        return lhs.name! < rhs.name!
    }
    
    public func setSongNames(_ names: [String])
    {
        songNames = names as NSArray
    }
    
    public func addSongName(_ songName: String)
    {
        let mutableSongNames: NSMutableArray = songNames!.mutableCopy() as! NSMutableArray
        mutableSongNames.add(songName)
        songNames = mutableSongNames
    }
    
    public func removeSongName(_ songName: String)
    {
        let mutableSongNames: NSMutableArray = songNames!.mutableCopy() as! NSMutableArray
        mutableSongNames.remove(songName)
        songNames = mutableSongNames
    }

    public func setSongs(_ songs: [Song])
    {
        rawSongs = ((songs as NSArray).mutableCopy() as! NSMutableArray)
    }
    
    public func addSong(_ song: Song)
    {
        let mutableSongs: NSMutableArray = rawSongs!.mutableCopy() as! NSMutableArray
        mutableSongs.add(song)
        rawSongs = mutableSongs
    }
    
    public func removeSong(_ song: Song)
    {
        let mutableSongs: NSMutableArray = rawSongs!.mutableCopy() as! NSMutableArray
        mutableSongs.remove(song)
        rawSongs = mutableSongs
    }
    
    public func copy(with zone: NSZone? = nil) -> Any
    {
        let newPlaylist = Playlist()
        newPlaylist.name = self.name
        newPlaylist.rawSongs = self.rawSongs
        return newPlaylist
    }
    
}
