//
//  AlbumWrapper.swift
//  Reverberate
//
//  Created by arun-13930 on 20/07/22.
//

import Foundation
import UIKit

public class Album: Playlist
{
    public var coverArt: UIImage? = nil
    public var releaseDate: Date? = nil
    public var composers: [Artist]? = nil
    
    public override static var supportsSecureCoding: Bool
    {
        return true
    }
    
    public override var description: String
    {
        "Album(name = \(name!), songs = \(songs!), coverArt = \(coverArt!), releaseDate = \(releaseDate!))"
    }
    
    public override func encode(with coder: NSCoder)
    {
        coder.encode(name, forKey: CoderKeys.nameKey.rawValue)
        coder.encode(songs, forKey: CoderKeys.songsKey.rawValue)
        coder.encode(coverArt, forKey: CoderKeys.coverArtKey.rawValue)
        coder.encode(releaseDate, forKey: CoderKeys.releaseDateKey.rawValue)
        coder.encode(composers, forKey: CoderKeys.composersKey.rawValue)
    }
    
    public required convenience init?(coder: NSCoder)
    {
        self.init()
        self.name = coder.decodeObject(forKey: CoderKeys.nameKey.rawValue) as? String
        self.songs = coder.decodeObject(forKey: CoderKeys.songsKey.rawValue) as? [Song]
        self.coverArt = coder.decodeObject(forKey: CoderKeys.coverArtKey.rawValue) as? UIImage
        self.releaseDate = coder.decodeObject(forKey: CoderKeys.releaseDateKey.rawValue) as? Date
        self.composers = coder.decodeObject(forKey: CoderKeys.composersKey.rawValue) as? [Artist]
    }
    
    public override init()
    {
        super.init()
    }
    
    public var composerNames: String
    {
        guard let composers = composers else
        {
            return ""
        }
        return composers.map({
            $0.name!
        }).joined(separator: ", ")
    }
    
    public var language: String
    {
        return songs!.first!.language.description
    }
}
