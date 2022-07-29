//
//  AlbumWrapper.swift
//  Reverberate
//
//  Created by arun-13930 on 20/07/22.
//

import UIKit

class AlbumWrapper: Identifiable, Comparable, Hashable, CustomStringConvertible
{
    private lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public var name: String? = nil
    public var songs: [SongWrapper]? = nil
    public var coverArt: UIImage? = nil
    public var releaseDate: Date? = nil
    
    var description: String
    {
        "Album(name = \(name!), songs = \(songs!), coverArt = \(coverArt!), releaseDate = \(releaseDate!))"
    }
    
    
    init(album: Album)
    {
        self.name = album.name!
        let songArray = album.songs!.allObjects as! [Song]
        self.songs = []
        for song in songArray
        {
            self.songs?.append(SongWrapper(song: song))
        }
        self.coverArt = UIImage(data: album.coverArt!)
        self.releaseDate = album.releaseDate!
    }
    
    init()
    {
        
    }
    
    func emitAsCoreDataObject() -> Album
    {
        let album = Album(context: context)
        album.name = self.name
        var songSet = Set<Song>()
        songs!.forEach {
            songSet.insert($0.emitAsCoreDataObject())
        }
        album.addToSongs(NSSet(set: songSet))
        album.coverArt = self.coverArt!.jpegData(compressionQuality: 1)
        album.releaseDate = self.releaseDate!
        return album
    }
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.name!)
    }
    
    static func == (lhs: AlbumWrapper, rhs: AlbumWrapper) -> Bool
    {
        return lhs.name! == rhs.name!
    }
    
    static func < (lhs: AlbumWrapper, rhs: AlbumWrapper) -> Bool
    {
        return lhs.name! < rhs.name!
    }
}
