//
//  SongTransformable.swift
//  Reverberate
//
//  Created by arun-13930 on 05/08/22.
//
import UIKit
import Foundation

public class Song: NSObject, Identifiable, Comparable, NSSecureCoding
{
    enum CoderKeys: String
    {
        case albumNameKey = "albumNameKey"
        case coverArtKey = "coverArtKey"
        case durationKey = "durationKey"
        case titleKey = "titleKey"
        case artistsKey = "artistsKey"
        case urlKey = "urlKey"
        case genreKey = "genreKey"
        case languageKey = "languageKey"
    }
    
    public static var supportsSecureCoding: Bool = true
    
    public var albumName: String? = nil
    public var coverArt: UIImage? = nil
    public var duration: Double? = nil
    public var title: String? = nil
    public var artists: [Artist]? = nil
    public var url: URL? = nil
    public var genre: MusicGenre? = nil
    public var language: Language? = nil
    
    public override var description: String
    {
        "Song(title = \(title!), artists = \(String(describing: artists)), duration = \(duration!), url = \(url!), albumName = \(albumName!), language = \(String(describing: language)), genre = \(genre), coverArt = \(coverArt!)"
    }
    
    public func encode(with coder: NSCoder)
    {
        coder.encode(albumName, forKey: CoderKeys.albumNameKey.rawValue)
        coder.encode(coverArt, forKey: CoderKeys.coverArtKey.rawValue)
        coder.encode(duration, forKey: CoderKeys.durationKey.rawValue)
        coder.encode(title, forKey: CoderKeys.titleKey.rawValue)
        //coder.encode(artists, forKey: CoderKeys.artistsKey.rawValue)
        coder.encode(url, forKey: CoderKeys.urlKey.rawValue)
        coder.encode(language?.rawValue, forKey: CoderKeys.languageKey.rawValue)
        coder.encode(genre?.rawValue, forKey: CoderKeys.genreKey.rawValue)
    }
    
    public required convenience init?(coder: NSCoder)
    {
        self.init()
        self.albumName = coder.decodeObject(forKey: CoderKeys.albumNameKey.rawValue) as? String
        self.title = coder.decodeObject(forKey: CoderKeys.titleKey.rawValue) as? String
        self.coverArt = coder.decodeObject(forKey: CoderKeys.titleKey.rawValue) as? UIImage
        self.duration = coder.decodeDouble(forKey: CoderKeys.durationKey.rawValue)
        self.url = coder.decodeObject(forKey: CoderKeys.urlKey.rawValue) as? URL
        self.language = Language(rawValue: Int16(coder.decodeInteger(forKey: CoderKeys.languageKey.rawValue)))
        self.genre = MusicGenre(rawValue: Int16(coder.decodeInteger(forKey: CoderKeys.genreKey.rawValue)))
        //self.artists = coder.decodeObject(forKey: CoderKeys.artistsKey.rawValue) as? [ArtistWrapper]
    }
    
    public override init()
    {
        
    }
    
    public static func < (lhs: Song, rhs: Song) -> Bool
    {
        return lhs.title! < rhs.title!
    }
    
    public override func isEqual(_ object: Any?) -> Bool
    {
        return self.title! == (object as! Self).title!
    }
    
    public static func == (lhs: Song, rhs: Song) -> Bool
    {
        return lhs.title! == rhs.title!
    }
    
    func getArtists(ofType artistType: ArtistType) -> [Artist]
        {
            var result: [Artist] = []
            artists!.filter {
                $0.artistType!.contains(artistType)
            }.forEach {
                result.append($0)
            }
            return result
        }
        
        func getArtistNamesAsString(artistType: ArtistType?) -> String
        {
            guard let artistType = artistType else
            {
                var artistNameArray = artists!.map {
                    $0.name!
                }
                artistNameArray = Array(Set(artistNameArray))
                return artistNameArray.joined(separator: ", ")
            }

            let artistNameArray = artists!.filter {
                $0.artistType!.contains(artistType)
            }.map {
                $0.name!
            }
            return artistNameArray.sorted().joined(separator: ", ")
        }
}
