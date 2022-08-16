//
//  LibraryTabViewDelegate.swift
//  Reverberate
//
//  Created by arun-13930 on 16/08/22.
//

protocol LibraryTabViewDelegate: AnyObject
{
    func onFavouritesTabTap(_ tabView: LibraryTabView)
    func onPlaylistsTabTap(_ tabView: LibraryTabView)
}
