//
//  ArtistDataClass.swift
//  Reverberate
//
//  Created by arun-13930 on 20/07/22.
//

import UIKit

class ArtistWrapper: NSCopying, Identifiable, Comparable, Hashable, CustomStringConvertible
{
    private lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public var name: String? = nil
    public var photo: UIImage? = nil
    public var artistType: [ArtistType]? = nil
    public var contributedSongs: Set<SongWrapper>? = nil
    
    var description: String
    {
        "Artist(name = \(name!), artistType = \(String(describing: artistType)), contributedSongs = \(String(describing: contributedSongs))"
    }
    
    init(artist: Artist)
    {
        self.name = artist.name
        self.photo = UIImage(data: artist.photo!)
        self.artistType = []
        artist.artistType!.forEach {
            self.artistType!.append(ArtistType(rawValue: $0)!)
        }
        if let contributedSongs = artist.contributedSongs
        {
            var tempSet: Set<SongWrapper> = []
            (contributedSongs.allObjects as! [Song]).forEach {
                tempSet.insert(SongWrapper(song: $0))
            }
        }
    }
    
    init()
    {
        
    }
    
    func emitAsCoreDataObject() -> Artist
    {
        let artist = Artist(context: context)
        artist.name = self.name
        artist.photo = self.photo!.jpegData(compressionQuality: 1)
        artist.artistType = []
        self.artistType!.forEach({
            artist.artistType!.append($0.rawValue)
        })
        if let contributedSongs = contributedSongs {
            var tempSet: Set<Song> = []
            contributedSongs.forEach {
                tempSet.insert($0.emitAsCoreDataObject())
            }
            artist.contributedSongs = NSSet(set: tempSet)
        }
        return artist
    }
    
    static func == (lhs: ArtistWrapper, rhs: ArtistWrapper) -> Bool
    {
        lhs.name! == rhs.name!
    }
    
    static func < (lhs: ArtistWrapper, rhs: ArtistWrapper) -> Bool
    {
        return lhs.name! < rhs.name!
    }
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.name!)
    }
    
    func copy(with zone: NSZone? = nil) -> Any
    {
        let artistCopy = ArtistWrapper()
        artistCopy.name = self.name
        artistCopy.artistType = self.artistType
        artistCopy.contributedSongs = self.contributedSongs
        artistCopy.photo = self.photo
        return artistCopy
    }
}
