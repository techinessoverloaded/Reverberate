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
    
    static func segregateAlbums(unsegregatedSongs: [SongWrapper]) -> [AlbumWrapper]
    {
        var albums: [AlbumWrapper] = []
        for song in unsegregatedSongs
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
        print("\(albums.count) Albums")
        return albums
    }
}
