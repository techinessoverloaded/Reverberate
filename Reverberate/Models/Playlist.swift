//
//  PlaylistWrapper.swift
//  Reverberate
//
//  Created by arun-13930 on 20/07/22.
//

import Foundation
import UIKit

public class Playlist: NSObject, NSSecureCoding, Identifiable, Comparable
{
    enum CoderKeys: String
    {
        case nameKey = "nameKey"
        case songsKey = "songsKey"
        case coverArtKey = "coverArtKey"
        case releaseDateKey = "releaseDateKey"
        case composersKey = "composersKey"
    }
    
    public static var supportsSecureCoding: Bool = true
    
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
    }
    
    public override init()
    {
        
    }
    
    public static func == (lhs: Playlist, rhs: Playlist) -> Bool
    {
        return lhs.name! == rhs.name!
    }
    
    public static func < (lhs: Playlist, rhs: Playlist) -> Bool
    {
        return lhs.name! < rhs.name!
    }
}
