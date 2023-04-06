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
    
    func getAlbum(named albumName: String) -> Album?
    {
        return DataManager.shared.availableAlbums.first(where: { $0.name! == albumName })
    }
    
    func getAlbumThat(containsSong songName: String) -> Album?
    {
        return DataManager.shared.availableAlbums.first(where: { $0.songs!.contains(where: { $0.title! == songName }) })
    }
    
    func getArtist(named artistName: String) -> Artist?
    {
        return DataManager.shared.availableArtists.first(where: { $0.name! == artistName })
    }
    
    func getSong(named songName: String) -> Song?
    {
        return DataManager.shared.availableSongs.first(where: { $0.title! == songName })
    }
    
//    func getSongsThatSatisfy2(theQuery query: String, songSource: [Song]? = nil) -> [Song]?
//    {
//        var result: [Song] = []
//        let songs = songSource != nil ? songSource! : DataManager.shared.availableSongs
//        for song in songs
//        {
//            if song.albumName!.lowercased().contains(query) || song.title!.lowercased().contains(query) || song.language.description.lowercased().contains(query) || song.genre.description.lowercased().contains(query) || song.artists!.contains(where: { $0.name!.lowercased().contains(query) })
//            {
//                result.appendUniquely(song)
//            }
//        }
//        return result.isEmpty ? nil : result.sorted()
//    }
    
    func getSongsThatSatisfy(theQuery query: String, songSource: [Song]? = nil) -> [SongSearchResult]?
    {
        var result: [SongSearchResult] = []
        let songs = songSource != nil ? songSource! : DataManager.shared.availableSongs
        let keyword = query.lowercased()
        for song in songs
        {
            var resultObj = SongSearchResult(song: song)
            if song.title!.lowercased().contains(keyword)
            {
                let range = (song.title! as NSString).range(of: keyword, options: .caseInsensitive)
                resultObj.titleRange = range
            }
            if song.getArtistNamesAsString(artistType: nil).lowercased().contains(keyword)
            {
                let range = (song.getArtistNamesAsString(artistType: nil) as NSString).range(of: keyword, options: .caseInsensitive)
                resultObj.artistsRange = range
            }
            if resultObj.titleRange != nil || resultObj.artistsRange != nil
            {
                result.append(resultObj)
            }
        }
        return result.isEmpty ? nil : result.sorted(by: {
            $0.song < $1.song
        })
    }
    
//    func getAlbumsThatSatisfy2(theQuery query: String, albumSource: [Album]? = nil) -> [Album]?
//    {
//        var result: [Album] = []
//        let albums = albumSource != nil ? albumSource! : DataManager.shared.availableAlbums
//        for album in albums
//        {
//            if album.name!.lowercased().contains(query) || album.songs!.contains(where: {
//                $0.title!.lowercased().contains(query) ||
//                $0.language.description.lowercased().contains(query) ||
//                $0.genre.description.lowercased().contains(query) ||
//                $0.artists!.contains(where: { $0.name!.lowercased().contains(query)})})
//            {
//                result.appendUniquely(album)
//            }
//        }
//        return result.isEmpty ? nil : result.sorted()
//    }
    
    func getAlbumsThatSatisfy(theQuery query: String, albumSource: [Album]? = nil) -> [AlbumSearchResult]?
    {
        var result: [AlbumSearchResult] = []
        let albums = albumSource != nil ? albumSource! : DataManager.shared.availableAlbums
        let keyword = query.lowercased()
        for album in albums
        {
            var resultObj = AlbumSearchResult(album: album)
            if album.name!.lowercased().contains(keyword)
            {
                let range = (album.name! as NSString).range(of: keyword, options: .caseInsensitive)
                resultObj.nameRange = range
            }
            if album.composerNames.lowercased().contains(keyword)
            {
                let range = (album.composerNames as NSString).range(of: keyword, options: .caseInsensitive)
                resultObj.composersRange = range
            }
            if resultObj.nameRange != nil || resultObj.composersRange != nil
            {
                result.append(resultObj)
            }
        }
        return result.isEmpty ? nil : result.sorted(by: {
            $0.album < $1.album
        })
    }
    
//    func getPlaylistsThatSatisfy2(theQuery query: String) -> [Playlist]?
//    {
//        var result: [Playlist] = []
//        let playlists = GlobalVariables.shared.currentUser!.playlists!
//        for playlist in playlists
//        {
//            if playlist.name!.lowercased().contains(query) || playlist.songs!.contains(where: {
//                $0.title!.lowercased().contains(query) ||
//                $0.language.description.lowercased().contains(query) ||
//                $0.genre.description.lowercased().contains(query) ||
//                $0.artists!.contains(where: { $0.name!.lowercased().contains(query)})})
//            {
//                result.appendUniquely(playlist)
//            }
//        }
//        return result.isEmpty ? nil : result.sorted()
//    }
    
//    func getArtistsThatSatisfy2(theQuery query: String, artistSource: [Artist]? = nil) -> [Artist]?
//    {
//        var result: [Artist] = []
//        let artists = artistSource != nil ? artistSource! : DataManager.shared.availableArtists
//        for artist in artists
//        {
//            if artist.name!.lowercased().contains(query) || artist.artistType!.description.contains(query)
//            {
//                result.appendUniquely(artist)
//            }
//        }
//        return result.isEmpty ? nil : result.sorted()
//    }
    
    func getPlaylistsThatSatisfy(theQuery query: String) -> [PlaylistSearchResult]?
    {
        var result: [PlaylistSearchResult] = []
        let playlists = GlobalVariables.shared.currentUser!.playlists!
        let keyword = query.lowercased()
        for playlist in playlists
        {
            var resultObj = PlaylistSearchResult(playlist: playlist)
            if playlist.name!.lowercased().contains(keyword)
            {
                let range = (playlist.name! as NSString).range(of: keyword, options: .caseInsensitive)
                resultObj.nameRange = range
            }
            if resultObj.nameRange != nil
            {
                result.append(resultObj)
            }
        }
        return result.isEmpty ? nil : result.sorted(by: {
            $0.playlist < $1.playlist
        })
    }
    
    func getArtistsThatSatisfy(theQuery query: String, artistSource: [Artist]? = nil) -> [ArtistSearchResult]?
    {
        var result: [ArtistSearchResult] = []
        let artists = artistSource != nil ? artistSource! : DataManager.shared.availableArtists
        let keyword = query.lowercased()
        for artist in artists
        {
            var resultObj = ArtistSearchResult(artist: artist)
            if artist.name!.lowercased().contains(keyword)
            {
                let range = (artist.name! as NSString).range(of: keyword, options: .caseInsensitive)
                resultObj.nameRange = range
            }
            if resultObj.nameRange != nil
            {
                result.append(resultObj)
            }
        }
        return result.isEmpty ? nil : result.sorted(by: {
            $0.artist < $1.artist
        })
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
                if getAlbum(named: $0.albumName!)!.releaseDate!.get(.year) >= 2022
                {
                    result.append($0)
                }
            }
        case .starter:
            result.append(contentsOf: DataManager.shared.availableSongs.shuffled())
        case .topCharts:
            result.append(contentsOf: DataManager.shared.availableSongs.shuffled())
        case .tamil:
            result.append(contentsOf: DataManager.shared.availableSongs.filter({ $0.language == .tamil }))
        case .malayalam:
            result.append(contentsOf: DataManager.shared.availableSongs.filter({ $0.language == .malayalam }))
        case .kannada:
            result.append(contentsOf: DataManager.shared.availableSongs.filter({ $0.language == .kannada }))
        case .telugu:
            result.append(contentsOf: DataManager.shared.availableSongs.filter({ $0.language == .telugu }))
        case .hindi:
            result.append(contentsOf: DataManager.shared.availableSongs.filter({ $0.language == .hindi }))
        case .melody:
            result.append(contentsOf: DataManager.shared.availableSongs.filter({ $0.genre == .melody }))
        case .western:
            result.append(contentsOf: DataManager.shared.availableSongs.filter({ $0.genre == .western }))
        case .classical:
            result.append(contentsOf: DataManager.shared.availableSongs.filter({ $0.genre == .classical }))
        case .rock:
            result.append(contentsOf: DataManager.shared.availableSongs.filter({ $0.genre == .rock }))
        case .folk:
            result.append(contentsOf: DataManager.shared.availableSongs.filter({ $0.genre == .folk }))
        case .recentlyPlayed:
            GlobalVariables.shared.recentlyPlayedSongNames.reversed().forEach{
                result.append(getSong(named: $0)!)
            }
        case .none:
            break
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
            result.append(contentsOf: DataManager.shared.availableAlbums.filter{ $0.songs!.contains(where: { $0.language == .tamil }) })
        case .malayalam:
            result.append(contentsOf: DataManager.shared.availableAlbums.filter{ $0.songs!.contains(where: { $0.language == .malayalam }) })
        case .kannada:
            result.append(contentsOf: DataManager.shared.availableAlbums.filter{ $0.songs!.contains(where: { $0.language == .kannada }) })
        case .telugu:
            result.append(contentsOf: DataManager.shared.availableAlbums.filter{ $0.songs!.contains(where: { $0.language == .telugu }) })
        case .hindi:
            result.append(contentsOf: DataManager.shared.availableAlbums.filter{ $0.songs!.contains(where: { $0.language == .hindi }) })
        case .melody:
            result.append(contentsOf: DataManager.shared.availableAlbums.filter{ $0.songs!.contains(where: { $0.genre == .melody }) })
        case .western:
            result.append(contentsOf: DataManager.shared.availableAlbums.filter{ $0.songs!.contains(where: { $0.genre == .western }) })
        case .classical:
            result.append(contentsOf: DataManager.shared.availableAlbums.filter{ $0.songs!.contains(where: { $0.genre == .classical }) })
        case .rock:
            result.append(contentsOf: DataManager.shared.availableAlbums.filter{ $0.songs!.contains(where: { $0.genre == .rock }) })
        case .folk:
            result.append(contentsOf: DataManager.shared.availableAlbums.filter{ $0.songs!.contains(where: { $0.genre == .folk }) })
        case .recentlyPlayed:
            GlobalVariables.shared.recentlyPlayedAlbumNames.reversed().forEach{
                result.append(getAlbum(named: $0)!)
            }
        case .none:
            break
        }
        return result
    }
    
    func getSortedSongsThatSatisfy(theQuery query: String, songSource: [Song]? = nil) -> [Alphabet : [SongSearchResult]]
    {
        let unsortedSongs = getSongsThatSatisfy(theQuery: query, songSource: songSource)
        guard let unsortedSongs = unsortedSongs else
        {
            return [:]
        }
        var result: [Alphabet : [SongSearchResult]] = [:]
        for alphabet in Alphabet.allCases
        {
            let letter = alphabet.asString
            result[alphabet] = unsortedSongs.filter({
                $0.song.title!.hasPrefix(letter) }).sorted(by: {
                    $0.song < $1.song
                })
        }
        return result
    }
    
    func getSortedAlbumsThatSatisfy(theQuery query: String, albumSource: [Album]? = nil) -> [Alphabet : [AlbumSearchResult]]
    {
        let unsortedAlbums = getAlbumsThatSatisfy(theQuery: query, albumSource: albumSource)
        guard let unsortedAlbums = unsortedAlbums else
        {
            return [:]
        }
        var result: [Alphabet : [AlbumSearchResult]] = [:]
        for alphabet in Alphabet.allCases
        {
            let letter = alphabet.asString
            result[alphabet] = unsortedAlbums.filter({ $0.album.name!.hasPrefix(letter) }).sorted(by: {
                $0.album < $1.album
            })
        }
        return result
    }
    
    func getSortedPlaylistsThatSatisfy(theQuery query: String) -> [Alphabet : [PlaylistSearchResult]]
    {
        let unsortedPlaylists = getPlaylistsThatSatisfy(theQuery: query)
        guard let unsortedPlaylists = unsortedPlaylists else
        {
            return [:]
        }
        var result: [Alphabet : [PlaylistSearchResult]] = [:]
        for alphabet in Alphabet.allCases
        {
            let letter = alphabet.asString.lowercased()
            result[alphabet] = unsortedPlaylists.filter({ $0.playlist.name!.hasPrefix(letter) }).sorted(by: {
                $0.playlist < $1.playlist
            })
        }
        return result
    }
    
    func getSortedArtistsThatSatisfy(theQuery query: String, artistSource: [Artist]? = nil) -> [Alphabet : [ArtistSearchResult]]
    {
        let unsortedArtists = getArtistsThatSatisfy(theQuery: query, artistSource: artistSource)
        guard let unsortedArtists = unsortedArtists else
        {
            return [:]
        }
        var result: [Alphabet : [ArtistSearchResult]] = [:]
        for alphabet in Alphabet.allCases
        {
            let letter = alphabet.asString
            result[alphabet] = unsortedArtists.filter({ $0.artist.name!.hasPrefix(letter) }).sorted(by: {
                $0.artist < $1.artist
            })
        }
        return result
    }
}
