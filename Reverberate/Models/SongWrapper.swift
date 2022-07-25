//
//  SongWrapper.swift
//  Reverberate
//
//  Created by arun-13930 on 20/07/22.
//

import UIKit

class SongWrapper: Identifiable, Hashable, CustomStringConvertible
{
    private lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public var albumName: String?
    public var coverArt: UIImage?
    public var dateOfPublishing: Date?
    public var duration: Double?
    public var title: String?
    public var parentPlaylist: PlaylistWrapper?
    public var artists: [ArtistWrapper]?
    public var url: URL?
    
    var description: String
    {
        "Song(title = \(title!), artists = \(artists!), duration = \(duration!), url = \(url!), albumName = \(albumName!), coverArt = \(coverArt!)"
    }
    
    init(song: Song)
    {
        self.albumName = song.albumName
        self.coverArt = UIImage(data: song.coverArt!)
        self.dateOfPublishing = song.dateOfPublishing
        self.duration = song.duration
        self.title = song.title
        self.parentPlaylist = PlaylistWrapper(playlist: song.parentPlaylist!)
        self.artists = []
        let artistsAry = song.artists!.allObjects as! [Artist]
        for artist in artistsAry {
            self.artists?.append(ArtistWrapper(artist: artist))
        }
        self.url = song.url
    }
    
    init()
    {
        
    }
    
    func emitAsCoreDataObject() -> Song
    {
        let song = Song(context: context)
        song.albumName = self.albumName
        song.coverArt = self.coverArt!.jpegData(compressionQuality: 1)
        song.dateOfPublishing = self.dateOfPublishing
        song.duration = self.duration!
        song.title = self.title
        song.url = self.url
        song.parentPlaylist = self.parentPlaylist!.emitAsCoreDataObject()
        var artistSet = Set<Artist>()
        artists!.forEach {
            artistSet.insert($0.emitAsCoreDataObject())
        }
        song.addToArtists(NSSet(set: artistSet))
        return song
    }
    
    static func == (lhs: SongWrapper, rhs: SongWrapper) -> Bool
    {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(self)
    }
    
    func getArtistNamesAsArray(artistType: ArtistType?) -> [String]
    {
        guard let artistType = artistType else
        {
            var artistNameArray = artists!.map {
                $0.name!
            }
            artistNameArray = Array(Set(artistNameArray)).sorted()
            return artistNameArray
        }

        let artistNameArray = artists!.filter {
            $0.artistType == artistType
        }.map {
            $0.name!
        }
        return artistNameArray.sorted()
    }
    
    func getArtistNamesAsString(artistType: ArtistType?) -> String
    {
        guard let artistType = artistType else
        {
            var artistNameArray = artists!.map {
                $0.name!
            }
            artistNameArray = Array(Set(artistNameArray)).sorted()
            return artistNameArray.joined(separator: ", ")
        }

        let artistNameArray = artists!.filter {
            $0.artistType == artistType
        }.map {
            $0.name!
        }
        return artistNameArray.sorted().joined(separator: ", ")
    }
}
