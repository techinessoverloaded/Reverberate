//
//  QueryProcessor.swift
//  Reverberate
//
//  Created by arun-13930 on 27/07/22.
//

import Foundation

class DataProcessor
{
    //Singleton
    static let shared = DataProcessor()
    
    //Prevent Initialization
    private init() {}
    
    func getAlbumBy(albumName: String) -> Album?
    {
        return DataManager.shared.availableAlbums.first(where: { $0.name! == albumName })
    }
    
    func getSongsThatSatisfy(theQuery query: String) -> [Song]?
    {
        var result: [Song] = []
        for song in DataManager.shared.availableSongs
        {
            if song.albumName!.lowercased().contains(query) || song.title!.lowercased().contains(query) || song.language!.description.lowercased().contains(query) || song.genre!.description.lowercased().contains(query) || song.artists!.contains(where: { $0.name!.lowercased().contains(query) })
            {
                result.appendUniquely(song)
            }
        }
        return result.isEmpty ? nil : result.sorted()
    }
    
    func getAlbumsThatSatisfy(theQuery query: String) -> [Album]?
    {
        var result: [Album] = []
        for album in DataManager.shared.availableAlbums
        {
            if album.name!.lowercased().contains(query) || album.songs!.contains(where: {
                $0.title!.lowercased().contains(query) ||
                $0.language!.description.lowercased().contains(query) ||
                $0.genre!.description.lowercased().contains(query) ||
                $0.artists!.contains(where: { $0.name!.lowercased().contains(query)})})
            {
                result.appendUniquely(album)
            }
        }
        return result.isEmpty ? nil : result.sorted()
    }
    
    func getArtistsThatSatisfy(theQuery query: String) -> [Artist]?
    {
        var result: [Artist] = []
        for artist in DataManager.shared.availableArtists
        {
            if artist.name!.lowercased().contains(query) || artist.artistType!.description.contains(query)
            {
                result.appendUniquely(artist)
            }
        }
        return result.isEmpty ? nil : result.sorted()
    }
    
    func getAlbumsInvolving(artist artistName: String) -> [Album]
    {
        var result: [Album] = []
        for album in DataManager.shared.availableAlbums
        {
            if  album.composers!.contains(where: { $0.name! == artistName }) || album.songs!.contains(where: { $0.artists!.contains(where: {$0.name! == artistName}) })
            {
                result.appendUniquely(album)
            }
        }
        return result
    }
    
    func getSongsOf(category: Category, andLimitNumberOfResultsTo limit: Int = -1) -> [Song]
    {
        var result: [Song] = []
        switch category
        {
        case .newReleases:
            DataManager.shared.availableSongs.forEach
            {
                if getAlbumBy(albumName: $0.albumName!)!.releaseDate!.get(.year) == Calendar.currentYear
                {
                    result.append($0)
                }
            }
        case .starter:
            result.append(contentsOf: DataManager.shared.availableSongs.shuffled())
        case .topCharts:
            result.append(contentsOf: DataManager.shared.availableSongs.shuffled())
        case .tamil:
            result.append(contentsOf: DataManager.shared.availableSongs.filter({ $0.language! == .tamil }))
        case .malayalam:
            result.append(contentsOf: DataManager.shared.availableSongs.filter({ $0.language! == .malayalam }))
        case .kannada:
            result.append(contentsOf: DataManager.shared.availableSongs.filter({ $0.language! == .kannada }))
        case .telugu:
            result.append(contentsOf: DataManager.shared.availableSongs.filter({ $0.language! == .telugu }))
        case .hindi:
            result.append(contentsOf: DataManager.shared.availableSongs.filter({ $0.language! == .hindi }))
        case .melody:
            result.append(contentsOf: DataManager.shared.availableSongs.filter({ $0.genre! == .melody }))
        case .western:
            result.append(contentsOf: DataManager.shared.availableSongs.filter({ $0.genre! == .western }))
        case .classical:
            result.append(contentsOf: DataManager.shared.availableSongs.filter({ $0.genre! == .classical }))
        case .rock:
            result.append(contentsOf: DataManager.shared.availableSongs.filter({ $0.genre! == .rock }))
        case .folk:
            result.append(contentsOf: DataManager.shared.availableSongs.filter({ $0.genre! == .folk }))
        case .recentlyPlayed:
            result.append(contentsOf: DataManager.shared.availableSongs.shuffled())
        }
        return limit == -1 ? result : Array(result[0..<min(limit, result.count)])
    }
    
    func getAlbumsOf(category: Category) -> [Album]
    {
        var result: [Album] = []
        switch category
        {
        case .starter:
            result.append(contentsOf: DataManager.shared.availableAlbums.shuffled())
        case .newReleases:
            result.append(contentsOf:  DataManager.shared.availableAlbums.filter {
                $0.releaseDate!.get(.year) == Calendar.currentYear
            })
        case .topCharts:
            result.append(contentsOf: DataManager.shared.availableAlbums.shuffled())
        case .tamil:
            result.append(contentsOf: DataManager.shared.availableAlbums.filter{ $0.songs!.contains(where: { $0.language! == .tamil }) })
        case .malayalam:
            result.append(contentsOf: DataManager.shared.availableAlbums.filter{ $0.songs!.contains(where: { $0.language! == .malayalam }) })
        case .kannada:
            result.append(contentsOf: DataManager.shared.availableAlbums.filter{ $0.songs!.contains(where: { $0.language! == .kannada }) })
        case .telugu:
            result.append(contentsOf: DataManager.shared.availableAlbums.filter{ $0.songs!.contains(where: { $0.language! == .telugu }) })
        case .hindi:
            result.append(contentsOf: DataManager.shared.availableAlbums.filter{ $0.songs!.contains(where: { $0.language! == .hindi }) })
        case .melody:
            result.append(contentsOf: DataManager.shared.availableAlbums.filter{ $0.songs!.contains(where: { $0.genre! == .melody }) })
        case .western:
            result.append(contentsOf: DataManager.shared.availableAlbums.filter{ $0.songs!.contains(where: { $0.genre! == .western }) })
        case .classical:
            result.append(contentsOf: DataManager.shared.availableAlbums.filter{ $0.songs!.contains(where: { $0.genre! == .classical }) })
        case .rock:
            result.append(contentsOf: DataManager.shared.availableAlbums.filter{ $0.songs!.contains(where: { $0.genre! == .rock }) })
        case .folk:
            result.append(contentsOf: DataManager.shared.availableAlbums.filter{ $0.songs!.contains(where: { $0.genre! == .folk }) })
        case .recentlyPlayed:
            result.append(contentsOf: DataManager.shared.availableAlbums.shuffled())
        }
        return result
    }
}
