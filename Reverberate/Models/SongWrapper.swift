//
//  SongWrapper.swift
//  Reverberate
//
//  Created by arun-13930 on 20/07/22.
//

import UIKit

class SongWrapper: Identifiable, Hashable, Comparable, CustomStringConvertible
{
    private lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public var albumName: String? = nil
    public var coverArt: UIImage? = nil
    public var duration: Double? = nil
    public var title: String? = nil
    public var artists: [ArtistWrapper]? = nil
    public var url: URL? = nil
    public var genre: MusicGenre? = nil
    public var language: Language? = nil
    
    var description: String
    {
        "Song(title = \(title!), artists = \(String(describing: artists)), duration = \(duration!), url = \(url!), albumName = \(albumName!), language = \(String(describing: language)), genre = \(genre), coverArt = \(coverArt!)"
    }
    
    init(song: Song)
    {
        self.albumName = song.albumName
        self.coverArt = UIImage(data: song.coverArt!)
        self.duration = song.duration
        self.title = song.title
        self.artists = []
        let artistsAry = song.artists!.allObjects as! [Artist]
        for artist in artistsAry {
            self.artists?.append(ArtistWrapper(artist: artist))
        }
        self.url = song.url
        self.genre = MusicGenre(rawValue: song.genre)
        self.language = Language(rawValue: song.language)
    }
    
    init()
    {
        
    }
    
    func emitAsCoreDataObject() -> Song
    {
        let song = Song(context: context)
        song.albumName = self.albumName
        song.coverArt = self.coverArt!.jpegData(compressionQuality: 1)
        song.duration = self.duration!
        song.title = self.title
        song.url = self.url
        song.genre = self.genre!.rawValue
        song.language = self.language!.rawValue
        var artistSet = Set<Artist>()
        artists!.forEach {
            artistSet.insert($0.emitAsCoreDataObject())
        }
        song.addToArtists(NSSet(set: artistSet))
        return song
    }
    
    static func == (lhs: SongWrapper, rhs: SongWrapper) -> Bool
    {
        lhs.title! == rhs.title!
    }
    
    static func < (lhs: SongWrapper, rhs: SongWrapper) -> Bool
    {
        return lhs.title! < rhs.title!
    }
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.title!)
    }
    
    func getArtists(ofType artistType: ArtistType) -> [ArtistWrapper]
    {
        var result: [ArtistWrapper] = []
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
