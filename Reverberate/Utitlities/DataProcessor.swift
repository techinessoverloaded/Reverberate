//
//  QueryProcessor.swift
//  Reverberate
//
//  Created by arun-13930 on 27/07/22.
//

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
    
    func getArtistsThatSatisfy(theQuery query: String) -> [ArtistClass]?
    {
        var result: [ArtistClass] = []
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
}
