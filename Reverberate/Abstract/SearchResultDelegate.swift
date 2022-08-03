//
//  SearchResultDelegate.swift
//  Reverberate
//
//  Created by arun-13930 on 29/07/22.
//

protocol SearchResultDelegate: AnyObject
{
    func onArtistSelection(selectedArtist: ArtistWrapper)
    
    func onAlbumSelection(selectedAlbum: AlbumWrapper)
}