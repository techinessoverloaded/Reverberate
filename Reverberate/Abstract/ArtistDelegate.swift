//
//  ArtistDelegate.swift
//  Reverberate
//
//  Created by arun-13930 on 02/08/22.
//

protocol ArtistDelegate: AnyObject
{
    func onFavouriteButtonTap(artist: Artist, shouldMakeAsFavourite: Bool)
}
