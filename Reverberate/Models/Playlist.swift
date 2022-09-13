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
    enum CoderKeys: String
    {
        case nameKey = "nameKey"
        case songsKey = "songsKey"
        case coverArtKey = "coverArtKey"
        case releaseDateKey = "releaseDateKey"
        case composersKey = "composersKey"
    }
    
    public class var supportsSecureCoding: Bool
    {
        return true
    }
    
    public var name: String? = nil
    public var songs: [Song]? = nil
    
    public override var description: String
    {
        "Playlist(name = \(name!), songs = \(songs!))"
    }
    
    public func encode(with coder: NSCoder)
    {
        coder.encode(name, forKey: CoderKeys.nameKey.rawValue)
        coder.encode(songs, forKey: CoderKeys.songsKey.rawValue)
    }
    
    public required convenience init?(coder: NSCoder)
    {
        self.init()
        self.name = coder.decodeObject(forKey: CoderKeys.nameKey.rawValue) as? String
        self.songs = coder.decodeObject(forKey: CoderKeys.songsKey.rawValue) as? [Song]
        print("decoded songs: \(songs)")
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
    
    public func copy(with zone: NSZone? = nil) -> Any
    {
        let newPlaylist = Playlist()
        newPlaylist.name = self.name
        newPlaylist.songs = self.songs
        return newPlaylist
    }
    
}
