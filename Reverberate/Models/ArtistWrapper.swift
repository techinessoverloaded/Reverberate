//
//  ArtistDataClass.swift
//  Reverberate
//
//  Created by arun-13930 on 20/07/22.
//

import UIKit

class ArtistWrapper: Identifiable, Comparable, Hashable, CustomStringConvertible
{
    private lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public var name: String?
    public var photo: UIImage?
    public var artistType: ArtistType?
    public var parentSong: SongWrapper?
    
    var description: String
    {
        "Artist(name = \(name!), artistType = \(artistType!.description))"
    }
    
    init(artist: Artist)
    {
        self.name = artist.name
        self.photo = UIImage(data: artist.photo!)
        self.artistType = ArtistType(rawValue: artist.artistType)
        self.parentSong = SongWrapper(song: artist.parentSong!)
    }
    
    init()
    {
        
    }
    
    func emitAsCoreDataObject() -> Artist
    {
        let artist = Artist(context: context)
        artist.name = self.name
        artist.photo = self.photo!.jpegData(compressionQuality: 1)
        artist.artistType = self.artistType!.rawValue
        artist.parentSong = self.parentSong!.emitAsCoreDataObject()
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
}
