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
    
    private func getAddSongToPlaylistFavMenuItem(song: Song, requesterId: Int, requiresTranslucentSelectionScreen: Bool = false) -> UIAction
    {
        return UIAction(title: "Add Song to Playlist", image: addToPlaylistIcon) { [unowned self] _ in
            onAddSongToPlaylistMenuItemTap(song: song, receiverId: requesterId, requiresTranslucentSelectionScreen: requiresTranslucentSelectionScreen)
        }
    }
    
    private func getRemoveSongFromPlaylistMenuItem(song: Song, playlist: Playlist, requesterId: Int) -> UIAction
    {
        return UIAction(title: "Remove Song From Current Playlist", image: addToPlaylistIcon) { [unowned self] _ in
            onRemoveSongFromPlaylistMenuItemTap(song: song, playlist: playlist, receiverId: requesterId)
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
                if GlobalVariables.shared.currentUser!.isFavouriteAlbum(album)
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
    
    private func getRemovePlaylistMenuItem(playlist: Playlist, requesterId: Int) -> UIAction
    {
        return UIAction(title: "Remove Playlist", image: UIImage(systemName: "minus.circle")!) { [unowned self] _ in
            onRemovePlaylistMenuItemTap(playlist: playlist, receiverId: requesterId)
        }
    }
    
    private func getLoginForMoreOptionsMenuItem(requesterId: Int) -> UIAction
    {
        return UIAction(title: "Login to get more option(s)", image: UIImage(systemName: "person.crop.circle.fill")!, handler: { [unowned self] _ in
            onLoginRequestMenuItemTap(receiverId: requesterId)
        })
    }
    
    func getSongMenu(song: Song, requesterId: Int, requiresTranslucentSelectionScreen: Bool = false) -> UIMenu
    {
        return SessionManager.shared.isUserLoggedIn ? UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [
            getAddOrRemoveSongDeferredMenuItem(song: song, requesterId: requesterId),
            getAddSongToPlaylistFavMenuItem(song: song, requesterId: requesterId, requiresTranslucentSelectionScreen: requiresTranslucentSelectionScreen),
            getShowAlbumMenuItem(song: song, requesterId: requesterId)
        ]) : UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [
            getShowAlbumMenuItem(song: song, requesterId: requesterId),
            getLoginForMoreOptionsMenuItem(requesterId: requesterId)
        ])
    }
    
    func getAlbumSongMenu(song: Song, requesterId: Int, requiresTranslucentSelectionScreen: Bool = false) -> UIMenu
    {
        return SessionManager.shared.isUserLoggedIn ? UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [
            getAddOrRemoveSongDeferredMenuItem(song: song, requesterId: requesterId),
            getAddSongToPlaylistFavMenuItem(song: song, requesterId: requesterId, requiresTranslucentSelectionScreen: requiresTranslucentSelectionScreen)
        ]) : UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [
            getLoginForMoreOptionsMenuItem(requesterId: requesterId)
        ])
    }
    
    func getPlaylistSongMenu(song: Song, playlist: Playlist, requesterId: Int, requiresTranslucentSelectionScreen: Bool = false) -> UIMenu
    {
        return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [
            getAddOrRemoveSongDeferredMenuItem(song: song, requesterId: requesterId),
            getAddSongToPlaylistFavMenuItem(song: song, requesterId: requesterId, requiresTranslucentSelectionScreen: requiresTranslucentSelectionScreen),
            getRemoveSongFromPlaylistMenuItem(song: song, playlist: playlist, requesterId: requesterId),
            getShowAlbumMenuItem(song: song, requesterId: requesterId)
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
    
    func getPlaylistMenu(playlist: Playlist, requesterId: Int) -> UIMenu
    {
        UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [
            getRemovePlaylistMenuItem(playlist: playlist, requesterId: requesterId)
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
    
    func getPreviousSongsMenu(playlist: Playlist, requesterId: Int) -> UIMenu
    {
        let currentSong = GlobalVariables.shared.currentSong!
        let indexOfSong = playlist.songs!.firstIndex(of: currentSong)!
        let previousIndex = playlist.songs!.index(before: indexOfSong)
        let startIndex = playlist.songs!.startIndex
        guard previousIndex >= startIndex else
        {
            let noSongsFoundAction = UIAction(title: "Tapping Previous Button will play the last Song.", image: nil,attributes: .disabled, handler: { _ in })
            return UIMenu(title: "No Previous Song", image: nil, identifier: nil, options: .displayInline, children: [
                noSongsFoundAction
            ])
        }
        let numberOfElements = previousIndex - startIndex + 1
        var previousSongs = Array(playlist.songs![startIndex...previousIndex])
        if numberOfElements > 5
        {
            previousSongs = Array(previousSongs[0..<5])
        }
        if !previousSongs.isEmpty
        {
            var menuElements: [UIAction] = []
            for song in previousSongs
            {
                let songAction = UIAction(title: song.title!, image: UIImage(systemName: "music.note")!, handler: { [unowned self] _ in
                    onPreviousSongClick(song: song, receiverId: requesterId)
                })
                menuElements.append(songAction)
            }
            return UIMenu(title: "Previous Songs (5)", image: nil, identifier: nil, options: .displayInline, children: menuElements)
        }
        else
        {
            let noSongsFoundAction = UIAction(title: "Tapping Previous Button will play the last Song.", image: nil,attributes: .disabled, handler: { _ in })
            return UIMenu(title: "No Previous Song", image: nil, identifier: nil, options: .displayInline, children: [
                noSongsFoundAction
            ])
        }
    }
    
    func getUpcomingSongsMenu(playlist: Playlist, requesterId: Int) -> UIMenu
    {
        let currentSong = GlobalVariables.shared.currentSong!
        let indexOfSong = playlist.songs!.firstIndex(of: currentSong)!
        let nextIndex = playlist.songs!.index(after: indexOfSong)
        let endIndex = playlist.songs!.endIndex
        guard nextIndex <= endIndex - 1 else
        {
            let noSongsFoundAction = UIAction(title: "Tapping Next Button will play the first Song.", image: nil,attributes: .disabled, handler: { _ in })
            return UIMenu(title: "No Upcoming Song", image: nil, identifier: nil, options: .displayInline, children: [
                noSongsFoundAction
            ])
        }
        let numberOfElements = endIndex - nextIndex
        var upcomingSongs = Array(playlist.songs![nextIndex..<endIndex])
        if numberOfElements > 5
        {
            upcomingSongs = Array(upcomingSongs[0..<5])
        }
        if !upcomingSongs.isEmpty
        {
            var menuElements: [UIAction] = []
            for song in upcomingSongs
            {
                let songAction = UIAction(title: song.title!, image:  UIImage(systemName: "music.note")!, handler: { [unowned self] _ in
                    onUpcomingSongClick(song: song, receiverId: requesterId)
                })
                menuElements.append(songAction)
            }
            return UIMenu(title: "Upcoming Songs (5)", image: nil, identifier: nil, options: .displayInline, children: menuElements)
        }
        else
        {
            let noSongsFoundAction = UIAction(title: "Tapping Next Button will play the first Song.", image: nil,attributes: .disabled, handler: { _ in })
            return UIMenu(title: "No Upcoming Song", image: nil, identifier: nil, options: .displayInline, children: [
                noSongsFoundAction
            ])
        }
    }
}

extension ContextMenuProvider
{
    @objc private func onPreviousSongClick(song: Song, receiverId: Int)
    {
        NotificationCenter.default.post(name: .previousSongClickedNotification, object: nil, userInfo: ["receiverId" : receiverId, "song" : song])
    }
    
    @objc private func onUpcomingSongClick(song: Song, receiverId: Int)
    {
        NotificationCenter.default.post(name: .upcomingSongClickedNotification, object: nil, userInfo: ["receiverId" : receiverId, "song" : song])
    }
    
    @objc private func onAddSongToFavouritesMenuItemTap(song: Song, receiverId: Int)
    {
        NotificationCenter.default.post(name: .addSongToFavouritesNotification, object: nil, userInfo: ["receiverId" : receiverId,"song" : song])
    }
    
    @objc private func onRemoveSongFromFavouritesMenuItemTap(song: Song, receiverId: Int)
    {
        NotificationCenter.default.post(name: .removeSongFromFavouritesNotification, object: nil, userInfo: ["receiverId" : receiverId,"song" : song])
    }
    
    @objc private func onAddSongToPlaylistMenuItemTap(song: Song, receiverId: Int, requiresTranslucentSelectionScreen: Bool = false)
    {
        NotificationCenter.default.post(name: .addSongToPlaylistNotification, object: nil, userInfo: ["receiverId" : receiverId,"song" : song, "isTranslucent" : requiresTranslucentSelectionScreen])
    }
    
    
    @objc private func onRemoveSongFromPlaylistMenuItemTap(song: Song, playlist: Playlist, receiverId: Int)
    {
        NotificationCenter.default.post(name: .removeSongFromPlaylistNotification, object: nil, userInfo: ["receiverId" : receiverId,"song" : song, "playlist" : playlist])
    }
    
    @objc private func onAddAlbumToFavouritesMenuItemTap(album: Album, receiverId: Int)
    {
        NotificationCenter.default.post(name: .addAlbumToFavouritesNotification, object: nil, userInfo: ["receiverId" : receiverId,"album" : album])
    }
    
    @objc private func onRemovePlaylistMenuItemTap(playlist: Playlist, receiverId: Int)
    {
        NotificationCenter.default.post(name: .removePlaylistNotification, object: nil, userInfo: [ "receiverId" : receiverId, "playlist" : playlist ])
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
