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
        let mutableFavSongs: NSMutableArray = favouriteSongs!.mutableCopy() as! NSMutableArray
        mutableFavSongs.add(song)
        favouriteSongs = mutableFavSongs
        GlobalConstants.contextSaveAction()
    }
    
    public func removeFromFavouriteSongs(_ song: Song)
    {
        let mutableFavSongs: NSMutableArray = favouriteSongs!.mutableCopy() as! NSMutableArray
        mutableFavSongs.remove(song)
        favouriteSongs = mutableFavSongs
        GlobalConstants.contextSaveAction()
    }
    
    public func addToFavouriteAlbums(_ album: Album)
    {
        let mutableFavAlbums: NSMutableArray = favouriteAlbums!.mutableCopy() as! NSMutableArray
        mutableFavAlbums.add(album)
        favouriteAlbums = mutableFavAlbums
        GlobalConstants.contextSaveAction()
    }
    
    public func removeFromFavouriteAlbums(_ album: Album)
    {
        let mutableFavAlbums: NSMutableArray = favouriteAlbums!.mutableCopy() as! NSMutableArray
        mutableFavAlbums.remove(album)
        favouriteAlbums = mutableFavAlbums
        GlobalConstants.contextSaveAction()
    }
    
    public func addToFavouriteArtists(_ artist: Artist)
    {
        let mutableFavArtists: NSMutableArray = favouriteArtists!.mutableCopy() as! NSMutableArray
        mutableFavArtists.add(artist)
        favouriteArtists = mutableFavArtists
        GlobalConstants.contextSaveAction()
    }
    
    public func removeFromFavouriteArtists(_ artist: Artist)
    {
        let mutableFavArtists: NSMutableArray = favouriteArtists!.mutableCopy() as! NSMutableArray
        mutableFavArtists.remove(artist)
        favouriteArtists = mutableFavArtists
        GlobalConstants.contextSaveAction()
    }
    
    public func addToPlaylists(_ playlist: Playlist)
    {
        let mutablePlaylists: NSMutableArray = playlists!.mutableCopy() as! NSMutableArray
        mutablePlaylists.add(playlist)
        playlists = mutablePlaylists
        GlobalConstants.contextSaveAction()
    }
    
    public func removeFromPlaylists(_ playlist: Playlist)
    {
        let mutablePlaylists: NSMutableArray = playlists!.mutableCopy() as! NSMutableArray
        mutablePlaylists.remove(playlist)
        playlists = mutablePlaylists
        GlobalConstants.contextSaveAction()
    }
    
    public func add(song: Song, toPlaylistNamed playlistName: String, completionHandler: (() -> Void)? = nil)
    {
        let mutablePlaylists: NSMutableArray = playlists!.mutableCopy() as! NSMutableArray
        let index = mutablePlaylists.indexOfObject(passingTest: { object, _, _ in
            let playlist = object as! Playlist
            return playlist.name! == playlistName
        })
        let requiredPlaylist = playlists![index] as! Playlist
        requiredPlaylist.addSong(song)
        requiredPlaylist.addSongName(song.title!)
        mutablePlaylists.replaceObject(at: index, with: requiredPlaylist)
        playlists = (mutablePlaylists.copy() as! NSArray)
        GlobalConstants.contextSaveAction()
        completionHandler?()
    }
}
