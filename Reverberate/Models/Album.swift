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
    enum CoderKeys: String
    {
        case nameKey = "nameOfAlbumKey"
        case songsKey = "albumSongsKey"
        case coverArtKey = "albumCoverArtKey"
        case releaseDateKey = "albumReleaseDateKey"
        case composersKey = "albumComposersKey"
    }
    
    public var coverArt: UIImage? = nil
    public var releaseDate: Date? = nil
    public var composers: [Artist]? = nil
    
    public override class var supportsSecureCoding: Bool
    {
        return true
    }

    public override var description: String
    {
        "Album(name = \(name!), songs = \(songs!), coverArt = \(coverArt ?? nil), releaseDate = \(releaseDate ?? nil))"
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
    
    public var composerNames: String
    {
        guard let composers = composers else
        {
            return ""
        }
        return composers.sorted().map({
            $0.name!
        }).joined(separator: ", ")
    }
    
    public var language: String
    {
        return songs!.first!.language.description 
    }
    
    public static func == (lhs: Album, rhs: Album) -> Bool
    {
        return lhs.name! == rhs.name!
    }
    
    public override func isEqual(_ object: Any?) -> Bool
    {
        return self.name! == (object as! Playlist).name!
    }
    
    public static func < (lhs: Album, rhs: Album) -> Bool
    {
        return lhs.name! < rhs.name!
    }
    
    public override func copy(with zone: NSZone? = nil) -> Any
    {
        let newAlbum = Album()
        newAlbum.name = self.name
        newAlbum.coverArt = UIImage(data: self.coverArt!.jpegData(compressionQuality: 1)!)!
        newAlbum.composers = self.composers
        newAlbum.songs = self.songs
        newAlbum.releaseDate = self.releaseDate
        return newAlbum
    }
}
