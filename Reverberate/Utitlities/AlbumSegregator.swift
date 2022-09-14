//
//  AlbumSegregator.swift
//  Reverberate
//
//  Created by arun-13930 on 25/07/22.
//

import Foundation

struct AlbumSegregator
{
    //Prevent Initialization
    private init() {}
    
    static func segregateAlbums(unsegregatedSongs: [Song]) -> [Album]
    {
        var albums: [Album] = []
        for song in unsegregatedSongs
        {
            if !albums.contains(where: { $0.name! == song.albumName! })
            {
                let newAlbum = Album()
                newAlbum.coverArt = song.coverArt
                newAlbum.setSongs([])
                newAlbum.addSong(song)
                newAlbum.name = song.albumName!
                newAlbum.releaseDate = DateFormatter.getDateFromString(dateString: GlobalConstants.albumReleaseDates[newAlbum.name!]!)
                newAlbum.composers = song.getArtists(ofType: .musicDirector)
                albums.append(newAlbum)
            }
            else
            {
                let existingAlbum = albums.first(where: {
                    $0.name! == song.albumName!
                })!
                existingAlbum.addSong(song)
            }
        }
        print("\(albums.count) Albums")
        return albums
    }
}
