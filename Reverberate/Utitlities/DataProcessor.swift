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
    
    func getSongsThatSatisfy(theQuery query: String) -> [SongWrapper]?
    {
        var resultSet: Set<SongWrapper> = []
        for song in DataManager.shared.availableSongs
        {
            if song.albumName!.lowercased().contains(query) || song.title!.lowercased().contains(query) || song.language!.description.lowercased().contains(query) || song.genre!.description.lowercased().contains(query) || song.artists!.contains(where: { $0.name!.lowercased().contains(query) })
            {
                resultSet.insert(song)
            }
        }
        return resultSet.isEmpty ? nil : Array(resultSet).sorted()
    }
    
    func getAlbumsThatSatisfy(theQuery query: String) -> [AlbumWrapper]?
    {
        var resultSet: Set<AlbumWrapper> = []
        for album in DataManager.shared.availableAlbums
        {
            if album.name!.lowercased().contains(query) || album.songs!.contains(where: {
                $0.title!.lowercased().contains(query) ||
                $0.language!.description.lowercased().contains(query) ||
                $0.genre!.description.lowercased().contains(query) ||
                $0.artists!.contains(where: { $0.name!.lowercased().contains(query)})})
            {
                resultSet.insert(album)
            }
        }
        return resultSet.isEmpty ? nil : Array(resultSet).sorted()
    }
    
    func getArtistsThatSatisfy(theQuery query: String) -> [ArtistWrapper]?
    {
        var resultSet: Set<ArtistWrapper> = []
        for artist in DataManager.shared.availableArtists
        {
            if artist.name!.lowercased().contains(query) || artist.artistType!.description.contains(query)
            {
                resultSet.insert(artist)
            }
        }
        return resultSet.isEmpty ? nil : Array(resultSet).sorted()
    }
}
