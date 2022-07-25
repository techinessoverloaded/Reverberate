//
//  AlbumSegregator.swift
//  Reverberate
//
//  Created by arun-13930 on 25/07/22.
//

struct AlbumSegregator
{
    //Prevent Initialization
    private init() {}
    
    static func segregateAlbums(unsortedSongs: [SongWrapper]) -> [AlbumWrapper]
    {
        var albums: [AlbumWrapper] = []
//        let availableSongs = GlobalVariables.shared.availableSongs
//        var unsortedSongs: [SongWrapper] = []
//        for language in availableSongs.keys
//        {
//            print(language)
//            for genre in availableSongs[language]!.keys
//            {
//                print(genre)
//                unsortedSongs.append(contentsOf: availableSongs[language]![genre]!)
//            }
//        }
        for song in unsortedSongs
        {
            if !albums.contains(where: { $0.name! == song.albumName! })
            {
                let newAlbum = AlbumWrapper()
                newAlbum.coverArt = song.coverArt!
                newAlbum.songs = []
                newAlbum.songs!.append(song)
                newAlbum.name = song.albumName!
                albums.append(newAlbum)
            }
            else
            {
                let existingAlbum = albums.first(where: {
                    $0.name! == song.albumName!
                })!
                existingAlbum.songs!.append(song)
            }
        }
        return albums
    }
}
