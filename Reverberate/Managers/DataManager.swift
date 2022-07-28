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
    
    private(set) var availableSongs: [SongWrapper] = []
    
    private(set) var availableAlbums: [AlbumWrapper] = []
    
    private(set) var availableArtists: [ArtistWrapper] = []
    
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
    
    func makeSongsAndAlbumsReady(onCompletion completionHandler: ((DispatchTime) -> Void)? = nil)
    {
        let start = DispatchTime.now()
        availableSongs = getSongs()
        availableAlbums = AlbumSegregator.segregateAlbums(unsegregatedSongs: availableSongs)
        var artistSet: Set<ArtistWrapper> = []
        for song in availableSongs
        {
            song.artists!.forEach {
                if !artistSet.contains($0)
                {
                    artistSet.insert($0)
                }
            }
        }
        availableArtists = Array(artistSet)
        completionHandler?(start)
    }
}
