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
    
    private(set) var availableSongs: [Song] = []
    
    private(set) var availableAlbums: [Album] = []
    
    private(set) var availableArtists: [Artist] = []
    
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
                    let existingArtistType = $0.artists!.first(where: { $0 == artist })!.artistType!
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
        availableSongs = getSongs()
        availableAlbums = AlbumSegregator.segregateAlbums(unsegregatedSongs: availableSongs)
        availableArtists = getArtists()
        completionHandler?(start)
    }
}
