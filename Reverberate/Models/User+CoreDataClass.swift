//
//  User+CoreDataClass.swift
//  Reverberate
//
//  Created by arun-13930 on 08/09/22.
//
//

import Foundation
import CoreData


public class User: NSManagedObject
{
    public func isFavouriteSong(_ song: Song) -> Bool
    {
        return favouriteSongs!.contains(song)
    }
    
    public func isFavouritePlaylist(_ playlist: Playlist) -> Bool
    {
        return favouritePlaylists!.contains(playlist)
    }
    
    public func isFavouriteArtist(_ artist: Artist) -> Bool
    {
        return favouriteArtists!.contains(artist)
    }
}
