//
//  ContextMenuProvider.swift
//  Reverberate
//
//  Created by arun-13930 on 07/09/22.
//

import Foundation
import UIKit

class ContextMenuProvider
{
    //Singleton Instance
    public static let shared = ContextMenuProvider()
    
    private lazy var heartIcon: UIImage = {
        return UIImage(systemName: "heart")!
    }()
    
    private lazy var heartFilledIcon: UIImage = {
        return UIImage(systemName: "heart.fill")!
    }()
    
    private lazy var albumIcon: UIImage = {
        return UIImage(systemName: "square.stack")!
    }()
    
    private lazy var addToPlaylistIcon: UIImage = {
        return UIImage(systemName: "text.badge.plus")!
    }()
    
    //Prevent Instantiation
    private init() {}
    
    private func getAddSongToFavMenuItem(song: Song, requesterId: Int) -> UIAction
    {
        return UIAction(title: "Add Song to Favourites", image: heartIcon) { [unowned self] _ in
            onAddSongToFavouritesMenuItemTap(song: song, receiverId: requesterId)
        }
    }
    
    private func getRemoveSongFromFavMenuItem(song: Song, requesterId: Int) -> UIAction
    {
        return UIAction(title: "Remove Song from Favourites", image: heartFilledIcon) { [unowned self] _ in
            onRemoveSongFromFavouritesMenuItemTap(song: song, receiverId: requesterId)
        }
    }
    
    private func getAddSongToPlaylistFavMenuItem(song: Song, requesterId: Int) -> UIAction
    {
        return UIAction(title: "Add Song to Playlist", image: addToPlaylistIcon) { [unowned self] _ in
            onAddSongToPlaylistMenuItemTap(song: song, receiverId: requesterId)
        }
    }
    
    private func getShowAlbumMenuItem(song: Song, requesterId: Int) -> UIAction
    {
        return UIAction(title: "Show Album", image: albumIcon) { [unowned self] _ in
            onShowAlbumMenuItemTap(song: song, receiverId: requesterId)
        }
    }
    
    private func getAddOrRemoveSongDeferredMenuItem(song: Song, requesterId: Int) -> UIDeferredMenuElement
    {
        return UIDeferredMenuElement.uncached({ completion in
            DispatchQueue.main.async { [unowned self] in
                if GlobalVariables.shared.currentUser!.isFavouriteSong(song)
                {
                    completion([getRemoveSongFromFavMenuItem(song: song, requesterId: requesterId)])
                }
                else
                {
                    completion([getAddSongToFavMenuItem(song: song, requesterId: requesterId)])
                }
            }
        })
    }
    
    private func getAddAlbumToFavouritesMenuItem(album: Album, requesterId: Int) -> UIAction
    {
        return UIAction(title: "Add Album to Favourites", image: heartIcon) { [unowned self] _ in
            onAddAlbumToFavouritesMenuItemTap(album: album, receiverId: requesterId)
        }
    }
    
    private func getRemoveAlbumFromFavouritesMenuItem(album: Album, requesterId: Int) -> UIAction
    {
        return UIAction(title: "Remove Album from Favourites", image: heartFilledIcon) { [unowned self] _ in
            onRemoveAlbumFromFavouritesMenuItemTap(album: album, receiverId: requesterId)
        }
    }
    
    private func getAddArtistToFavouritesMenuItem(artist: Artist, requesterId: Int) -> UIAction
    {
        return UIAction(title: "Add Artist to Favourites", image: heartIcon) { [unowned self] _ in
            onAddArtistToFavouritesMenuItemTap(artist: artist, receiverId: requesterId)
        }
    }
    
    private func getRemoveArtistFromFavouritesMenuItem(artist: Artist, requesterId: Int) -> UIAction
    {
        return UIAction(title: "Remove Artist from Favourites", image: heartFilledIcon) { [unowned self] _ in
            onRemoveArtistFromFavouritesMenuItemTap(artist: artist, receiverId: requesterId)
        }
    }
    
    private func getAddOrRemoveAlbumDeferredMenuItem(album: Album, requesterId: Int) -> UIDeferredMenuElement
    {
        return UIDeferredMenuElement.uncached({ completion in
            DispatchQueue.main.async { [unowned self] in
                if GlobalVariables.shared.currentUser!.isFavouritePlaylist(album)
                {
                    completion([getRemoveAlbumFromFavouritesMenuItem(album: album, requesterId: requesterId)])
                }
                else
                {
                    completion([getAddAlbumToFavouritesMenuItem(album: album, requesterId: requesterId)])
                }
            }
        })
    }
    
    private func getAddOrRemoveArtistDeferredMenuItem(artist: Artist, requesterId: Int) -> UIDeferredMenuElement
    {
        return UIDeferredMenuElement.uncached({ completion in
            DispatchQueue.main.async { [unowned self] in
                if GlobalVariables.shared.currentUser!.isFavouriteArtist(artist)
                {
                    completion([getRemoveArtistFromFavouritesMenuItem(artist: artist, requesterId: requesterId)])
                }
                else
                {
                    completion([getAddArtistToFavouritesMenuItem(artist: artist, requesterId: requesterId)])
                }
            }
        })
    }
    
    private func getLoginForMoreOptionsMenuItem(requesterId: Int) -> UIAction
    {
        return UIAction(title: "Login to get more option(s)", image: UIImage(systemName: "person.crop.circle.fill")!,handler: { [unowned self] _ in
            onLoginRequestMenuItemTap(receiverId: requesterId)
        })
    }
    
    func getSongMenu(song: Song, requesterId: Int) -> UIMenu
    {
        return SessionManager.shared.isUserLoggedIn ? UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [
            getAddOrRemoveSongDeferredMenuItem(song: song, requesterId: requesterId),
            getAddSongToPlaylistFavMenuItem(song: song, requesterId: requesterId),
            getShowAlbumMenuItem(song: song, requesterId: requesterId)
        ]) : UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [
            getShowAlbumMenuItem(song: song, requesterId: requesterId),
            getLoginForMoreOptionsMenuItem(requesterId: requesterId)
        ])
    }
    
    func getAlbumMenu(album: Album, requesterId: Int) -> UIMenu
    {
        return SessionManager.shared.isUserLoggedIn ? UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [
            getAddOrRemoveAlbumDeferredMenuItem(album: album, requesterId: requesterId)
        ]) : UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [
            getLoginForMoreOptionsMenuItem(requesterId: requesterId)
        ])
    }
    
    func getArtistMenu(artist: Artist, requesterId: Int) -> UIMenu
    {
        return SessionManager.shared.isUserLoggedIn ? UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [
            getAddOrRemoveArtistDeferredMenuItem(artist: artist, requesterId: requesterId)
        ]) : UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [
            getLoginForMoreOptionsMenuItem(requesterId: requesterId)
        ])
    }
}

extension ContextMenuProvider
{
    @objc private func onAddSongToFavouritesMenuItemTap(song: Song, receiverId: Int)
    {
        NotificationCenter.default.post(name: .addSongToFavouritesNotification, object: nil, userInfo: ["receiverId" : receiverId,"song" : song])
    }
    
    @objc private func onRemoveSongFromFavouritesMenuItemTap(song: Song, receiverId: Int)
    {
        NotificationCenter.default.post(name: .removeSongFromFavouritesNotification, object: nil, userInfo: ["receiverId" : receiverId,"song" : song])
    }
    
    @objc private func onAddSongToPlaylistMenuItemTap(song: Song, receiverId: Int)
    {
        NotificationCenter.default.post(name: .addSongToPlaylistNotification, object: nil, userInfo: ["receiverId" : receiverId,"song" : song])
    }
    
    
    @objc private func onRemoveSongFromPlaylistMenuItemTap(song: Song, receiverId: Int)
    {
        NotificationCenter.default.post(name: .removeSongFromPlaylistNotification, object: nil, userInfo: ["receiverId" : receiverId,"song" : song])
    }
    
    @objc private func onAddAlbumToFavouritesMenuItemTap(album: Album, receiverId: Int)
    {
        NotificationCenter.default.post(name: .addAlbumToFavouritesNotification, object: nil, userInfo: ["receiverId" : receiverId,"album" : album])
    }
    
    @objc private func onRemoveAlbumFromFavouritesMenuItemTap(album: Album, receiverId: Int)
    {
        NotificationCenter.default.post(name: .removeAlbumFromFavouritesNotification, object: nil, userInfo: ["receiverId" : receiverId,"album" : album])
    }
    
    @objc private func onAddArtistToFavouritesMenuItemTap(artist: Artist, receiverId: Int)
    {
        NotificationCenter.default.post(name: .addArtistToFavouritesNotification, object: nil, userInfo: ["receiverId" : receiverId,"artist" : artist])
    }
    
    @objc private func onRemoveArtistFromFavouritesMenuItemTap(artist: Artist, receiverId: Int)
    {
        NotificationCenter.default.post(name: .removeArtistFromFavouritesNotification, object: nil, userInfo: ["receiverId" : receiverId,"artist" : artist])
    }
    
    @objc private func onShowAlbumMenuItemTap(song: Song, receiverId: Int)
    {
        NotificationCenter.default.post(name: .showAlbumTapNotification, object: nil, userInfo: ["receiverId" : receiverId,"song" : song])
    }
    
    @objc private func onLoginRequestMenuItemTap(receiverId: Int)
    {
        NotificationCenter.default.post(name: .loginRequestNotification, object: nil, userInfo: ["receiverId" : receiverId])
    }
}
