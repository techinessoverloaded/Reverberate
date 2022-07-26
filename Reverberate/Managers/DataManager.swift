//
//  DataManager.swift
//  Reverberate
//
//  Created by arun-13930 on 25/07/22.
//

import Foundation

class DataManager
{
    // Singleton Object
    static let shared = DataManager()
    
    private static let songCacheKey: NSString = "songCacheKey"
    
    private static let albumCacheKey: NSString = "albumCacheKey"
    
    private(set) var availableSongs: [SongWrapper] = []
    
    private(set) var availableAlbums: [AlbumWrapper] = []
    
    private lazy var songCache: NSCache<NSString, NSArray> = NSCache<NSString, NSArray>()
    
    private lazy var albumCache: NSCache<NSString, NSArray> = NSCache<NSString, NSArray>()
    
    // Prevent Instantiation
    private init() {}
    
    private func getSongs() -> [SongWrapper]
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
    
    private func tryObtainCachedSongs() -> [SongWrapper]?
    {
        var songs: [SongWrapper] = []
        if let cachedVersion = songCache.object(forKey: DataManager.songCacheKey)
        {
            songs = cachedVersion as! [SongWrapper]
            return songs
        }
        else
        {
            return nil
        }
    }
    
    private func tryObtainCachedAlbums() -> [AlbumWrapper]?
    {
        var albums: [AlbumWrapper] = []
        if let cachedVersion = albumCache.object(forKey: DataManager.albumCacheKey)
        {
            albums = cachedVersion as! [AlbumWrapper]
            return albums
        }
        else
        {
            return nil
        }
    }
    
    func makeSongsAndAlbumsReady()
    {
        let songCache = NSCache<NSString, NSArray>()
        var songs: [SongWrapper]? = tryObtainCachedSongs()
        var albums: [AlbumWrapper]?
        if let songs = songs
        {
            availableSongs = songs
            albums = tryObtainCachedAlbums()
            if let albums = albums
            {
                availableAlbums = albums
            }
            else
            {
                albums = AlbumSegregator.segregateAlbums(unsegregatedSongs: availableSongs)
                availableAlbums = albums!
                albumCache.setObject(albums! as NSArray, forKey: DataManager.albumCacheKey)
            }
        }
        else
        {
            songs = getSongs()
            songCache.setObject(songs! as NSArray, forKey: DataManager.songCacheKey)
            availableSongs = songs!
            albums = AlbumSegregator.segregateAlbums(unsegregatedSongs: availableSongs)
            availableAlbums = albums!
            albumCache.setObject(albums! as NSArray, forKey: DataManager.albumCacheKey)
        }
    }
}
