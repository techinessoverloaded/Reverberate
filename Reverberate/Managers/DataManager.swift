//
//  DataManager.swift
//  Reverberate
//
//  Created by arun-13930 on 25/07/22.
//

import Foundation
import UIKit

class DataManager
{
    // Singleton Object
    static let shared = DataManager()
    
    private(set) var availableSongs: [Song] = []
    
    private(set) var availableAlbums: [Album] = []
    
    private(set) var availableArtists: [Artist] = []
    
    private lazy var songCacheKey = "songCache"
    
    private lazy var albumCacheKey = "albumCache"
    
    private lazy var artistCacheKey = "artistCache"
    
    // Prevent Instantiation
    private init() {}
    
    private func getSongs() -> [Song]
    {
        var songFileNames: [String] = []
        var songLangGenreAndCount: [(language: Language, genre: MusicGenre, count: Int)] = []
        for language in GlobalConstants.songNames.keys
        {
            for genre in GlobalConstants.songNames[language]!.keys
            {
                let sfNames = GlobalConstants.songNames[language]![genre]!
                songFileNames.append(contentsOf: sfNames)
                songLangGenreAndCount.append((language: language, genre: genre, count: sfNames.count))
            }
        }
        return SongMetadataExtractor.extractMultipleSongs(withFileNames: songFileNames, ofLanguageGenreAndCount: songLangGenreAndCount)
    }
    
    func getArtists() -> [Artist]
    {
        var artists: [Artist] = []
        for song in availableSongs
        {
            song.artists!.forEach
            {
                artists.appendUniquely($0.copy() as! Artist)
            }
        }
        for artist in artists
        {
            let filteredSongs = availableSongs.filter({
                $0.artists!.contains(where: { $0 == artist })
            })
            if !filteredSongs.isEmpty
            {
                if artist.contributedSongs == nil
                {
                    artist.contributedSongs = []
                }
                filteredSongs.forEach({
                    artist.contributedSongs!.appendUniquely($0)
                    let existingArtistType = $0.artists!.filter({ $0 == artist }).map({ $0.artistType! }).max(by: { (a, b) in
                        return a.count < b.count
                    })!
                    if existingArtistType.count > artist.artistType!.count
                    {
                        artist.artistType = existingArtistType
                    }
                })
            }
        }
        return artists
    }
    
    func makeSongsAndAlbumsReady(onCompletion completionHandler: ((DispatchTime) -> Void)? = nil)
    {
        let start = DispatchTime.now()
        if let cachedSongs = tryRetrieveDataFromCache(typeOfData: Song.self, fileName: songCacheKey)
        {
            print("Songs available in cache")
            availableSongs = cachedSongs as! [Song]
        }
        else
        {
            availableSongs = getSongs()
            persistDataToCache(fileName: songCacheKey)
        }
        if let cachedAlbums = tryRetrieveDataFromCache(typeOfData: Album.self, fileName: albumCacheKey)
        {
            print("Albums available in cache")
            availableAlbums = cachedAlbums as! [Album]
        }
        else
        {
            availableAlbums = AlbumSegregator.segregateAlbums(unsegregatedSongs: availableSongs)
            persistDataToCache(fileName: albumCacheKey)
        }
        if let cachedArtists = tryRetrieveDataFromCache(typeOfData: Artist.self, fileName: artistCacheKey)
        {
            print("Artists available in cache")
            availableArtists = cachedArtists as! [Artist]
        }
        else
        {
            availableArtists = getArtists()
            persistDataToCache(fileName: artistCacheKey)
        }
        completionHandler?(start)
    }
    
    private func getUrlOfDataInCacheDirectory(dataFileName: String) -> URL
    {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent(dataFileName)
    }
    
    private func persistDataToCache(fileName: String)
    {
        DispatchQueue.global(qos: .background).async
        { [unowned self] in
            let dataUrl = getUrlOfDataInCacheDirectory(dataFileName: fileName)
            let objectToBeWritten: NSArray = fileName == songCacheKey ? NSArray(array: availableSongs) : ( fileName == albumCacheKey ? NSArray(array: availableAlbums) : NSArray(array: availableArtists))
            let data = try! NSKeyedArchiver.archivedData(withRootObject: objectToBeWritten, requiringSecureCoding: true)
            do
            {
                try data.write(to: dataUrl, options: .noFileProtection)
            }
            catch
            {
                print(error)
            }
        }
    }
    
    private func tryRetrieveDataFromCache<T>(typeOfData type: T, fileName: String) -> NSArray?
    {
        let dataUrl = getUrlOfDataInCacheDirectory(dataFileName: fileName)
        let data = try? Data(contentsOf: dataUrl)
        guard let data = data else { return nil }
        let objects = try! NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, Song.self, NSURL.self, Artist.self, UIImage.self, Playlist.self, Album.self, NSDate.self, NSString.self, NSNumber.self], from: data)
        guard let objects = objects else { return nil }
        if let rawArray = objects as? NSArray
        {
            return rawArray
        }
        else
        {
            return nil
        }
    }
    
    func persistRecentlyPlayedItems(songName: String, albumName: String)
    {
        var songsChanged = false
        var albumsChanged = false
        var existingSongNames = UserDefaults.standard.object(forKey: GlobalConstants.recentlyPlayedSongNames) as! [String]
        var existingAlbumNames = UserDefaults.standard.object(forKey: GlobalConstants.recentlyPlayedAlbumNames) as! [String]
        if !existingSongNames.contains(songName)
        {
            GlobalVariables.shared.recentlyPlayedSongNames.appendUniquely(songName)
            existingSongNames.append(songName)
            UserDefaults.standard.set(existingSongNames, forKey: GlobalConstants.recentlyPlayedSongNames)
            songsChanged = true
        }
        if !existingAlbumNames.contains(albumName)
        {
            GlobalVariables.shared.recentlyPlayedAlbumNames.appendUniquely(albumName)
            existingAlbumNames.append(albumName)
            UserDefaults.standard.set(existingAlbumNames, forKey: GlobalConstants.recentlyPlayedAlbumNames)
            albumsChanged = true
        }
        if songsChanged || albumsChanged
        {
            NotificationCenter.default.post(name: .recentlyPlayedListChangedNotification, object: nil)
        }
    }
    
    func retrieveRecentlyPlayedItems()
    {
        let existingSongNames = UserDefaults.standard.object(forKey: GlobalConstants.recentlyPlayedSongNames) as! [String]
        let existingAlbumNames = UserDefaults.standard.object(forKey: GlobalConstants.recentlyPlayedAlbumNames) as! [String]
        GlobalVariables.shared.recentlyPlayedSongNames = existingSongNames
        GlobalVariables.shared.recentlyPlayedAlbumNames = existingAlbumNames
        NotificationCenter.default.post(name: .recentlyPlayedListChangedNotification, object: nil)
    }
    
    func clearRecentlyPlayedItems()
    {
        GlobalVariables.shared.recentlyPlayedSongNames = []
        GlobalVariables.shared.recentlyPlayedAlbumNames = []
        UserDefaults.standard.set([], forKey: GlobalConstants.recentlyPlayedSongNames)
        UserDefaults.standard.set([], forKey: GlobalConstants.recentlyPlayedAlbumNames)
    }
}
