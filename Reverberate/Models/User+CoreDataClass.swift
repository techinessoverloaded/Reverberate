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
        return playlists!.contains(playlist)
    }
    
    public func isFavouriteAlbum(_ album: Album) -> Bool
    {
        return favouriteAlbums!.contains(album)
    }
    
    public func isFavouriteArtist(_ artist: Artist) -> Bool
    {
        return favouriteArtists!.contains(artist)
    }
    
    public func addToFavouriteSongs(_ song: Song)
    {
        var existingFavSongs = favouriteSongs!
        existingFavSongs.appendUniquely(song)
        favouriteSongs = existingFavSongs
        GlobalConstants.contextSaveAction()
    }
    
    public func removeFromFavouriteSongs(_ song: Song)
    {
        var existingFavSongs = favouriteSongs!
        existingFavSongs.removeUniquely(song)
        favouriteSongs = existingFavSongs
        GlobalConstants.contextSaveAction()
    }
    
    public func addToFavouriteAlbums(_ album: Album)
    {
        var existingFavAlbums = favouriteAlbums!
        existingFavAlbums.appendUniquely(album)
        favouriteAlbums = existingFavAlbums
        GlobalConstants.contextSaveAction()
    }
    
    public func removeFromFavouriteAlbums(_ album: Album)
    {
        var existingFavAlbums = favouriteAlbums!
        existingFavAlbums.removeUniquely(album)
        favouriteAlbums = existingFavAlbums
        GlobalConstants.contextSaveAction()
    }
    
    public func addToFavouriteArtists(_ artist: Artist)
    {
        var existingFavArtists = favouriteArtists!
        existingFavArtists.appendUniquely(artist)
        favouriteArtists = existingFavArtists
        GlobalConstants.contextSaveAction()
    }
    
    public func removeFromFavouriteArtists(_ artist: Artist)
    {
        var existingFavArtists = favouriteArtists!
        existingFavArtists.removeUniquely(artist)
        favouriteArtists = existingFavArtists
        GlobalConstants.contextSaveAction()
    }
    
    public func addToPlaylists(_ playlist: Playlist)
    {
        var existingPlaylists = playlists!
        existingPlaylists.appendUniquely(playlist)
        playlists = existingPlaylists
        GlobalConstants.contextSaveAction()
    }
    
    public func removeFromPlaylists(_ playlist: Playlist)
    {
        var existingPlaylists = playlists!
        existingPlaylists.removeUniquely(playlist)
        playlists = existingPlaylists
        GlobalConstants.contextSaveAction()
    }
    
    public func add(song: Song, toPlaylistNamed playlistName: String, completionHandler: (() -> Void)? = nil)
    {
        var existingPlaylists = playlists!
        let index = existingPlaylists.firstIndex(where: { $0.name! == playlistName })!
        let requiredPlaylist = playlists![index]
        requiredPlaylist.addSong(song)
        existingPlaylists.replaceSubrange(index..<index+1, with: [requiredPlaylist])
        playlists = existingPlaylists
        GlobalConstants.contextSaveAction()
        completionHandler?()
    }
    
    public func remove(song: Song, fromPlaylistNamed playlistName: String)
    {
        var existingPlaylists = playlists!
        let index = existingPlaylists.firstIndex(where: { $0.name! == playlistName })!
        let requiredPlaylist = playlists![index]
        requiredPlaylist.removeSong(song)
        existingPlaylists.replaceSubrange(index..<index+1, with: [requiredPlaylist])
        playlists = existingPlaylists
        GlobalConstants.contextSaveAction()
    }
}
