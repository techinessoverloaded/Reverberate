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
    
    public func isUserPlaylist(_ playlist: Playlist) -> Bool
    {
        return userPlaylists!.contains(playlist)
    }
    
    public func isFavouriteAlbum(_ album: Album) -> Bool
    {
        return favouriteAlbums!.contains(album)
    }
    
    public func isFavouriteArtist(_ artist: Artist) -> Bool
    {
        return favouriteArtists!.contains(artist)
    }
}
