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
    public static let shared = ContextMenuProvider()
    
    private lazy var heartIcon: UIImage = {
        return UIImage(systemName: "heart")!
    }()
    
    private lazy var heartFilledIcon: UIImage = {
        return UIImage(systemName: "heart.fill")!
    }()
    
    //Prevent Instantiation
    private init() {}
    
    deinit
    {
        print("Deinitializing ContextMenuProvider")
    }
    
    func getSongMenu(song: Song) -> UIMenu
    {
        let addSongToFavMenuItem = UIAction(title: "Add Song to Favourites", image: heartIcon) { [unowned self] action in
            //onSongFavouriteMenuItemTap(menuItem: menuItem, tag: item)
        }
        let removeSongFromFavMenuItem = UIAction(title: "Remove Song from Favourites", image: heartFilledIcon) { [unowned self] menuItem in
            //onSongFavouriteMenuItemTap(menuItem: menuItem, tag: item)
        }
        
        let addToPlaylistMenuItem = UIAction(title: "Add Song to Playlist", image: UIImage(systemName: "text.badge.plus")!) { [unowned self] menuItem in
            //onSongAddToPlaylistMenuItemTap(menuItem: menuItem, tag: item)
        }
        let showAlbumMenuItem = UIAction(title: "Show Album", image: UIImage(systemName: "music.note.list")) { [unowned self] menuItem in
            onShowAlbumMenuItemTap(song: song)
        }
        let songDeferredMenuItem = UIDeferredMenuElement.uncached({ completion in
            DispatchQueue.main.async {
                if GlobalVariables.shared.currentUser!.favouriteSongs!.contains(song)
                {
                    completion([removeSongFromFavMenuItem])
                }
                else
                {
                    completion([addSongToFavMenuItem])
                }
            }
        })
        return SessionManager.shared.isUserLoggedIn ? UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [
            songDeferredMenuItem, addToPlaylistMenuItem, showAlbumMenuItem
        ]) : UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [
            showAlbumMenuItem
        ])
    }
}

extension ContextMenuProvider
{
    @objc private func onShowAlbumMenuItemTap(song: Song)
    {
        NotificationCenter.default.post(name: .showAlbumTapNotification, object: nil, userInfo: ["song" : song])
    }
}
