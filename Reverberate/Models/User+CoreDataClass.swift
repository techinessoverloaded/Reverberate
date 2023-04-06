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
    public var playlists: [Playlist]?
    {
        get
        {
            guard let data = playlistsData else
            {
                return nil
            }
            guard let decodedPlaylistsData = try? JSONDecoder().decode(Dictionary<String, [String]>.self, from: data) else
            {
                return nil
            }
            var result: [Playlist] = []
            for key in decodedPlaylistsData.keys
            {
                let playlist = Playlist()
                playlist.name = key
                playlist.songs = []
                for songName in decodedPlaylistsData[key]!
                {
                    let song = DataProcessor.shared.getSong(named: songName)!
                    playlist.addSong(song)
                }
                result.append(playlist)
            }
            return result
        }
    }
    
    public var favouriteSongs: [Song]?
    {
        get
        {
            guard let data = favouriteSongsData else
            {
                return nil
            }
            guard let decodedSongsData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String] else
            {
                return nil
            }
            var result: [Song] = []
            for songName in decodedSongsData
            {
                result.append(DataProcessor.shared.getSong(named: songName)!)
            }
            return result
        }
    }
    
    public var favouriteAlbums: [Album]?
    {
        get
        {
            guard let data = favouriteAlbumsData else
            {
                return nil
            }
            guard let decodedAlbumsData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String] else
            {
                return nil
            }
            var result: [Album] = []
            for albumName in decodedAlbumsData
            {
                result.append(DataProcessor.shared.getAlbum(named: albumName)!)
            }
            return result
        }
    }
    
    public var favouriteArtists: [Artist]?
    {
        get
        {
            guard let data = favouriteArtistsData else
            {
                return nil
            }
            guard let decodedArtistsData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String] else
            {
                return nil
            }
            var result: [Artist] = []
            for artistName in decodedArtistsData
            {
                result.append(DataProcessor.shared.getArtist(named: artistName)!)
            }
            return result
        }
    }
    
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
        let songNames: [String] = existingFavSongs.map({ $0.title! })
        guard let encodedData = try?  JSONSerialization.data(withJSONObject: songNames, options: .sortedKeys) else {
            return
        }
        favouriteSongsData = encodedData
        GlobalConstants.contextSaveAction()
    }
    
    public func removeFromFavouriteSongs(_ song: Song)
    {
        var existingFavSongs = favouriteSongs!
        existingFavSongs.removeUniquely(song)
        let songNames: [String] = existingFavSongs.map({ $0.title! })
        guard let encodedData = try?  JSONSerialization.data(withJSONObject: songNames, options: .sortedKeys) else {
            return
        }
        favouriteSongsData = encodedData
        GlobalConstants.contextSaveAction()
    }
    
    public func addToFavouriteAlbums(_ album: Album)
    {
        var existingFavAlbums = favouriteAlbums!
        existingFavAlbums.appendUniquely(album)
        let albumNames: [String] = existingFavAlbums.map({ $0.name! })
        guard let encodedData = try?  JSONSerialization.data(withJSONObject: albumNames, options: .sortedKeys) else {
            return
        }
        favouriteAlbumsData = encodedData
        GlobalConstants.contextSaveAction()
    }
    
    public func removeFromFavouriteAlbums(_ album: Album)
    {
        var existingFavAlbums = favouriteAlbums!
        existingFavAlbums.removeUniquely(album)
        let albumNames: [String] = existingFavAlbums.map({ $0.name! })
        guard let encodedData = try?  JSONSerialization.data(withJSONObject: albumNames, options: .sortedKeys) else {
            return
        }
        favouriteAlbumsData = encodedData
        GlobalConstants.contextSaveAction()
    }
    
    public func addToFavouriteArtists(_ artist: Artist)
    {
        var existingFavArtists = favouriteArtists!
        existingFavArtists.appendUniquely(artist)
        let artistNames: [String] = existingFavArtists.map({ $0.name! })
        guard let encodedData = try?  JSONSerialization.data(withJSONObject: artistNames, options: .sortedKeys) else
        {
            return
        }
        favouriteArtistsData = encodedData
        GlobalConstants.contextSaveAction()
    }
    
    public func removeFromFavouriteArtists(_ artist: Artist)
    {
        var existingFavArtists = favouriteArtists!
        existingFavArtists.removeUniquely(artist)
        let artistNames: [String] = existingFavArtists.map({ $0.name! })
        guard let encodedData = try?  JSONSerialization.data(withJSONObject: artistNames, options: .sortedKeys) else {
            return
        }
        favouriteArtistsData = encodedData
        GlobalConstants.contextSaveAction()
    }
    
    public func addToPlaylists(_ playlist: Playlist)
    {
        var existingPlaylists = playlists!
        existingPlaylists.appendUniquely(playlist)
        var dictionary = Dictionary<String, [String]>()
        for playlist in existingPlaylists
        {
            let songNames = playlist.songs!.map({ $0.title! })
            dictionary[playlist.name!] = songNames
        }
        guard let encodedData = try? JSONEncoder().encode(dictionary) else {
            return
        }
        playlistsData = encodedData
        GlobalConstants.contextSaveAction()
    }
    
    public func removeFromPlaylists(_ playlist: Playlist)
    {
        var existingPlaylists = playlists!
        existingPlaylists.removeUniquely(playlist)
        var dictionary = Dictionary<String, [String]>()
        for playlist in existingPlaylists
        {
            let songNames = playlist.songs!.map({ $0.title! })
            dictionary[playlist.name!] = songNames
        }
        guard let encodedData = try? JSONEncoder().encode(dictionary) else {
            return
        }
        playlistsData = encodedData
        GlobalConstants.contextSaveAction()
    }
    
    public func add(song: Song, toPlaylistNamed playlistName: String, completionHandler: (() -> Void)? = nil)
    {
        var existingPlaylists = playlists!
        let index = existingPlaylists.firstIndex(where: { $0.name! == playlistName })!
        let requiredPlaylist = playlists![index]
        requiredPlaylist.addSong(song)
        existingPlaylists.replaceSubrange(index..<index+1, with: [requiredPlaylist])
        var dictionary = Dictionary<String, [String]>()
        for playlist in existingPlaylists
        {
            let songNames = playlist.songs!.map({ $0.title! })
            dictionary[playlist.name!] = songNames
        }
        guard let encodedData = try? JSONEncoder().encode(dictionary) else {
            return
        }
        playlistsData = encodedData
        GlobalConstants.contextSaveAction()
        completionHandler?()
    }
    
    public func remove(song: Song, fromPlaylistNamed playlistName: String, completionHandler: (() -> Void)? = nil)
    {
        var existingPlaylists = playlists!
        let index = existingPlaylists.firstIndex(where: { $0.name! == playlistName })!
        let requiredPlaylist = playlists![index]
        requiredPlaylist.removeSong(song)
        existingPlaylists.replaceSubrange(index..<index+1, with: [requiredPlaylist])
        var dictionary = Dictionary<String, [String]>()
        for playlist in existingPlaylists
        {
            let songNames = playlist.songs!.map({ $0.title! })
            dictionary[playlist.name!] = songNames
        }
        guard let encodedData = try? JSONEncoder().encode(dictionary) else {
            return
        }
        playlistsData = encodedData
        GlobalConstants.contextSaveAction()
        completionHandler?()
    }
}
