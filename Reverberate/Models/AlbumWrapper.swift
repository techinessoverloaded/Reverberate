//
//  AlbumWrapper.swift
//  Reverberate
//
//  Created by arun-13930 on 20/07/22.
//

import UIKit

class AlbumWrapper: PlaylistWrapper
{
    private lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public var coverArt: UIImage?
    
    override func emitAsCoreDataObject() -> Album
    {
        let album = Album(context: context)
        album.name = self.name
        var songSet = Set<Song>()
        songs!.forEach {
            songSet.insert($0.emitAsCoreDataObject())
        }
        album.addToSongs(NSSet(set: songSet))
        album.parentUser = self.parentUser
        album.coverArt = self.coverArt!.jpegData(compressionQuality: 1)
        return album
    }
}
