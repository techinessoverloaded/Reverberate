//
//  SongTransformable.swift
//  Reverberate
//
//  Created by arun-13930 on 05/08/22.
//
import UIKit
import Foundation

public class Song: NSObject, Identifiable, Comparable, NSSecureCoding, NSCopying
{
    enum CoderKeys: String
    {
        case albumNameKey = "albumNameKey"
        case coverArtKey = "coverArtKey"
        case durationKey = "durationKey"
        case titleKey = "titleKey"
        case artistsKey = "artistsKey"
        case fileNameKey = "fileNameKey"
        case genreKey = "genreKey"
        case languageKey = "languageKey"
    }
    
    public static var supportsSecureCoding: Bool = true
    
    public var albumName: String? = nil
    public var coverArt: UIImage? = nil
    public var duration: Double = 0
    public var title: String? = nil
    public var artists: [Artist]? = nil
    public var fileName: String? = nil
    public var genre: MusicGenre = .none
    public var language: Language = .none
    
    public var url: URL
    {
        return Bundle.main.url(forResource: fileName!.nameWithoutExtension, withExtension: fileName!.extension)!
    }
    
    public override var description: String
    {
        "Song(title = \(title!), artists = \(String(describing: artists)), duration = \(duration), fileName = \(String(describing: fileName)), url = \(url), albumName = \(albumName!), language = \(String(describing: language)), genre = \(genre), coverArt = \(String(describing: coverArt))"
    }
    
    public func encode(with coder: NSCoder)
    {
        coder.encode(albumName, forKey: CoderKeys.albumNameKey.rawValue)
        coder.encode(coverArt, forKey: CoderKeys.coverArtKey.rawValue)
        coder.encode(duration, forKey: CoderKeys.durationKey.rawValue)
        coder.encode(title, forKey: CoderKeys.titleKey.rawValue)
        coder.encode(artists, forKey: CoderKeys.artistsKey.rawValue)
        coder.encode(fileName, forKey: CoderKeys.fileNameKey.rawValue)
        coder.encode(Int64(language.rawValue), forKey: CoderKeys.languageKey.rawValue)
        coder.encode(Int64(genre.rawValue), forKey: CoderKeys.genreKey.rawValue)
    }
    
    public required convenience init?(coder: NSCoder)
    {
        self.init()
        self.albumName = coder.decodeObject(forKey: CoderKeys.albumNameKey.rawValue) as? String
        self.title = coder.decodeObject(forKey: CoderKeys.titleKey.rawValue) as? String
        self.coverArt = coder.decodeObject(forKey: CoderKeys.coverArtKey.rawValue) as? UIImage
        self.duration = coder.decodeDouble(forKey: CoderKeys.durationKey.rawValue)
        self.fileName = coder.decodeObject(forKey: CoderKeys.fileNameKey.rawValue) as? String
        self.language = Language(rawValue: Int16(coder.decodeInteger(forKey: CoderKeys.languageKey.rawValue)))!
        self.genre = MusicGenre(rawValue: Int16(coder.decodeInteger(forKey: CoderKeys.genreKey.rawValue)))!
        self.artists = coder.decodeObject(forKey: CoderKeys.artistsKey.rawValue) as? [Artist]
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
        return self.title! == (object as! Song).title!
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
        return result.sorted()
    }
        
    func getArtistNamesAsString(artistType: ArtistType?) -> String
    {
        guard let artistType = artistType else
        {
            var artistNameArray = artists!.map {
                $0.name!
            }
            artistNameArray = Array(Set(artistNameArray))
            return artistNameArray.sorted().joined(separator: ", ")
        }
        
        let artistNameArray = artists!.filter {
            $0.artistType!.contains(artistType)
        }.map {
            $0.name!
        }
        return artistNameArray.sorted().joined(separator: ", ")
    }
    
    public func copy(with zone: NSZone? = nil) -> Any
    {
        let songCopy = Song()
        songCopy.albumName = self.albumName
        songCopy.title = self.title
        songCopy.coverArt = UIImage(data: self.coverArt!.jpegData(compressionQuality: 1)!)!
        songCopy.duration = self.duration
        songCopy.fileName = self.fileName
        songCopy.genre = self.genre
        songCopy.language = self.language
        songCopy.artists = self.artists
        return songCopy
    }
}
